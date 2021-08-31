library("dplyr")

#Getting original data source
basketball_source <- "https://www.basketball-reference.com"

## Takes in the "2018-2019combined.csv" dataset and lists five relevant
## pieces of info on it.
get_summary_info <- function(dataset) {
  ret <- list()
  ret$column_name <- colnames(dataset)
  ret$most_wins <- dataset %>%
    filter(wins == max(as.numeric(dataset$"wins"))) %>%
    select(Team, wins)
  ret$most_points <- dataset %>%
    filter(PTS == max(PTS)) %>%
    select(Team, PTS)
  ret$most_orebounds <- dataset %>%
    filter(ORB == max(ORB)) %>%
    select(Team, ORB)
  ret$least_assists <- dataset %>%
    filter(AST == min(AST)) %>%
    select(Team, AST)
  ret$worst_three_pct <- dataset %>%
    filter(X3P. == min(X3P.)) %>%
    select(Team, X3P.)
  return(ret)
}