rm(list=ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(rsconnect)
library(shiny)
library(ggplot2)
library(dplyr) # select
library(DT)
# deployApp()
runApp()