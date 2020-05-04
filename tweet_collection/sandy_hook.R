library(rtweet)
library(tidytext)
library(tidyverse)


#sandy hook data

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

sandyhook4 <- search_fullarchive('"Sandy Hook"',
                                 n = 100, 
                                 fromDate = "2012-12-17",
                                 toDate = "2012-12-18",
                                 env_name = "dev")

sandyhook5 <- search_fullarchive('"Sandy Hook"',
                                 n = 100, 
                                 fromDate = "2012-12-18",
                                 toDate = "2012-12-19",
                                 env_name = "dev")

sandyhook6 <- search_fullarchive('"Sandy Hook"',
                                 n = 100, 
                                 fromDate = "2012-12-19",
                                 toDate = "2012-12-20",
                                 env_name = "dev")

sandyhook7 <- search_fullarchive('"Sandy Hook"',
                                 n = 100, 
                                 fromDate = "2012-12-20",
                                 toDate = "2012-12-21",
                                 env_name = "dev")

#combined dataset 
sandyhook_old <- rbind(sandyhook1, sandyhook2, sandyhook3, sandyhook4, sandyhook5, sandyhook6, sandyhook7) 

write_rds(sandyhook_old, "raw_tweets/sandyhook_old.rds")

sandyhook <- sandyhook_old %>% 
  distinct(text, .keep_all = TRUE) %>% 
  filter(lang == "en")

write_rds(sandyhook, "raw_tweets/sandyhook.rds")
