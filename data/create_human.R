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
