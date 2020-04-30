library(rtweet)
library(ggmap)
library(tidyverse)


#sandy hook example 

sandy_hook <- search_fullarchive('"Sandy Hook"',
                            n = 10, 
                            fromDate = "2012-12-14",
                            toDate = "2012-12-15",
                            env_name = "dev")
