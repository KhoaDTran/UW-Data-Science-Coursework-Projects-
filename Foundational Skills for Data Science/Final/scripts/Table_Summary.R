## Creates an aggregate table comparing win range to defensive stats
get_table <- function(dataset) {
  dataset %>%
  select(DRB, STL, BLK) %>%
    mutate(win_range = cut(as.numeric(dataset$"wins"),
      breaks = seq(10, 70, by = 10),
      right = TRUE, dig.lab = 10, labels = c(
        "11-20", "21-30", "31-40", "41-50", "51-60", "61-70"))) %>%
  group_by(win_range) %>%
  summarise(
    avg_drb = format(round(mean(DRB), 1)),
    avg_stl = format(round(mean(STL), 1)),
    avg_blk = format(round(mean(BLK), 1))
  )
}
