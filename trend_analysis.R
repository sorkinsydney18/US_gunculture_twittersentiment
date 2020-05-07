####TRENDS TAB########
library(tidytext)
library(tm)
library(RColorBrewer)
library(tidyverse)

combined_clean <- read_rds("cleaned_tweets/combined_clean.rds")
sentiment <- read_rds("cleaned_tweets/sentiment.rds")

##common word plot

#combined plot
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

#filtered plots

filtered_common_words <- combined_clean %>%
  
  #new id for shiny input
  
  mutate(id2 = id) %>% 
  select(id2, word) %>% 
  
  filter(!word %in% c("sandy", "hook", "elementary", "school", "connecticut", "amp", "newtown", "ct",
                      "pulse", "nightclub", "orlando", 
                      "las", "vegas", 
                      "parkland", "florida", "douglas", "stoneman", "17")) %>%
  
  #filter by shiny input
  
  filter(id2 == "Parkland, FL (Marjory Stoneman Douglas High School)") %>% 
  
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
  labs(x = "Count",
       y = "Unique words") +
  theme_minimal() +
  scale_fill_manual(values = getPalette2(colourCount2)) +
  theme(legend.position = "none",
        panel.background = element_rect(fill = "snow1"),
        axis.text.y = element_text(size = 12, face = "bold"))



#common affect words plot (ALL)

sentiment %>%
  
  #filter for affect words
  
  filter(word_sentiment != 0.00) %>% 
  
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col(fill = "steelblue") +
  xlab(NULL) +
  coord_flip() +
  labs(x = "Count",
       y = "Unique words") +
  theme_minimal()

##paired words 

tweets_paired <- combined_clean %>%
  select(user_id, status_id, date, location, tweet_text1)
  mutate(tweet_text1 = removeWords(tweet_text1, stop_words$word)) %>%
  mutate(tweet_text1 = gsub("\\brt\\b|\\bRT\\b", "", tweet_text1)) %>%
  mutate(tweet_text1 = gsub("http://*", "", tweet_text1)) %>%
  unnest_tokens(paired_words, tweet_text1, token = "ngrams", n = 2, collapse = FALSE)

  #filter out places again
  #filter(!paired_words %in% c("sandy hook", "hook elementary", "elementary school", "hook shooting",
                              "pulse nightclub", "nightclub shooting",
                              "las vegas", "vegas shooting", 
                              "parkland florida", "parkland shooting", "parkland school", "stoneman douglas")) 


#look for key phrases (gun control, gun violence, gun rights, assault weapon, common sense, gun laws)
tweets_paired %>%
  count(paired_words == "household firearm")  
  
