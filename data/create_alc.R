# Elina Paakala
# 8.2.2017
# Student alcohol consumption data from https://archive.ics.uci.edu/ml/machine-learning-databases/00356/

#Read the student-mat.csv and student-por.csv into R
studentmat <- read.table("H:/Jatko-opinnot/Open data science/IODS-project/data/student-mat.csv", sep=";", header=TRUE)
studentpor <- read.table("H:/Jatko-opinnot/Open data science/IODS-project/data/student-por.csv", sep=";", header=TRUE)

#Explore the structure and dimensions of the two datasets
str(studentmat)
dim(studentmat)
str(studentpor)
dim(studentpor)


#Join the two datasets  

# access the dplyr library
library(dplyr)

# common columns to use as identifiers
join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")

# join the two datasets by the selected identifiers
matpor <- inner_join(studentmat, studentpor, by = join_by)

# explore the structure and dimensions of the joined data
str(matpor)
dim(matpor)


#Combine the duplicated answers in the joined data

# create a new data frame with only the joined columns
alc <- select(matpor, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(studentmat)[!colnames(studentmat) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'matpor' with the same original name
  two_columns <- select(matpor, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}


# Average of weekday and weekend alcohol use to a column alc_use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# Create a new logical column 'high_use', TRUE if alc_use is greater than 2 and FALSE otherwise
alc <- mutate(alc, high_use = alc_use > 2)

# Glimpse the new data
glimpse(alc)

# Save the dataset to data folder
write.csv(alc, file = "alc")
