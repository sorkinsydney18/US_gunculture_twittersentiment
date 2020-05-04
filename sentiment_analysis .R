####SENTIMENT TAB########
library(rtweet)
library(tidytext)
library(syuzhet)
library(lubridate)
library(tidyverse)

sandyhook <- read_rds("raw_tweets/sandyhook.rds")
pulse <- read_rds("raw_tweets/pulse.rds")
vegas <- read_rds("raw_tweets/vegas.rds")
parkland <- read_rds("raw_tweets/parkland.rds")


#clean tweet text 

sandyhook_clean <- sandyhook %>% 
  mutate(tweet_text = gsub("\\s?(f|ht)(tp)(s?)(://)([^\\.]*)[\\.|/](\\S*)", 
                           "", text)) %>% 
  
  #remove time from created_at 
  mutate(date = as.Date(ymd_hms(created_at))) %>% 
  unnest_tokens(word, tweet_text) %>% 
  anti_join(stop_words) %>% 
  
  # remove all rows that contain "rt" or retweet
  filter(!word == "rt") %>% 
  
  #get sentiment values 
  
  mutate(word_sentiment = get_sentiment(word, method = "syuzhet")) %>%
  group_by(status_id) %>% 
  mutate(twt_sentiment = sum(word_sentiment)) 

sandyhook_clean %>% 
  group_by(date) %>% 
  summarise(avg_sentiment = mean(twt_sentiment)) %>% 
  ggplot(aes(y = avg_sentiment, x = date)) +
  geom_line() +
  labs(y = "Average Tweet Sentiment",
       x = "") +
  scale_x_date(breaks = as.Date(c("2012-12-14", "2012-12-15", "2012-12-16", "2012-12-17"," 2012-12-18", "2012-12-19", "2012-12-20")), 
                   labels = c("Dec 14", "Dec 15", "Dec 16", "Dec 17", "Dec 18", "Dec 19", "Dec 20")) +
  scale_y_continuous(limits = c(-1,0))
  


