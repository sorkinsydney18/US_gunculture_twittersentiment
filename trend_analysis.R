####TRENDS TAB########
library(tidytext)
library(tm)
library(tidyverse)

combined_clean <- read_rds("cleaned_tweets/combined_clean.rds")
sentiment <- read_rds("cleaned_tweets/sentiment.rds")

##common word plot

#combined plot
combined_clean %>%
  
  #filter out names of places
  filter(!word %in% c("sandy", "hook", "elementary", "school", "connecticut", "amp", "newtown", "ct",
                      "pulse", "nightclub", "orlando", 
                      "las", "vegas", 
                      "parkland", "florida", "douglas", "stoneman", "17")) %>%
  
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

#filtered plots

combined_clean %>%
  filter(!word %in% c("sandy", "hook", "elementary", "school", "connecticut", "amp", "newtown", "ct",
                      "pulse", "nightclub", "orlando", 
                      "las", "vegas", 
                      "parkland", "florida", "douglas", "stoneman", "17")) %>%
  
  #filter by shiny input
  
  filter(id == "Parkland, FL (Marjory Stoneman Douglas High School)") %>% 
  
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
  
