# DO THIS BEFORE EDITING ASSIGNMENT.R
# Make data directory to hold csv files
# Set working directory

# VECTOR REVIEW

loan_id = 1:100 # create 100 loans
credit_score = rnorm(n = 100, mean = 600, sd = 200) # randomly generate 100 credit scores
credit_score[credit_score > 900] <- 900 # since it's random, replace anything above 900 with 900

loan_application <- data.frame(loan_id, credit_score, stringsAsFactors = FALSE); # make into table
loan_application$should_loan <- loan_application$credit_score >= 700 # make new column

nrow(loan_application[loan_application$should_loan == TRUE,]) # see how many loans we are giving out, notice the comma

# DATAFRAME STUFF

# Load some sample data (iris flowers)
# Can also load a csv with read_csv("data/file_name.csv", na.rm = TRUE)

flowers <- data.frame(iris, stringsAsFactors = FALSE);

# What does the data look like?

summary(flowers) # Statistics stuff
head(flowers) # Show the first few
colnames(flowers) # Column names

# ACCESSING ROWS
# nrow() for count
# specify indices or a boolean to select rows
flowers[20:30,]
setosa_irises <- flowers[flowers$Species == "setosa",]
nrow(setosa_irises) # can count all rows or filtered rows

# ACCESSING COLUMNS
# ncolumn() for count
flowers$Petal.Length
flowers[, "Petal.Length"]
flowers[, c("Petal.Length", "Petal.Width")]

# USING THIS STUFF

mean_sepal_length <- mean(flowers$Sepal.Length)
mean_sepal_length_of_versicolor <- mean(flowers$Sepal.Length[flowers$Species == "versicolor"])

# TLDR: Handy syntax cheatsheet from lecture slides!!

# FUNCTIONS & SAPPLY (useful for part3)
trim_petal <- function(petal, amount) {
  petal - amount
}

lapply(flowers$Petal.Length, trim_petal, 0.3)

trim_all <- function(columns, amount) {
  lapply(columns, trim_petal, 0.3)
}

flowers[, c("Petal.Length", "Sepal.Length")] = 
  trim_all(flowers[, c("Petal.Length", "Sepal.Length")], 0.3)

# lapply(a list or vector, function to execute on each element of list, function arguments, function arguments)
# returns a list of the same length as the one you passed in

# HANDLING NA VALUES

# some functions have an optional argument to specify how to handle NA values in a df
# usually want "na.rm = TRUE"

# also handy "is.na" function for filtering
is.na(flowers$Petal.Length)

# WRITE CHANGES

write.csv(
  flowers,
  "data/iris_modified.csv",
  row.names = FALSE
)

