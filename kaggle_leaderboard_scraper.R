#devtools::install_github("ropensci/RSelenium")

library(RSelenium)
library(rvest)
library(tidyverse)


#setwd("/Documents/R Codes") #define your working directory here where the screenshot will be saved

rD <- rsDriver(port = 123L,  browser = "firefox")


remDr <- rD[["client"]]



#competition_url <- "https://www.kaggle.com/c/ga-customer-revenue-prediction/leaderboard"


competition_url <- "https://www.kaggle.com/c/traveling-santa-2018-prime-paths"



remDr$navigate(paste0(competition_url,"/leaderboard"))

### scrolling the page to its bottom


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

#

lb <- read_html(as.character(source)) %>% html_table() %>% as.data.frame()

write.csv(lb,"lb.csv",row.names = F)


#time for some insights


new_df <- lb[,c(1,3,6,7)]

names(new_df) <- c("rank","Team_Name","Score","Entries")

# Top 10 Rank Holders

top_10_by_score <- new_df %>% arrange(rank) %>% 
  slice(1:10)

top_10_by_score


top_10_by_entries <- new_df %>% arrange(desc(Entries)) %>% 
  slice(1:10)

top_10_by_entries


## Public LB Score Density Plot

ggplot(lb) + 
  geom_density(aes(Score)) + 
  scale_x_log10() +
  theme_minimal() +
  labs(title = "Public LB Score Density Plot",
       subtitle = "with Logarithmic Score")


ggsave("score_density.png")
  
## Number of Entries Density Plot

ggplot(lb) + 
 # geom_histogram(aes(Entries)) +
  geom_density(aes(Entries)) + 
  scale_x_log10() +
  theme_minimal() +
  labs(title = "Number of Entries Density Plot")

ggsave("entries_density.png")

