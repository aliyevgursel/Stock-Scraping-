#Price Scraping Function

'This function gets the latest stock price from yahoo finance website. 
The function input is a stock ticker.'

library(xml2)
library(rvest)
library(stringr)
library(dplyr)
library(httr)

#assign user agent
PASS <-new.env()
assign("usrAgent","https://www.linkedin.com/in/gursel-aliyev-7ba5ba11/ aliyev_gursel@yahoo.com", env = PASS)

price_scrape <- function(ticker) {
#link <- paste0("https://finance.yahoo.com/quote/",ticker,"?p=",ticker,"&.tsrc=fin-srch")

link <- GET(url = paste0("https://finance.yahoo.com/quote/",ticker,"?p=",ticker,"&.tsrc=fin-srch"),
    config = httr::add_headers(`User-Agent` = PASS$usrAgent,
                               `Accept-Encoding`= 'gzip,deflate'))

#Reading the HTML code from the website
page <- read_html(link)

# Set the decimal separator to a period (.) to ensure proper conversion
#Sys.setlocale("LC_NUMERIC", "C")

#Using CSS selectors to scrape the price
price <- page %>% html_nodes(xpath ="//*[@class = 'Fw(b) Fz(36px) Mb(-4px) D(ib)']") %>% #xpath is used to avoid error because of the special characters in the node name
  xml_attr("value") %>% #extracting the price which is tagged as 'value' in the xml_nodeset
  #trimws() %>% #Removing leading and trailing whitespace
  as.numeric()

#options(digits = 7)
price <- round(price, 2) #rounding to the cents

return(price)
}



