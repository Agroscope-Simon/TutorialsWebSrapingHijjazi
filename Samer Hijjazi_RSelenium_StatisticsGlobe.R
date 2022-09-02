library(RSelenium)
library(tidyverse)
library(netstat)
library(rvest)

rs_driver_object <- rsDriver(
  browser = "chrome", 
  chromever = '105.0.5195.52', 
  verbose = F, 
  port = free_port()
)


# in console
binman::list_versions('chromedriver')

remDr <- rs_driver_object$client

# open browser session
remDr$open



# maximise windows size
remDr$maxWindows()



# go back
remDr$goBack()

# go forward
remDr$goForward()

# refresh
remDr$refresh()


# open website
remDr$navigate('https://statisticsglobe.com/')

# Remove Pop-up
remDr$findElement(using = 'xpath', '//*[@id="PopupSignupForm_0"]/div[2]/div[1]')$clickElement()

# CLick on MENU Element
remDr$findElement(using = 'xpath', '//a[@aria-label="Menu"]')$clickElement()

# chose element of drop down menu

remDr$findElement(using = 'xpath', '//a[@aria-label="Menu"]')$clickElement()
r_dropdown <- remDr$findElement(using = 'link text','R Programming')$clickElement()
remDr$mouseMoveToLocation(WebElement = r_dropdown)
remDr$findElement(using = 'link text','R Functions List')$clickElement()

# enter query in search
search_icon <- remDr$findElement(using = 'xpath', '//a[@aria-label="Search"]')
search_icon$clickElement()

search_box <- remDr$findElement(using = 'id', 'us_form_search_s')
search_box$clickElement
search_box$sendKeysToElement(list('ggplot2', key='enter'))

# Scroll through results
for (i in 1:5) {
  
remDr$executeScript('window.scrollTo(0, document.body.scrollHeight);')
Sys.sleep(3)

}


# Download all video titles

  tutorial_titles <- list()

for (i in (1:129)) {
  
  tutorial_titles[i] <- remDr$findElement(using = 'xpath', paste0('//*[@id="us_grid_1"]/div[1]/article[',i,']/div/h2/a'))$getElementText()
  
}

  tutorial_titles <- data.frame(tutorial_titles %>% unlist()) 

# download all video thumbnails links
  
  tutorial_images <- list()
  
  for (i in (1:129)) {
tutorial_images[i] <- remDr$findElement(using = 'xpath', paste0('//*[@id="us_grid_1"]/div[1]/article[',i,']/div/div/a/img'))$getElementAttribute('srcset')

  }

  tutorial_images <- data.frame(tutorial_images %>% unlist()) 
  
  
# close window
remDr$closeWindow()

# shut down process
system('taskkill /im java.exe /f')
