# File: run_analysis
# name: Edgar M. Martinez Santana
# Final Proyect
# Gettint and Cleanning Data
# Johns Hopkins University
#
#You should create one R script called run_analysis.R that does the following. 
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for 
#each measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
#5. From the data set in step 4, creates a second, independent tidy data 
#set with the average of each variable for each activity and each subject.

###### Get data #####
library(data.table)
library(dplyr)

urlFile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
pathFile <- getwd()
download.file(urlFile, file.path(pathFile, "misDatos.zip"))
unzip("misDatos.zip")


###### Reading files activity and features #########

activityLab <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
names(activityLab) <- c("ActivityID","ActivityName")

features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
names(features) <- c("featuresID","featuresName")

featuresfilter <- grep("(mean|std)\\(\\)",features[,"featuresName"])
featuresfin <- features[featuresfilter, "featuresName"]
featuresfin <- gsub("[()]","",featuresfin)



###### Reading and merge train data ###########

tsubjet <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
names(tsubjet) <- c("subjetID")

tX <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
cleaname <- gsub("[()]","",features$featuresName)
names(tX) <- c(cleaname)
tX <- tX[,featuresfin]

ty <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
names(ty) <- c("activity")

dataTrain <- cbind(tsubjet,ty,tX)

###### Reading and merge test data ###########

tstsubjet <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
names(tstsubjet) <- c("subjetID")

tstX <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
cleaname <- gsub("[()]","",features$featuresName)
names(tstX) <- c(cleaname)
tstX <- tstX[,featuresfin]

tsty <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
names(tsty) <- c("activity")

dataTest <- cbind(tstsubjet,tsty,tstX)


###### merge train and test data ###########

dataFinal <- rbind(dataTrain, dataTest)

###### Convert factor #########

dataFinal$activity <- factor(dataFinal$activity
                             , levels = activityLab$ActivityID
                             , labels = activityLab$ActivityName)

##### Creating Tidy file #####

data1 <- data.table(dataFinal)
tidyDat  %>% group_by(activity, subjetID) %>% summarize_all(mean)


data.table::fwrite(x = tidyDat, file = "tidyData.csv", quote = FALSE)
#rm(list = ls())











