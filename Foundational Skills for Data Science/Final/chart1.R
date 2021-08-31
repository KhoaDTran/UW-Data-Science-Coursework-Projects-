team_stats2016_17 <- read.csv(file = "data/2016-17combined.csv",
                             stringsAsFactors = FALSE)
team_stats2018_19 <- read.csv(file = "data/2018-19combined.csv",
                             stringsAsFactors = FALSE)

#Main panel of the sidebar layout which includes a datatable output
main_content <- mainPanel(
  #Output a reactive data table
  tableOutput("wins_table"),
  h3("Description"),
  HTML('<p id = "p-id">This chart simulates the minimum amount of wins correlating with teams and their offensive stats.
    Allows the user to select a certain season and minimum number of wins to filter out the key 
    offensive statistics to a winning season.</p>'),
  h4("Conclusion"),
  HTML('<p id2 = "p-id2">For both season between 2016-2017 and 2018-2019, to get over 55 wins, a team on average acquires
       higher than a 47% field goal percentage, 35% three point percentage, and 77% free throw percentage. 
       Within these season, all the teams that had more than 55 wins made the finals of the playoffs. 
       There is a huge pattern between high shooting percentage and making the playoffs. Through these strong coorelation, 
       teams fighting for a playoff spot needs to look at their offensive statistics for improvement.</p>'),
)

#Sidebar content with user choice of selecting the season and the minimum number of wins
sidebar_content <- sidebarPanel(
  selectInput('dataset', "Select Season:", choices = c('team_stats2016_17' = 'df1', 'team_stats2018_19' =  'df2')),
  uiOutput("slider"))
  

offense_win_ui <- sidebarLayout(
  sidebar_content,
  main_content
)