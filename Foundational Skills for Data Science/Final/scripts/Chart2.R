#Load needed packages
library(ggplot2)
library(dplyr)
library(lintr)

#Create a function that returns a scatterplot with the x-axis as blocks and y-axis with wins.
chart2_function <- function(df) {
  scatter <- ggplot(df) +
    geom_point(mapping = aes_string(x = "BLK", y = "wins")) +
  labs(
    title = "Association Between Wins and Blocks",
    x = "Blocks",
    y = "Wins"
  ) +
  geom_smooth(method = lm, formula = y ~ splines::bs(x, 3), se = FALSE,
              mapping = aes_string(x = "BLK", y = "wins"))
  scatter
}
