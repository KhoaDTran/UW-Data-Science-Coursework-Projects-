# Load in packages
library(dplyr)
library(ggplot2)

# make the plot; it will be a bar chart, with the x-axis being team rank, and
# y-axis being FG% with a scale from 35% to 50%
chart_1_function <- function(df) {
  rank_vs_fgperc <- df %>%
    ggplot(aes_string(x = "Rk", y = "FG.")) +
    geom_bar(stat = "identity") +
    labs(
      title = "Team Rank vs Field Goal Percentage",
      x = "Team Rank",
      y = "Field Goal %") +
    coord_cartesian(ylim = c(0.35, 0.5)) +
    scale_x_discrete(limits = c(1:16))
  return(rank_vs_fgperc)
}
