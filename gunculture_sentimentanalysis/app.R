#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(DT)
library(tm)
library(tidyverse)



#load sentiment analysis data
sentiment <- read_rds("cleaned_tweets/sentiment.rds")
nrc_dictionary <- read_rds("cleaned_tweets/nrc_dictionary.rds")
nrc <- read_rds("cleaned_tweets/nrc.rds")

ui <- navbarPage("Title",
                 theme = shinytheme("journal"),
                 
                 #########
                 ##ABOUT##
                 #########
                 
                 tabPanel("About"),
                 
                 #############
                 ##SENTIMENT##
                 #############
                 
                 tabPanel("Sentiment",
                          tabsetPanel(
                              tabPanel("Daily Sentiment",
                          
                          sidebarLayout(
                              sidebarPanel(
                                  h4("Track tweet sentiment each day after the shooting"),
                                  
                                  br(), 
                                  
                                  selectInput("id", NULL,
                                              choices = list(
                                                  "Sandy Hook" = "Sandy Hook",
                                                  "Pulse Nightclub" = "Pulse Nightclub",
                                                  "Las Vegas (Route 91 Music Festival)" = "Las Vegas (Route 91 Music Festival)",
                                                  "Parkland, FL (Marjory Stoneman Douglas High School)" = "Parkland, FL (Marjory Stoneman Douglas High School)"),
                                              ),
                                  br(),
                                  
                                  p("Sentiment scores range from -1 to 1, most negative to most postive respectively")),
                              
                              
                              mainPanel(plotOutput("weekly_sentiment"),
                              
                              div(),
                              
                              p("Sentiment Analysis Scoring:"),
                              
                              span(),
                              
                              p("Each tweet is broken down into a set of words. Each word is then matched with
                                an existing sentiment score. The total sentiment score for each tweet is simply
                                the sum of scores for each word. The plot above shows the average tweet sentiment
                                each day.")))),
                          
                          tabPanel("Sentiment By Emotion",
                                   
                                   sidebarLayout(
                                       sidebarPanel(
                                           
                                           h4("See the emotional breakdown of all tweets"),
                                           
                                           br(),
                                           
                                           selectInput("id1", NULL,
                                                       choices = list(
                                                           "Sandy Hook" = "Sandy Hook",
                                                           "Pulse Nightclub" = "Pulse Nightclub",
                                                           "Las Vegas (Route 91 Music Festival)" = "Las Vegas (Route 91 Music Festival)",
                                                           "Parkland, FL (Marjory Stoneman Douglas High School)" = "Parkland, FL (Marjory Stoneman Douglas High School)"),
                                                       ),
                                           br(),
                                           br(),
                                           
                                           helpText("Search for a word to see which emotional categories it belongs under."),
                                           
                                           br(),
                                           
                                           textInput("word", NULL,
                                                     placeholder = '"happy"')),
                                       
                                       mainPanel(
                                           plotOutput("nrc_plot"),
                                                 
                                                 div(),
                                                 
                                                 p("The emotional count of each tweet is compromised by finding words in each tweet that fall under the 
                                                   predetermined emotional categories: anger, anticipation, disgust, fear, joy, sadness, surprise, trust.
                                                   Any word that is tagged recieves a score of 1 for that particular category. The plot above shows the 
                                                   count of words for each category."),
                                                 
                                                 br(),
                                                 
                                           #ADD TITLE INSTEAD?
                                                 p("For more on the emotional lexicon used to score the tweets see below."),
                                           
                                           br(),
                                           
                                           DTOutput("nrc_dictionary"))
                                       )
                                   )
                                   )),
                 
                 ##########
                 ##TRENDS##
                 ##########
                 
                 tabPanel("Trends"))
    
    
    
    
    
    
server <- function(input, output) {
    
    #########
    ##ABOUT##
    #########

    #############
    ##SENTIMENT##
    #############
    
    #sentiment line plot for each shooting
    
    output$weekly_sentiment <- renderPlot({
        
        sentiment %>% 
            filter(id == input$id) %>% 
            
            ggplot(aes(y = avg_sentiment, x = date)) +
            geom_line() +
            labs(y = "Average Tweet Sentiment",
                 x = "") +
            
            #add positive/negative indicator
            geom_hline(yintercept=0, linetype="dashed", color = "firebrick1") +
            theme_minimal() +
            theme(panel.background = element_rect(fill = "lightblue")) +
            scale_x_date(date_labels="%b %d",date_breaks  ="1 day")
        
    })
    
#emotional word plot
    
    output$nrc_plot <- renderPlot({
      
      nrc %>% 
        filter(id1 == input$id1) %>% 
        
        ggplot(aes(x = reorder(sentiment, -n), y = n, fill = sentiment)) +
        geom_col() +
        theme(legend.position = "none", 
              axis.text.x = element_text(angle = 25)) +
        labs(x = "",
             y = "count")
    })
    
  
  #nrc dictionary table
  
  output$nrc_dictionary <- renderDT({
      
      #save as reactive datatable
      
      nrc_dic_reac <- nrc_dictionary %>% 
          
          #allows data to appear by default without search term entered
          
          filter(
              if (input$word != "") {
                  word == input$word
              }
              
              else {word == word}
          )
      
      datatable(nrc_dic_reac,
                class = 'display',
                rownames = FALSE,
                selection = 'single',
                colnames = c("Word", "Emotion", "Value"),
                options = list(searching = FALSE))
  })
    
   
    
    ##########
    ##TRENDS##
    ##########

}

# Run the application 
shinyApp(ui = ui, server = server)
