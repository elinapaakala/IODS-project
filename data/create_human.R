# Elina Paakala
# 14.2.2017
# "Human development" and "Gender inequality" datas

#Read the datas into R
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")
               
#Explore the structure and dimensions of the two datasets
str(hd)
dim(hd)
str(gii)
dim(gii)

#Summaries of the variables
summary(hd)
summary(gii)

#Rename the variables
library(plyr)
hd = rename(hd, c("Human.Development.Index..HDI."="HDI", "Life.Expectancy.at.Birth"="LEXP", 
                  "Expected.Years.of.Education"="EYE", "Mean.Years.of.Education"="MYE", 
                  "Gross.National.Income..GNI..per.Capita"="GNI", 
                  "GNI.per.Capita.Rank.Minus.HDI.Rank"="GNI-HDI"))
gii = rename(gii, c("Gender.Inequality.Index..GII."="GII", "Maternal.Mortality.Ratio"="MMR", 
                    "Adolescent.Birth.Rate"="ABR", "Percent.Representation.in.Parliament"="PRP", 
                    "Population.with.Secondary.Education..Female."="PSE_F", 
                    "Population.with.Secondary.Education..Male."="PSE_M",
                    "Labour.Force.Participation.Rate..Female."="LFPR_F", 
                    "Labour.Force.Participation.Rate..Male."="LFPR_M"))

#Mutate the "Gender inequality" data
library(dplyr)
#Define a new column with ratio of female and male populations with secondary education
gii <- mutate(gii, ratio_PSE_F_PSE_M = PSE_F/PSE_M)
#Define a new column with ratio of labour force participation of females and males
gii <- mutate(gii, ratio_LFPR_F_LFPR_M = LFPR_F/LFPR_M)

#Join the two datasets by Country
human <- inner_join(hd, gii, by = "Country")

# Save the dataset to data folder
write.csv(human, file = "human")



#RStudio Exercise 5:

#Read in the data
human <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt", sep=",", header=TRUE)
summary(human)


# Transform the GNI variable to numeric
human <- mutate(human, GNI = as.numeric(GNI))


# Select the column names to keep in the dataset
keep_columns <- c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
# Select the kept columns to create a new dataset
human <- select(human, one_of(keep_columns))

### Remove all rows with missing values
# print out a completeness indicator of the 'human' data
complete.cases(human)
# print out the data along with a completeness indicator as the last column
data.frame(human[-1], comp = complete.cases(human))
# Filter out all rows with NA values
human_ <- filter(human, complete.cases(human))


### Remove the observations not relating to countries
# look at the last 10 observations of human
tail(human_, n=10)
# define the last indice we want to keep
last <- nrow(human_) - 7
# choose everything until the last 7 observations
human_ <- human_[1:last, ]


# add countries as rownames
rownames(human_) <- human_$Country
# remove the country name column
human_ <- select(human_, -Country)

str(human_)
summary(human_)
human_

# Save the dataset to data folder
write.csv(human, file = "human")
