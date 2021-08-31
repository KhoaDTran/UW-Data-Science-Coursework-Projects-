
library(shiny)
library(ggplot2)

source("chart1.R")
source("chart2.R")
## source("chart3.R")

p_one <- tabPanel(
  "Overview",
  titlePanel("Overview"),
  mainPanel(
    h1("Domain of Interest: Predicting the NBA"),
    img(src = "https___cdn.cnn.com_cnnnext_dam_assets_190911102231-lebron-james-tease.jpg", 
      height = 225, width = 400),
    p("This project seeks to answer predictive questions about the
      NBA, and the relation between team stats and team success.
      The results can be useful for recognizing what are the most
      important stats that need to be improved by a team to allow
      for more opportunities to win games. The three main questions are 
      as follows:"),
    h4("1. How do certain offensive stats within teams correlate with 
      wins?"),
    h4("2. What is the importance of defense and taking care of the ball 
      when it comes to winning?"),
    h4("3. How do changes within the teams correlate with changes in their 
      win percentage from season to season?"),
    p("The following pages will use reactive charts using specific
      datasets to answer these questions. The 2016-2017 regular season
      stats, 2018-2019 regular season stats, and 2019 playoff stats
      are used as data. Each set is already aggregated by team."),
    p("These datasets can be found on ",
      a("Basketball Reference", href="https://www.basketball-reference.com/"))
  )
)

p_two <- tabPanel(
  "Offensive Statistics and Winning Games",
  titlePanel("Analysis of Games Won vs. Team Offensive Statistics"),
  offense_win_ui
)

p_three <- tabPanel(
  "Defense",
  titlePanel("Scatterplot"),
  defense_win_ui
)
p_four <- tabPanel(
  "Third Analysis",
  titlePanel("Chart Three"),
##  team_changes_ui
)

p_five <- tabPanel(
  "Summary",
  titlePanel("Summary"),
  mainPanel(
    h1("Main Takeaways"),
    p("From the chart analysis, three notable patterns can be found."),
    p("Copy paste first paragraph here."),
    p("Copy paste second paragraph here."),
    p("Copy paste third paragraph here.")
  )
)

app_ui <- navbarPage(
  "NBA Stats Analysis", 
  p_one,
  p_two,
  p_three,
  p_four,
  p_five
)
