####SENTIMENT TAB########
library(rtweet)
library(tidytext)
library(syuzhet)
library(lubridate)
library(tm)
library(tidyverse)

sandyhook <- read_rds("raw_tweets/sandyhook.rds")
pulse <- read_rds("raw_tweets/pulse.rds")
vegas <- read_rds("raw_tweets/vegas.rds")
parkland <- read_rds("raw_tweets/parkland.rds")


#create dataset identifier before combining 

sandyhook <- sandyhook %>% 
  mutate(id = "Sandy Hook")

pulse <- pulse %>% 
  mutate(id = "Pulse Nightclub")

vegas <- vegas %>% 
  mutate(id = "Las Vegas (Route 91 Music Festival)")

parkland <- parkland %>% 
  mutate(id = "Parkland, FL (Marjory Stoneman Douglas High School)")


combined <- rbind(sandyhook, pulse, vegas, parkland)
write_rds(combined, "raw_tweets/combined.rds")

#clean tweet text 

combined_clean <- combined %>% 
  mutate(tweet_text = gsub("\\s?(f|ht)(tp)(s?)(://)([^\\.]*)[\\.|/](\\S*)", 
                           "", text)) %>% 
  #create cleaned text duplicate
  mutate(tweet_text1 = tweet_text) %>% 
  
  #remove time from created_at 
  mutate(date = as.Date(ymd_hms(created_at))) %>% 
  unnest_tokens(word, tweet_text) %>% 
  anti_join(stop_words) %>% 
  
  # remove all rows that contain "rt" or retweet
  filter(!word == "rt") 

#save cleaned data
write_rds(combined_clean, "cleaned_tweets/combined_clean.rds")

  
#get sentiment values 
  
sentiment <- combined_clean %>% 
  mutate(word_sentiment = get_sentiment(word, method = "syuzhet")) %>%
  group_by(id, status_id) %>% 
  mutate(twt_sentiment = sum(word_sentiment)) %>% 
  group_by(date) %>% 
  mutate(avg_sentiment = mean(twt_sentiment)) %>% 
  ungroup()

#save sentiment data
write_rds(sentiment, "cleaned_tweets/sentiment.rds")

##test plot 
sentiment %>% 
  filter(id == "Sandy Hook") %>% 
  ggplot(aes(y = avg_sentiment, x = date)) +
  geom_line() +
  labs(y = "Average Tweet Sentiment",
       x = "") +
  
  #add positive/negative indicator
  geom_hline(yintercept=0, linetype="dashed", color = "firebrick1") +
  theme_minimal() +
  theme(panel.background = element_rect(fill = "lightblue")) +
  
  #add date for all x axis ticks
  scale_x_date(date_labels="%b %d",date_breaks  ="1 day")
  
##NRC Sentiment

#save nrc dictionary for search table 

nrc_dictionary <- get_sentiment_dictionary(dictionary = "nrc", language = "english") %>% 
  select(-lang)

write_rds(nrc_dictionary, "cleaned_tweets/nrc_dictionary.rds")


#nrc emotional plot

nrc <- combined_clean %>%
  
  #new input id
  
  mutate(id1 = id) %>% 
  select(id1, status_id, date, word) %>% 
  
  #join tokenized words with words from nrc dictionary
  
  left_join(nrc_dictionary, by = c("word" = "word")) %>%
  
  #filter out non-matches
  
  filter(!is.na(sentiment)) %>% 
  group_by(id1) %>% 
  
  #count words by emotional category
  
  count(sentiment) %>% 
  filter(sentiment != "negative", sentiment != "positive") 


#save nrc data
write_rds(nrc, "cleaned_tweets/nrc.rds")


nrc %>% 
  filter(id1 == "Las Vegas (Route 91 Music Festival)") %>% 
  
  ggplot(aes(x = reorder(sentiment, -n), y = n, fill = sentiment)) +
  geom_col() +
  theme(legend.position = "none", 
        axis.text.x = element_text(angle = 25)) +
  labs(x = "",
       y = "count")
  
  
