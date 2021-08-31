library(shiny)
library(tools)
library(ggplot2)
library(dplyr)

team_stats2016_17 <- read.csv(file = "data/2016-17combined.csv", stringsAsFactors = FALSE)
team_stats2018_19 <- read.csv(file = "data/2018-19combined.csv", stringsAsFactors = FALSE)

app_server <- function(input, output) {
  
  #Dataset for both data frames
  datasetInput <- reactive({
    switch(input$dataset,
           "df1" = team_stats2016_17,
           "df2" = team_stats2018_19)
  })
  
  #Output reactive slider
  output$slider <- renderUI({
    sliderInput("inslider","The Minimum Number of Wins",
                min = min(datasetInput()$wins),
                max = max(datasetInput()$wins),
                value = min(datasetInput()$wins))
  })
    
  #Define a wins breakdown table to render in the UI
  output$wins_table <- renderTable({
    #Create the interactive table that selects the offensive statistics of teams that meet the number of minimum wins 
    table <- datasetInput() %>%
      filter(wins >= input$inslider) %>% #Select only teams with the minimum number of wins
      #Select desired output columns
      select(Team, FG., X3P., FT. , AST, ORB)
    
    #Rename the display columns
    colnames(table) <- c("Team", "Field Goal Percent", "Three Point Percentage", 
                         "Free Throw Percentage", "Assist", 
                         "Offensive Rebounds")
    #Return table
    table
  })
  
  datasetInputs <- reactive({
    switch(input$datasets,
           "df11" = team_stats2016_17,
           "df22" = team_stats2018_19)   
  })      
  # Render Scatterplot
  output$scatter <- renderPlotly({
    scatter_plot <- datasetInputs() %>% 
      ggplot() +
      geom_point(mapping = aes_string(x = "wins", y = input$button)) +
      labs(title = "Defensive Stats vs. Wins",
           x = "Wins", y = "Defensive Stats")
    ggplotly(scatter_plot)
  })

}