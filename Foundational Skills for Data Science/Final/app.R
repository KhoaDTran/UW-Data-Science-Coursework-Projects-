library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)
library(rsconnect)
library(plotly)

source("app_ui.R")
source("app_server.R")

shinyApp(ui = app_ui, server = app_server)