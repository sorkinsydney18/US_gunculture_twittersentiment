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
library(tidyverse)



#load sentiment analysis data
sentiment <- read_rds("cleaned_tweets/sentiment.rds")

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
                                each day.")))
                         
                          ),
                 
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
            theme(panel.background = element_rect(fill = "lightblue"))
    })
    
    
    
    ##########
    ##TRENDS##
    ##########

}

# Run the application 
shinyApp(ui = ui, server = server)
