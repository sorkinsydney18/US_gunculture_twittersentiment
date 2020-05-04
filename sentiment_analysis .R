####SENTIMENT TAB########
library(rtweet)
library(tidytext)
library(syuzhet)
library(tidyverse)

sandyhook <- read_rds("raw_tweets/sandyhook.rds")
pulse <- read_rds("raw_tweets/pulse.rds")
vegas <- read_rds("raw_tweets/vegas.rds")
parkland <- read_rds("raw_tweets/parkland.rds")


#clean tweet text 

sandyhook_clean <- sandyhook %>% 
  mutate(tweet_text = gsub("\\s?(f|ht)(tp)(s?)(://)([^\\.]*)[\\.|/](\\S*)", 
                           "", text)) %>% 
  unnest_tokens(word, tweet_text) %>% 
  anti_join(stop_words) %>% 
  
  # remove all rows that contain "rt" or retweet
  filter(!word == "rt") 


