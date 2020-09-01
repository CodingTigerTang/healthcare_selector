library(shiny)
library(shinythemes)
library(ggplot2)
library(tidyverse)
library(plotly)
library(DT)
library(shinyFeedback)
library(scales)


bill_cal <- function(bill,deductable,out_of_pocket,coinsurance) {
  
  if (bill <= deductable) {
    
    return(bill)
  } else if (bill <= (out_of_pocket/coinsurance*100 + deductable)) {
    
    return(deductable + (bill-deductable)*coinsurance/100)
  } else {
    return(deductable + out_of_pocket)
  }
}

pay_cal <- function(bill=0,deductable,out_of_pocket,coinsurance,premium, HSA_contribution, company_match) {
  bill_cal(bill,deductable,out_of_pocket,coinsurance) + premium*12 + HSA_contribution - company_match
  
}
