library(rtweet)
library(tidytext)
library(tidyverse)

#pulse night club shooting

pulse1 <- search_fullarchive('"pulse nightclub"',
                                 n = 100, 
                                 fromDate = "2016-06-12",
                                 toDate = "2016-06-13",
                                 env_name = "dev")


pulse2 <- search_fullarchive('"pulse nightclub"',
                             n = 100, 
                             fromDate = "2016-06-13",
                             toDate = "2016-06-14",
                             env_name = "dev")

pulse3 <- search_fullarchive('"pulse nightclub"',
                             n = 100, 
                             fromDate = "2016-06-14",
                             toDate = "2016-06-15",
                             env_name = "dev")

pulse4 <- search_fullarchive('"pulse nightclub"',
                             n = 100, 
                             fromDate = "2016-06-15",
                             toDate = "2016-06-16",
                             env_name = "dev")

pulse5 <- search_fullarchive('"pulse nightclub"',
                             n = 100, 
                             fromDate = "2016-06-16",
                             toDate = "2016-06-17",
                             env_name = "dev")

pulse6 <- search_fullarchive('"pulse nightclub"',
                             n = 100, 
                             fromDate = "2016-06-17",
                             toDate = "2016-06-18",
                             env_name = "dev")

pulse7 <- search_fullarchive('"pulse nightclub"',
                             n = 100, 
                             fromDate = "2016-06-18",
                             toDate = "2016-06-19",
                             env_name = "dev")


#combined dataset
pulse <- rbind(pulse1, pulse2, pulse3, pulse4, pulse5, pulse6, pulse7) %>%
  distinct(text, .keep_all = TRUE) %>% 
  filter(lang == "en")

write_rds(pulse, "raw_tweets/pulse.rds")
