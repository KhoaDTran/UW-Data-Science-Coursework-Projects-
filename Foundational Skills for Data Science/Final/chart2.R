team_stats2016_17 <- read.csv("data/2016-17combined.csv", stringsAsFactors = FALSE)
team_stats2018_19 <- read.csv("data/2018-19combined.csv", stringsAsFactors = FALSE)

#All code for mainPanel
main_contentD <- mainPanel(
  plotlyOutput("scatter"),
  HTML('<p id = "explain">This scatterplot is made to help show any correlation between regular season
       wins and various defensive stats recorded by the NBA. In conjuncture with the offense stats table,
       we aim to try to understand the importance of having each side of the ball and their direct impact
       on the success of an NBA team.</p>')
)
#All code for sidebarPanel
sidebar_contentD <- sidebarPanel(
  radioButtons("button", label = h1("Defensive Stats (y-axis)"),
               c("Defensive Rebounds" = "DRB",
                 "Blocks" = "BLK",
                 "Turnovers" = "TOV"
               )),
  selectInput(
    'datasets', "Select Season:", choices = c('team_stats2016_17' = 'df11',
                                             'team_stats2018_19' = 'df22')
  )
)

# All code for sidebarLayout, implementing above code
defense_win_ui <- sidebarLayout(
 sidebar_contentD,
 main_contentD #,
 #fluid = TRUE
)
