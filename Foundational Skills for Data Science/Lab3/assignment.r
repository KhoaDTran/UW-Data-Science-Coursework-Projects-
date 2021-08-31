# a3-using-data

# Before you get started, set your working directory using the Session menu

###################### Data Frame Manipulation (24 POINTS) #####################

# Create a vector `students` holding 1,000 values representing students
# They should have the values "Student 1", "Student 2",..., "Student 1000"
students <- c(paste("Student ", 1:1000))

# Create a vector `math_grades` that holds 1000 random values in it
# (these represent grades in a math course)
# These values should be normally distributed with a mean of 88 and a
# standard deviation of 10
math_grades <- rnorm(100, 88, 10)


# Replace any values in the `math_grades vector` that are above 100 with
# the number 100
math_grades[math_grades > 100] <- 100

# Create a vector `spanish_grades` that holds 1000 random values in it
# (these represent grades in a spanish course)
# These values should be normally distributed with a mean of 85 and a
# standard deviation of 12
spanish_grades <- rnorm(1000, 85, 12)


# Replace any values in the `spanish_grades` that are above 100 with
# the number 100
spanish_grades[spanish_grades > 100] <- 100


# Create a data.frame variable `grades` by combining
# the vectors `students`, `math_grades`, and `spanish_grades`
# Make sure to properly handle strings
grades <- data.frame(students, math_grades, spanish_grades, stringsAsFactors = FALSE)


# Create a variable `num_students` that contains the
# number of rows in your dataframe `grades`
num_students <- nrow(grades)


# Create a variable `num_courses` that contains the number of columns
# in your dataframe `grades` minus one (b/c of their names)
num_courses <- ncol(grades) - 1


# Add a new column `grade_diff` to your dataframe, which is equal to
# `students$math_grades` minus `students$spanish_grades`
grades$grade_diff <- students$math_grades - students$spanish_grades


# Add another column `better_at_math` as a boolean (TRUE/FALSE) variable that
# indicates that a student got a better grade in math
grades$better_at_math <- grade_diff > 0


# Create a variable `num_better_at_math` that is the number
# (i.e., one numeric value) of students better at math
num_better_at_math <- sum(grades$better_at_math)


# Write your `grades` dataframe to a new .csv file inside your data/ directory
# with the filename `grades.csv`. Make sure *not* to write row names.
# (you'll need to create the `data/` directory, which you can do outside of R)
write.csv(grades, "data/grades.csv", row.names = FALSE)


########################### Built in R Data (28 points) ########################

# In this section, you'll work with the `Titanic` data set
# Which is built into the R environment.
# This data set actually loads in a format called a *table*
# See https://cran.r-project.org/web/packages/data.table/data.table.pdf
# Use the `is.data.frame()` function to test if it is a table.
library(titanic)
is.data.frame(Titanic)

# Create a variable `titanic_df` by converting `Titanic` into a data frame;
# you can use the `data.frame()` function or `as.data.frame()`
# Be sure to **not** treat strings as factors!
titanic_df <- as.data.frame(Titanic, stringsAsFactors = FALSE)


# It's important to understand the _meaning_ of each column before analyzing it
# Using comments below, describe what information is stored in each column
# For categorical variables, list all possible values
# Class: Categorical data: the rank/class of the passenger
#        Possible values: 1st, 2nd, 3rd, Crew
# Sex: Categorical data: the gender of passenger
#      Possible values: Male, Female
# Age: Ordinal data: The passenger's stage in life
#      Possible values: Child, Adult
# Survived: Categorical data: whether the passenger survived the Titanic crash
#           Possible values: Yes, No
# Freq: Ratio data: The number of people similar type with class, sex, age, that survived
#       Possible values: 0, 35, 17, 118


# Create a variable `children` that are the *only* the rows of the data frame
# with information about the number children on the Titanic.
children <- titanic_df[titanic_df$Age == 'Child', ]


# Create a variable `num_children` that is the total number of children.
# Hint: remember the `sum()` function!
num_children <- sum(children$Freq)


# Create a variable `most_lost` which has the *row* with the
# largest absolute number of losses (people who did not survive).
# Tip: if you want, you can use multiple statements (lines of code)
# if you find that helpful to create this variable.
not_survive <- titanic_df[titanic_df$Survived == 'No', ]
most_lost <- not_survive[not_survive$Freq == max(not_survive$Freq), ]


# Define a function called `survival_rate()` that takes in two arguments:
# - a ticket class (e.g., "1st", "2nd"), and
# - the dataframe itself (it's good practice to explicitly pass in data frames)
# This function should return the following
# sentence that states the *survival rate* (# survived / # in group)
# of adult men and "women and children" in that ticketing class.
# It should read (for example):
# Of Crew class, 87% of women and children survived and 22% of men survived.
# The approach you take to generating the sentence to return is up to you.
# A good solution will likely utilize filtering to produce the required data.
# You must round values and present them as percentages in the sentence.
survival_rate <- function(passenger_class, dataframe) {
  filter_class <- dataframe[dataframe$Class == passenger_class, ]
  adult_class <- filter_class[filter_class$Age == 'Adult', ]
  women_adult <- adult_class[adult_class$Sex == 'Female', ]
  women_alive <- women_adult[women_adult$Survived == 'Yes', ]
  child_class <- filter_class[filter_class$Age == 'Child', ]
  child_alive <- child_class[child_class$Survived == 'Yes', ]
  total_women_children <- sum(women_adult$Freq, child_class$Freq)
  women_children_survived <- sum(women_alive$Freq, child_alive$Freq)
  men_adult <- adult_class[adult_class$Sex == 'Male', ]
  men_alive <- men_adult[men_adult$Survived == 'Yes', ]
  total_men <- sum(men_adult$Freq)
  men_alive_total <- sum(men_alive$Freq)
  women_child_rate <- round(100 * women_children_survived / total_women_children, 0)
  men_rate <- round(100 * men_alive_total / total_men, 0)
  paste("Of ", passenger_class, " class, ", women_child_rate, "% of women and children survived and ", men_rate, 
        "% of men survived.", sep = "")
}

# Create variables `first_survived`, `second_survived`, `third_survived` and
# `crew_survived` by passing each class and the `titanic_df` data frame
# to your `survival_rate` function
# (`Crew`, `1st`, `2nd`, and `3rd`), passing int
first_survived <- survival_rate("1st", titanic_df)
second_survived <- survival_rate("2nd", titanic_df)
third_survived <- survival_rate("3rd", titanic_df)
crew_survived <- survival_rate("Crew", titanic_df)


# What notable differences do you observe in the survival rates across classes?
# Note at least 2 observations.
# YOUR ANSWER HERE
# 1) The third class had were the least likely to have women and children surviving
# 2) The second class were the least likely of all classes to have men surviving

# What notable differences do you observe in the survival rates between the
# women and children versus the men in each group?
# Note at least 2 observations.
# YOUR ANSWER HERE
# 1) In all of the classes, women and children were more likely to survive than men
# 2) The second classes had the biggest difference between men and women and children surivival


########################### Reading in Data (43 points)#########################
# In this section, you'll work with .csv data of life expectancy by country
# First, you should download a .csv file of Life Expectancy data from GapMinder:
# https://www.gapminder.org/data/
# You should save the .csv file into your `data` directory

# Before getting started, you should explore the GapMinder website to understand
# the *original* source of the data (e.g., who calculated these estimates)
# Place a brief summary of the each data source here (e.g., 1 - 2 sentences
# per data source)
# WRITE SUMMARY HERE
# LIKELY MULTIPLE LINES
# 1) From 1800 - 1970, Mattias Lindgren made estimates using big disasters
#    to assess the impact on life expectancy
# 2) From 1970 - 2016, the IHME made estimates from their Global Burden of
#    Disease study
# 3) From 2017 - 2019, the UN made estimates using demographic indicators

# Using the `read.csv` function, read the life_expectancy_years.csv file into
# a variable called `life_exp`. Makes sure not to read strings as factors
life_exp <- read.csv("data/life_expectancy_years.csv", stringsAsFactors = FALSE)

# Write a function `get_col_mean()` that takes in a column name and a data frame
# and returns the mean of that column. Make sure to properly handle NA values
get_col_mean <- function(column_name, dataframe)
  mean(dataframe[, column_name], na.rm = TRUE)


# Create a list `col_means` that has the mean value of each column in the
# data frame (except the `Country` column). You should use your function above.
column <- colnames(life_exp)
col_length <- length(column)
column <- column[2 : col_length]
col_means <- lapply(column, get_col_mean, life_exp)

# Create a variable `avg_diff` that holds the difference in average country life
# expectancy between 1800 and 2018?
avg_diff <- col_means[[219]] - col_means[[1]]


# Create a column `life_exp$change` that is the change
# in life expectancy from 2000 to 2018. Increases in life expectancy should
# be *positive*
life_exp$change <- life_exp$X2018 - life_exp$X2000


# Create a variable `most_improved` that is the *name* of the country
# with the largest gain in life expectancy
# Make sure to filter NA values!
value_max <- range(life_exp$change, na.rm = TRUE)[2]
most_improved_null <- life_exp$country[life_exp$change == value_max]
not_null <- !is.na(most_improved_null)
most_improved <- most_improved_null[not_null]


# Create a variable `num_small_gain` that has the *number* of countries
# whose life expectance has improved less than 1 year between 2000 and 2018
# Make sure to filter NA values!
small_countries_null <- life_exp$country[life_exp$change < 1]
not_null <- !is.na(small_countries_null)
small_gain <- small_countries_null[not_null]
num_small_gain <- length(small_gain)


# Write a function `country_change()` that takes in a country's name,
# two (numeric) years, and the `life_exp` dataframe as parameters.
# It should return the phrase:
# "Between YEAR1 and YEAR2, the life expectancy in COUNTRY went DIRECTION by
# SOME_YEARS years".
# Make sure to properly indictate the DIRECTION as "up" or "down"
country_change <- function(country_name, YEAR1, YEAR2, life_exp){
  coly1 <- paste("X", YEAR1, sep = "")
  coly2 <- paste("X", YEAR2, sep = "")
  index_row <- which(life_exp$country == country_name)
  difference <- life_exp[index_row, coly1] - life_exp[index_row, coly2]
  direction <- "up"
  if (difference < 0){
    direction <- "down"
    difference <- abs(difference)
  }
  paste("Between ", YEAR1, " and ", YEAR2, ", the life expecatancy in ",
        country_name, " went ", direction, " by ", difference, " years", sep = "")
}


# Using your `country_change()` function, create a variable `sweden_change`
# that is the change in life expectancy from 1960 to 1990 in Sweden
sweden_change <- country_change("Sweden", 1960, 1990, life_exp)


# Write a function `compare_change()` that takes in two country names and your
# `life_exp` data frame as parameters, and returns a sentence that describes
# their change in life expectancy from 2000 to 2018 (the `change` column)
# For example, if you passed the values "China", and "Bolivia" to you function,
# It would return this:
# "The country with the bigger change in life expectancy was China (gain=6.9),
#  whose life expectancy grew by 0.6 years more than Bolivia's (gain=6.3)."
# Make sure to round your numbers to one digit (though only after calculations!)
compare_change <- function(country1, country2, life_exp){
  row1_index <- which(life_exp$country == country1)
  row2_index <- which(life_exp$country == country2)
  diff1 <- life_exp$change[row1_index]
  diff2 <- life_exp$change[row2_index]
  bigger_diff <- country1
  diff <- diff1 - diff2
  if (diff < 0){
    bigger_diff <- country2
    diff <- abs(diff)
  }
  diff2 <- round(diff2, 1)
  diff1 <- round(diff1, 1)
  diff <- round(diff, 1)
  if (bigger_diff == country2){
    paste("The country with the bigger change in life expectancy was ",
          country2, " (gain=", diff2, "), whose life expectancy grew by ",
          diff, " years more than ", country1, "'s (gain=", diff1, ").",
          sep = "")
  } else {
    paste("The country with the bigger change in life expectancy was ",
          country1, " (gain=", diff1, "), whose life expectancy grew by ",
          diff, " years more than ", country2, "'s (gain=", diff2, ").",
          sep = "")
  }
}


# Using your `bigger_change()` function, create a variable `usa_or_france`
# that describes who had a larger gain in life expectancy (the U.S. or France)
usa_or_france <- compare_change("United States", "France", life_exp)


# Write your `life_exp` data.frame to a new .csv file to your
# data/ directory with the filename `life_exp_with_change.csv`.
# Make sure not to write row names.
write.csv(life_exp, file = "data/life_exp_with_change.csv", row.names = FALSE)

