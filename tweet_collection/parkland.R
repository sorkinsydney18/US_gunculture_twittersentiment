library(rtweet)
library(tidytext)
library(tidyverse)

#parkland shooting data

parkland1 <- search_fullarchive("parkland shooting",
                             n = 100, 
                             fromDate = "2018-02-15",
                             toDate = "2018-02-16",
                             env_name = "dev")

parkland2 <- search_fullarchive("parkland shooting",
                                n = 100, 
                                fromDate = "2018-02-16",
                                toDate = "2018-02-17",
                                env_name = "dev")

parkland3 <- search_fullarchive("parkland shooting",
                                n = 100, 
                                fromDate = "2018-02-17",
                                toDate = "2018-02-18",
                                env_name = "dev")

parkland4 <- search_fullarchive("parkland shooting",
                                n = 100,
                                fromDate = "2018-02-18",
                                toDate = "2018-02-19",
                                env_name = "dev")

parkland5 <- search_fullarchive("parkland shooting",
                                n = 100, 
                                fromDate = "2018-02-19",
                                toDate = "2018-02-20",
                                env_name = "dev")

parkland6 <- search_fullarchive("parkland shooting",
                                n = 100, 
                                fromDate = "2018-02-20",
                                toDate = "2018-02-21",
                                env_name = "dev")

parkland7 <- search_fullarchive("parkland shooting",
                                n = 100, 
                                fromDate = "2018-02-21",
                                toDate = "2018-02-22",
                                env_name = "dev")

#combined dataset

parkland_old <- rbind(parkland1, parkland2, parkland3, parkland4, parkland5, parkland6, parkland7) 

write_rds(parkland_old, "raw_tweets/parkland_old.rds")

parkland <- parkland_old %>% 
  distinct(text, .keep_all = TRUE) %>% 
  filter(lang == "en")

write_rds(parkland, "raw_tweets/parkland.rds")
