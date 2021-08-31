# Load in packages
library(dplyr)
library(ggplot2)
library(reshape2)

# Create a box plot function that takes in season statistics and playoff data
chart3_function <- function(dfseason, dfplayoff) {
# Seperate the non-playoff teams and the playoff teams
chart_teams_notplayoffs <- anti_join(dfseason, dfplayoff, by = "Team")
chart_teams_inplayoffs <- semi_join(dfseason, dfplayoff, by = "Team")
# Create group variable to seperate the non-playoff and playoff teams 
chart_teams_notplayoffs$group <- "non-playoffs"
chart_teams_inplayoffs$group <- "playoffs"
# Combine teams that are non-playoff with teams in the playoff statistics 
combine <- rbind(chart_teams_inplayoffs, chart_teams_notplayoffs)
ggplot(combine, aes(x = factor(group), y = PTS)) +
  geom_boxplot() +
  labs(title = "Point Differential Between NBA Playoff and Non-Playoff Team",
       x = "NBA Teams", y = "Total Points Scored")
}