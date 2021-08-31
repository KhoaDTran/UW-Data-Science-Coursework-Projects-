# A4 Data Wrangling

# Loading and Exploring Data -------------------------------- (**28 points**)

# To begin, you'll need to download the Kickstarter Projects data from the
  # Kaggle website: https://www.kaggle.com/kemical/kickstarter-projects
# Download the `ks-projects-201801.csv` file into a new folder called `data/`

# Load the `dplyr` package
library(dplyr)

# Load your data, making sure to not interpret strings as factors
ks_project <- read.csv(file = "data/ks-projects-201801.csv",
                       stringsAsFactors = FALSE)

# To start, write the code to get some basic information about the dataframe:
# - What are the column names?
# - How many rows is the data frame?
# - How many columns are in the data frame?
name_col <- colnames(ks_project)
num_row <- nrow(ks_project)
num_col <- ncol(ks_project)

# Use the `summary` function to get some summary information
sum_info <- summarize(
  ks_project,
  num_row = nrow(ks_project),
  num_col = ncol(ks_project)
)


# Unfortunately, this doesn't give us a great set of insights. Let's write a
# few functions to try and do this better.
# First, let's write a function `get_col_info()` that takes as parameters a
# column name and a dataframe. If the values in the column are *numeric*,
# the function should return a list with the keys:
# - `min`: the minimum value of the column
# - `max`: the maximum value of the column
# - `mean`: the mean value of the column
# If the column is *not* numeric and there are fewer than 10 unique values in
# the column, you should return a list with the keys:
# - `n_values`: the number of unique values in the column
# - `unique_values`: a vector of each unique value in the column
# If the column is *not* numeric and there are 10 or *more* unique values in
# the column, you should return a list with the keys:
# - `n_values`: the number of unique values in the column
# - `sample_values`: a vector containing a random sample of 10 column values
# Hint: use `typeof()` to determine the column type
get_col_info <- function(name_col, dataframe) {
  col_info <- dataframe %>%
    pull(name_col)
  if (typeof(col_info) == "double") {
    list(
      min = min(col_info, na.rm = TRUE),
      max = max(col_info, na.rm = TRUE),
      mean = mean(col_info, na.rm = TRUE)
    )
  } else {
    val_unique <- unique(col_info)
    num_unique <- length(val_unique)
    if (num_unique < 10) {
      list(
        n_values = num_unique,
        unique_values = val_unique
      )
    } else {
      list(
        n_values = num_unique,
        sample_values = sample(val_unique, 10)
      )
    }
  }
}
  
  

# Demonstrate that your function works by passing a column name of your choice
# and the kickstarter data to your function. Store the result in a variable
# with a meaningful name
goal_info_ks <- get_col_info(name_col = "goal", dataframe = ks_project)


# To take this one step further, write a function `get_summary_info()`,
# that takes in a data frame  and returns a *list* of information for each
# column (where the *keys* of the returned list are the column names, and the
# _values_ are the summary information returned by the `get_col_info()` function
# The suggested approach is to use the appropriate `*apply` method to
# do this, though you can write a loop
get_summary_info <- function(dataframe) {
  names_col <- colnames(dataframe)
  lapply(names_col, get_col_info, dataframe)
}

# Demonstrate that your function works by passing the kickstarter data
# into it and saving the result in a variable
ks_result <- get_summary_info(ks_project)


# Take note of 3 observations that you find interesting from this summary
# information (and/or questions that arise that want to investigate further)
# YOUR COMMENTS HERE
# LIKELY ON MULTIPLE LINES
# 1) The state column is the only column that isn't numeric,
#    but less than 10 unique values.
# 2) There are only 5 numeric columns and it's mostly at the end
# 3) What is the ratio of sucessful and unsucessful goal
#    accomplishments grouped by categories?

# Asking questions of the data ----------------------------- (**29 points**)

# Write the appropriate dplyr code to answer each one of the following questions
# Make sure to return (only) the desired value of interest (e.g., use `pull()`)
# Store the result of each question in a variable with a clear + expressive name
# If there are multiple observations that meet each condition, the results
# can be in a vector. Make sure to *handle NA values* throughout!
# You should answer each question using a single statement with multiple pipe
# operations!

# What was the name of the project(s) with the highest goal?
highest_goal <- ks_project %>%
  filter(goal == max(goal, na.rm = TRUE)) %>%
  pull(name)

# What was the category of the project(s) with the lowest goal?
lowest_goal <- ks_project %>%
  filter(goal == min(goal, na.rm = TRUE)) %>%
  pull(name)

# How many projects had a deadline in 2018?
deadline_in_2018 <- ks_project %>%
  filter(substr(deadline, 1, 4) == "2018") %>%
  pull(name) %>%
  length()
  

# What proportion or projects weren't successful? Your result can be a decimal
state_ratio <- ks_project %>%
  count(state, name = "count")
failed_proprotion <- state_ratio[2, 2] / (state_ratio[2, 2] + state_ratio[4, 2])


# What was the amount pledged for the project with the most backers?
most_backers_amount_pledged <- ks_project %>%
  filter(backers == max(backers, na.rm = TRUE)) %>%
  pull(pledged)


# Of all of the projects that *failed*, what was the name of the project with
# the highest amount of money pledged?
highest_failed_pledged <- ks_project %>%
  filter(state == "failed") %>%
  filter(pledged == max(pledged, na.rm = TRUE)) %>%
  pull(pledged)


# How much total money was pledged to projects that weren't successful?
total_failed_pledged <- ks_project %>%
  filter(state == "failed") %>%
  pull(pledged) %>%
  sum(na.rm = TRUE)

# Performing analysis by *grouped* observations ----------------- (38 Points)

# Which category had the most money pledged (total)?
most_pledged_category <- ks_project %>%
  group_by(category) %>%
  summarize(
    category_total = sum(pledged, na.rm = TRUE)
  ) %>%
  filter(category_total == max(category_total, na.rm = TRUE)) %>%
  pull(category)
  
# Which country had the most backers?
most_backers_country <- ks_project %>%
  group_by(country) %>%
  summarize(
    total_backers = sum(backers, na.rm = TRUE)
  ) %>%
  filter(total_backers == max(total_backers, na.rm = TRUE)) %>%
  pull(country)

# Which year had the most money pledged (hint: you may have to create a new
# column)?
most_pledged_year <- ks_project %>%
  mutate(year_launched = substr(launched, 1, 4)) %>%
  group_by(year_launched)
  summarize(
    total_year = sum(pledged, na.rm = TRUE)
  ) %>%
  filter(total_year == max(total_year, na.rm = TRUE)) %>%
  pull(year_launched)


# What were the top 3 main categories in 2018 (as ranked by number of backers)?
top_three_2018 <- ks_project %>%
  filter(substr(launched, 1, 4) == "2018") %>%
  group_by(category) %>%
  summarize(
    total_backers_2018 = sum(backers, na.rm = TRUE)
  ) %>%
  arrange(desc(total_backers_2018)) %>%
  slice(1:3) %>%
  pull(category)
  

# What was the most common day of the week on which to launch a project?
# (return the name of the day, e.g. "Sunday", "Monday"....)
most_common_launch_day <- ks_project %>%
  mutate(weekday = weekdays(as.Date(substr(launched, 1, 10)))) %>%
  count(weekday, name = "count") %>%
  filter(count == max(count)) %>%
  pull(weekday)


# What was the least successful day on which to launch a project? In other
# words, which day had the lowest success rate (lowest proportion of projects
# that were successful)? This might require some creative problem solving....
num_projects_per_day <- ks_project %>%
  mutate(weekday = weekdays(as.Date(substr(launched, 1, 10)))) %>%
  count(weekday, name = "count")

proj_success_per_day <- ks_project %>%
  filter(state == "successful") %>%
  mutate(weekday = weekdays(as.Date(substr(launched, 1, 10)))) %>%
  count(weekday, name = "count")

success_total_join <- right_join(proj_success_per_day, num_projects_per_day,
                                   by = "weekday")

lowest_success_day <- success_total_join %>%
  mutate(rate_success = count.x / count.y) %>%
  filter(rate_success == min(rate_success, na.rm = TRUE)) %>%
  pull(weekday)
