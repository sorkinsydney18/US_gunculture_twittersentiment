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

#clean tweet text 

combined_clean <- combined %>% 
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
  group_by(id, status_id) %>% 
  mutate(twt_sentiment = sum(word_sentiment)) %>% 
  group_by(date) %>% 
  mutate(avg_sentiment = mean(twt_sentiment)) %>% 
  ungroup()

#save cleaned data
write_rds(combined_clean, "cleaned_tweets/combined_clean.rds")

##test plot 
combined_clean %>% 
  filter(id == "Pulse Nightclub") %>% 
  ggplot(aes(y = avg_sentiment, x = date)) +
  geom_line() +
  labs(y = "Average Tweet Sentiment",
       x = "") +
  
  #add positive/negative indicator
  geom_hline(yintercept=0, linetype="dashed", color = "firebrick1") +
  theme_minimal() +
  theme(panel.background = element_rect(fill = "lightblue"))
  

#scaling for sandy hook plot
  #scale_x_date(breaks = as.Date(c("2012-12-14", "2012-12-15", "2012-12-16", "2012-12-17"," 2012-12-18", "2012-12-19", "2012-12-20")), 
                   #labels = c("Dec 14", "Dec 15", "Dec 16", "Dec 17", "Dec 18", "Dec 19", "Dec 20")) +
  #scale_y_continuous(limits = c(-1,0))
  
##NRC Sentiment

