library(rtweet)
library(tidytext)
library(tidyverse)

#las vegas shooting data

vegas1 <- search_fullarchive('"las vegas" AND shooting',
                             n = 100, 
                             fromDate = "2017-10-01",
                             toDate = "2017-10-02",
                             env_name = "dev")


vegas2 <- search_fullarchive('"las vegas" AND shooting',
                             n = 100, 
                             fromDate = "2017-10-02",
                             toDate = "2017-10-03",
                             env_name = "dev")

vegas3 <- search_fullarchive('"las vegas" AND shooting',
                             n = 100, 
                             fromDate = "2017-10-03",
                             toDate = "2017-10-04",
                             env_name = "dev")

vegas4 <- search_fullarchive('"las vegas" AND shooting',
                             n = 100, 
                             fromDate = "2017-10-04",
                             toDate = "2017-10-05",
                             env_name = "dev")

vegas5 <- search_fullarchive('"las vegas" AND shooting',
                             n = 100, 
                             fromDate = "2017-10-05",
                             toDate = "2017-10-06",
                             env_name = "dev")

vegas6 <- search_fullarchive('"las vegas" AND shooting',
                             n = 100, 
                             fromDate = "2017-10-06",
                             toDate = "2017-10-07",
                             env_name = "dev")

vegas7 <- search_fullarchive('"las vegas" AND shooting',
                             n = 100, 
                             fromDate = "2017-10-07",
                             toDate = "2017-10-08",
                             env_name = "dev")

#combine data

vegas <- rbind(vegas1, vegas2, vegas3, vegas4, vegas5, vegas6, vegas7)