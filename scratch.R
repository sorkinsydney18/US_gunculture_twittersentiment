library(rtweet)
library(ggmap)
library(tidytext)
library(tidyverse)


register_google(key = google_api_key)

#sandy hook example 
sandyhook1 <- search_fullarchive('"Sandy Hook"',
                            n = 100, 
                            fromDate = "2012-12-14",
                            toDate = "2012-12-15",
                            env_name = "dev")

sandyhook2 <- search_fullarchive('"Sandy Hook"',
                                 n = 100, 
                                 fromDate = "2012-12-15",
                                 toDate = "2012-12-16",
                                 env_name = "dev")

sandyhook3 <- search_fullarchive('"Sandy Hook"',
                                 n = 100, 
                                 fromDate = "2012-12-16",
                                 toDate = "2012-12-17",
                                 env_name = "dev")

combined <- rbind(sandy_hook1, sandyhook2, sandyhook3)

##gun language by state?

IL <- search_tweets("gun OR firearm filter:verified", 
                   n=100,
                   include_rts = FALSE,
                   geocode = lookup_coords("usa", apikey = google_api_key))




####analysis of cnn timeline 
stuff <- get_timeline(user = "@cnn", n = 3200)


  
stuff$stripped_text <- gsub("http.*","",  stuff$text)
stuff$stripped_text <- gsub("https.*","", stuff$stripped_text)


stuff_clean <- stuff %>% 
  unnest_tokens(word, stripped_text) %>% 
  anti_join(stop_words) %>% 
  select(status_id, text, location, word) %>% 
  mutate(trump = ifelse(word == "trump", 1, 0)) %>% 
  group_by(status_id) %>% 
  mutate(trump_logical  = sum(trump)) %>% 
  filter(trump_logical == 1) 
  
pulse <- search_tweets("shooting 'pulse nightclub'", n = 100)

sandyhook <- search_tweets("shooting 'sandy hook'", n = 100)

vegas <- search_tweets('"las vegas" AND shooting', n = 100)

parkland <- search_tweets("parkland OR 'marjory stoneman douglas' shooting", n = 100)
