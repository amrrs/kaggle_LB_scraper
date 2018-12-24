#devtools::install_github("ropensci/RSelenium")

library(RSelenium)
library(rvest)

#setwd("/Documents/R Codes") #define your working directory here where the screenshot will be saved

rD <- rsDriver(browser = "firefox")


remDr <- rD[["client"]]



#competition_url <- "https://www.kaggle.com/c/ga-customer-revenue-prediction/leaderboard"


competition_url <- "https://www.kaggle.com/c/traveling-santa-2018-prime-paths/leaderboard"



remDr$navigate(competition_url)


remDr$executeScript("window.scrollTo(document.body.scrollHeight,10000)")

smart_list <- remDr$findElement("class name","competition-leaderboard__load-more-count")

smart_list$clickElement()

remDr$setImplicitWaitTimeout(milliseconds = 10000)

remDr$executeScript("window.scrollTo(0, document.body.scrollHeight)")


#remDr$executeScript('window.onscroll = function(ev) {
#    if ((window.innerHeight + window.pageYOffset) >= document.body.offsetHeight) {
#        alert("youre at the bottom of the page");
#    }
#};')


#remDr$dismissAlert()


source <- remDr$getPageSource()


df <- read_html(as.character(source)) %>% html_table() %>% as.data.frame()

#time for some insights

library(tidyverse)

new_df <- df[,c(1,3,6,7)]

names(new_df) <- c("rank","Team_Name","Score","Entries")

# Top 10 Rank Holders


top_10_by_score <- new_df %>% arrange(rank) %>% 
  slice(1:10)

top_10_by_score


top_10_by_entries <- new_df %>% arrange(desc(Entries)) %>% 
  slice(1:10)

top_10_by_entries

