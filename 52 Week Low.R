#Scraping data from tradingview.com

#NOTE: tradingview.com often changes the columns of its 52-week low table column names. 
#This may require adjustments in the code.

#Loading libraries
library(xml2)
library(rvest)
library(stringr)
library(dplyr)
library(RSelenium)

#Reading the table from the website
link = "https://www.tradingview.com/markets/stocks-usa/market-movers-52wk-low/"
page = read_html(link)
col_table = page %>% html_nodes('table') %>% html_table() %>% .[[1]]
#View(col_table)


#Reading the table from the website
link = "https://www.tradingview.com/markets/stocks-usa/market-movers-52wk-low/"
page = read_html(link)
col_table = page %>% html_nodes('table') %>% html_table() %>% .[[1]]
View(col_table)

#Adding variable names to the columns
colnames(col_table)[colnames(col_table) == 'P/E'] <- 'PE'


#colnames(col_table) <- c('Ticker','lastprice','chg%','vol','mkt cap','PE','eps(ttm)','eps(ttm) growth','Dividend yield %','sector','rating')
col_table$PE <-as.numeric(col_table$PE) #Converting PE into numeric variable
lowPE <- subset(col_table, PE < 20) #Getting list of stocks with low PE
lowPE <- data.frame(lowPE)

lowPE$Price <-  gsub("USD", "", lowPE$Price)
lowPE$Price <- as.numeric(lowPE$Price)

#Separating tickers from the symbol
lowPE$ticker <- regmatches(lowPE$Symbol, regexpr("\\b[A-Z]+(?![a-z])", lowPE$Symbol, perl = TRUE))

View(lowPE)

#Writing the csv file onto your computer.
#setwd("DIRECTORY PATH")
#write.csv(lowPE, file = paste("52_week_low_PE_stocks", "_",Sys.Date(),".csv"), row.names=TRUE)