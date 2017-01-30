# Elina Paakala 
# 30.1.2017
# Data for RStudio Exercise 2

#2.

#Read the full learning2014 data
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

#Explore the structure of the data
str(lrn14)
#There are 183 observations and 60 variables. All but of the variables are integers. Gender is a factor with 2 levels.

#Explore the dimensions of the data
dim(lrn14)
#There are 183 rows (observatoins) and 60 columns (variables) in the data.

#3.

# divide each number in the column vector
lrn14$Attitude / 10

# create column 'attitude' by scaling the column "Attitude"
lrn14$attitude <- lrn14$Attitude / 10

# Access the dplyr library
library(dplyr)

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

# choose certain variables
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")

# select the 'keep_columns' to create a new dataset
learning2014 <- select(lrn14, one_of(keep_columns))

# change the name of the second column
colnames(learning2014)[2] <- "age"

# change the name of "Points" to "points"
colnames(learning2014)[7] <- "points"

# Exclude observations where the exam points variable is zero = select rows where points is greater than zero
learning2014 <- filter(learning2014, points > 0)

"Check the number of rows and columns"
dim(learning2014)

#4.
#I set the data folder in IODS-project folder as working directory by using the Files tab on the right

#Save the analysis dataset to data folder
write.csv(learning2014, file = "learning2014")
#Read the file back to RStudio
read.csv("learning2014")
str(learning2014)
head(learning2014)
