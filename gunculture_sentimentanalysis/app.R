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
combined_clean <- read_rds("cleaned_tweets/combined_clean.rds")
sentiment <- read_rds("cleaned_tweets/sentiment.rds")
nrc_dictionary <- read_rds("cleaned_tweets/nrc_dictionary.rds")
nrc <- read_rds("cleaned_tweets/nrc.rds")

ui <- navbarPage("",
                 theme = shinytheme("journal"),
                 
                 #########
                 ##ABOUT##
                 #########
                 
                 tabPanel("About",
                          
                          fluidPage(
                          
                          h1("Loaded Words", align = "center"),
                          
                          fluidRow(column(2), column(8,
                                                     h4(id = "sub_heading", "Sandy Hook, Orlando, Las Vegas, and Parkland were some of the deadliest
                                                        shootings in American History. How did Twitter respond?", 
                                                        align = "center",
                                                        style = "color: #b22222;"))
                                                     ),
                          
                       
                          
      
                          
                          imageOutput("gun_silo", width = "100%", height = "100%"),
                          
                          br(),
                          br(),
                          
                          fluidRow(column(2), column(8,
                          
                          h4("Purpose", 
                             align = "center",
                             style = "color: #b22222;"),
                          
                          span(),
                          
                          p("The Sandy Hook Elementary school shooting was one of the deadliest shootings in U.S. history. 
                            Then Pulse Nightclub happened. Then Las Vegas happened. Then Parkland happened. 
                            These four shootings mark some of the most horrific events in recent history, 
                            but these shootings are just 4 out of ",
                            
                            a(href = "https://www.vox.com/a/mass-shootings-america-sandy-hook-gun-violence", "2,444"),
                            
                            " mass shootings in the U.S. 
                            The U.S. leads all developed countries in gun-related deaths yet has some 
                            of the weakest gun laws internationally. The debate surrounding firearm 
                            restriction has reached a fever pitch since Sandy Hook. To get a better sense 
                            of the national conversation, I looked to Twitter for answers. "),
                          
                          br(),
                          
                          imageOutput("divider", width = "100%", height = "100%"),
                          
                          br(),
                        
                          h4("About this Project", 
                             align = "center",
                             style = "color: #b22222;"),
                          
                          span(),
                          
                          p("This project seeks to provide a snapshot of online Twitter dialogue post-shooting. 
                            How are we talking about mass shootings? What emotions are most prevalent? 
                            What words do we use to talk about these shootings? How has the language used 
                            to describe each shooting changed? Explore each figure to get an understanding 
                            of how America talked and felt after Sandy Hook, Orlando, Las Vegas, and Parkland.")))
                          
                          
                          )),
                 
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
                                                  "Parkland, FL (Marjory Stoneman Douglas High School)" = 
                                                    "Parkland, FL (Marjory Stoneman Douglas High School)")
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
                                                           "Parkland, FL (Marjory Stoneman Douglas High School)" = 
                                                             "Parkland, FL (Marjory Stoneman Douglas High School)")
                                                       ),
                                           br(),
                                           br(),
                                           
                                           helpText("Search for a word or emotional category to explore the dictionary."),
                                           
                                           br(),
                                           
                                           #word search for table
                                           
                                           textInput("word", "Word",
                                                     placeholder = '"happy"'),
                                           
                                           #emotional filter for table
                                           
                                           checkboxGroupInput("sentiment", "Emotion",
                                                        choices = list(
                                                          "All" = "",                                                          "Anger" = "anger",
                                                          "Anticipation" = "anticipation",
                                                          "Disgust" = "disgust",
                                                          "Fear" = "fear",
                                                          "Joy" = "joy",
                                                          "Sadness" = "sadness",
                                                          "Surprise" = "surprise",
                                                          "Trust" = "trust"),
                                                        selected = "")),
                                       
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
                 
                 tabPanel("Trends",
                          
                          h2("What language is used to talk about mass shootings?", align = "center"),
                          
                          br(), 
                          
                          h4("Most commmon words used"),
                          
                          plotOutput("full_common_words"),
                          
                          br(),
                          br(),
                          
                          h4("Get a closer look at common words used for each shooting"),
                          
                          sidebarLayout(position = "right",
                            sidebarPanel(
                              
                              helpText("select a mass shooting"),
                              
                              selectInput("id2", NULL,
                                          choices = list(
                                            "Sandy Hook" = "Sandy Hook",
                                            "Pulse Nightclub" = "Pulse Nightclub",
                                            "Las Vegas (Route 91 Music Festival)" = "Las Vegas (Route 91 Music Festival)",
                                            "Parkland, FL (Marjory Stoneman Douglas High School)" = 
                                              "Parkland, FL (Marjory Stoneman Douglas High School)"))),
                              
                              mainPanel(plotOutput("filtered_common_words"))
                              
                              
                          )
                          ),
                 
                 #############
                 ##FOOTNOTES##
                 #############
                 
                 
                 tabPanel("Footnotes",
                          
                          br(),
                          br(),
                          p("Code used to source this project can be found ",
                            a(href = "https://github.com/sorkinsydney18/gened1073_final", "here.")),
                          
                          p("To conduct sentiment analysis I used the Syuzhet CRAN package and NRC lexicon
                            developed by Saif Mohammad."),
                          
                          p("To explore more of my projects check out my GitHub account ",
                            a(href = "https://github.com/sorkinsydney18", "here.")))
                 
                 
                          )
    
    
    
    
    
    
server <- function(input, output) {
    
    #########
    ##ABOUT##
    #########

  output$gun_silo <- renderImage({
    
    list(src = 'www/gun_silo.jpg',
         height = 300,
         width = 500,
         style = "display: block; margin-left: auto; margin-right: auto;")},
    deleteFile = FALSE
  )
    
  output$divider <- renderImage({
    
    list(src = 'www/divider.png',
         height = 40,
         width = 80,
         style = "display: block; margin-left: auto; margin-right: auto;")},
    deleteFile = FALSE
  )
    
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
          ) %>% 
        
        filter(
          if (input$sentiment != "") {
            sentiment %in% input$sentiment
          }
          
          else {sentiment == sentiment}
          )
        
        #filter by emotion
      
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

  
  #common words barplot of all 4 shootings
  
 output$full_common_words <- renderPlot({
   
   full_common_words <- combined_clean %>%
     
     #filter out names of places
     filter(!word %in% c("sandy", "hook", "elementary", "school", "connecticut", "amp", "newtown", "ct",
                         "pulse", "nightclub", "orlando", 
                         "las", "vegas", 
                         "parkland", "florida", "douglas", "stoneman", "17")) %>%
     
     count(word, sort = TRUE) %>%
     top_n(15) %>%
     mutate(word = reorder(word, n))
   
   #set expanded palette for plot
   
   colourCount = length(unique(full_common_words$word))
   getPalette = colorRampPalette(brewer.pal(9, "Oranges"))
   
   full_common_words %>% 
     ggplot(aes(x = word, y = n, fill = word)) +
     geom_col() +
     xlab(NULL) +
     coord_flip() +
     labs(x = "",
          y = "Count") +
     theme_minimal() +
     scale_fill_manual(values = getPalette(colourCount)) +
     theme(legend.position = "none",
           panel.background = element_rect(fill = "seashell2"),
           axis.text.y = element_text(size = 12, face = "bold"))
   
 }) 
  
 #filtered barplot by input
  
  output$filtered_common_words <- renderPlot({
    
    filtered_common_words <- combined_clean %>%
      
      #new id for shiny input
      
      mutate(id2 = id) %>% 
      select(id2, word) %>% 
      
      filter(!word %in% c("sandy", "hook", "elementary", "school", "connecticut", "amp", "newtown", "ct",
                          "pulse", "nightclub", "orlando", 
                          "las", "vegas", 
                          "parkland", "florida", "douglas", "stoneman", "17")) %>%
      
      #filter by shiny input
      
      filter(id2 == input$id2) %>% 
      
      count(word, sort = TRUE) %>%
      top_n(15) %>%
      mutate(word = reorder(word, n))
    
    #expanded palette
    
    colourCount2 = length(unique(filtered_common_words$word))
    getPalette2 = colorRampPalette(brewer.pal(9, "Blues"))
    
    filtered_common_words %>% 
      
      ggplot(aes(x = word, y = n, fill = word)) +
      geom_col() +
      xlab(NULL) +
      coord_flip() +
      labs(x = "",
           y = "Count") +
      theme_minimal() +
      scale_fill_manual(values = getPalette2(colourCount2)) +
      theme(legend.position = "none",
            panel.background = element_rect(fill = "snow1"),
            axis.text.y = element_text(size = 12, face = "bold")) 
    
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
