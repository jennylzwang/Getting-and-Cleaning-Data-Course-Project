## Code book for course "Getting and Cleaning Data" assignment:
## Create one R script called run_analysis.R that does the following:
## using datasets from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## 1.Merges the training and the test sets to create one data set.
## 2.Extracts only the measurements on the mean and standard deviation for each measurement.
## 3.Uses descriptive activity names to name the activities in the data set
## 4.Appropriately labels the data set with descriptive variable names.
## 5.From the data set in step 4, creates a second, independent tidy data set with the average of 
##   each variable for each activity and each subject.


## load packages
library(dplyr)
library(data.table)
library(tidyr)

## Before started, the first is to download the datasets and unzip.
setwd("~/Desktop/Coursera")
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl,destfile="Dataset.zip",method="curl")
unzip(zipfile="Dataset.zip")

## View the files in the Dataset folder
list.files("./UCI HAR Dataset")
list.files("./UCI HAR Dataset/test")
list.files("./UCI HAR Dataset/train")

## Extract the data in the file and store them into corresponding variable
## If you are using R.studio, you can see the table str. in the right side upper window.
## 1a. READ.TABLE the subject files and check col. names
SubjectTest<- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                                                        header=FALSE)
SubjectTrain<- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                                                        header=FALSE)
names(SubjectTest)
names(SubjectTrain)

## 1b. READ.TABLE the dataset files and check col. names
DataTest<- read.table ("./UCI HAR Dataset/test/X_test.txt", 
                                                header=FALSE)
any(duplicated(DataTest, MARGIN = 1)) ##FALSE, no duplicated rows
DataTrain<- read.table("./UCI HAR Dataset/train/X_train.txt", 
                                                header=FALSE)
any(duplicated(DataTest, MARGIN = 1)) ##FALSE, no duplicated rows
names(DataTest)
names(DataTrain)

##1c. READ.TABLE the activity files and check the col. names.
ActTrain<- read.table ("./UCI HAR Dataset/train/y_train.txt", 
                                                 header=FALSE)
ActTest<- read.table ("./UCI HAR Dataset/test/y_test.txt", 
                                                 header=FALSE)
names(ActTest)
names(ActTrain)

## 1d. READ.TABLE the feature vector list and activity labels.
Feature<-read.table("./UCI HAR Dataset/features.txt", 
                                           header=FALSE)
ActLabel<-read.table("./UCI HAR Dataset/activity_labels.txt", 
                                           header=FALSE)
names(Feature)
names(ActLabel)

## Now it is ready to merge all the data into one big dataset. As we can see
## that all of them have commom variable=V1, and it is time to change to a specific
## name before column bind.
## 1e. First of all, row bind Data, Act and Subject into one dataset.
Data<- rbind(DataTest, DataTrain)
any(is.na(Data)) ## Returns "FALSE", no invalid data present.
Act<- rbind(ActTest, ActTrain)
Subject<- rbind(SubjectTest, SubjectTrain)

## 1f. Change the col.names V1 into descriptive names in Subject and Act.
names(Act)<-sub("V1", "activity", names(Act))
names(Subject)<-sub("V1", "subject", names(Subject))

## 1g. Column bind three datasets into one big dataset. Check names to verify.
Mixdf<- cbind(Subject, Act, Data)
Mixdf<- arrange(Mixdf, subject, activity)

## 1h. This step to form a dataset is to substitute the data variables with Feature 
## To make a Tidy Data, first it to make sure there is NO duplicated variables, in here, Feature.
any(duplicated(Feature$V2)) ##this code returns "TRUE", duplication exist.
names(Mixdf)[3:563]<-make.unique(as.character(Feature$V2))
any(duplicated(names(Mixdf))) ## This returns "FALSE"

## 1i. This is the final step (also required in question3) to replace the activity with corresponding value
## using match function.
Mixdf$activity<-ActLabel[match(Mixdf$activity,ActLabel$V1),2]
head(Mixdf$activity,2) ## this step returns [1]STANDING STANDING. Now the dataset is formed.

##2.Extracts only the measurements on the mean and standard deviation for each measurement.
stdnames<-c("subject", "activity", grep("mean|std", names(Mixdf), value=TRUE))
MeanStd<-Mixdf[, stdnames]
head(MeanStd[1:3]) ## returns dataframe only contains the measurements with mean or std.

##3. Uses descriptive activity names to name the activities in the data set
## This is one is done in Step 1i

##4. Uses descriptive names for each variable, such as replace "t" for "time,
## "f" for "frequency", "acc" for "accelerator" and ect.
names(Mixdf)<-tolower(names(Mixdf))
names(Mixdf)<-gsub("^t", "time", names(Mixdf))
names(Mixdf)<-gsub("^f", "frequency", names(Mixdf))
names(Mixdf)<-gsub("acc", "accelerometer", names(Mixdf), fixed=TRUE)
names(Mixdf)<-gsub("gyro", "gyroscope", names(Mixdf), fixed=TRUE)
names(Mixdf)<-gsub("mag", "magnitude", names(Mixdf), fixed=TRUE)
names(Mixdf)<-gsub("bodybody", "body", names(Mixdf), fixed=TRUE)

##5a From the data set in step 4, creates a second,independent tidy data set with the average of 
##   each variable for each activity and each subject.
Data2<-aggregate(. ~subject + activity, Mixdf, mean)
anyNA(Data2) ## returns [1] FALSE
any(duplicated(Data2, margin=2))  ## returns [1] FALSE
dim(Data2) ## returns [1] 180 563
class(Data2) ## returns [1] "data.frame"

## Save both data tables to desinated dir.
write.csv(Mixdf, file="./UCI HAR Dataset/TotalData.csv") ## The total Data set
write.csv(Data2, file="./UCI HAR Dataset/MeanData.csv") ## Dataset with average values

##Final: to generate a codebook for this R script using R Markdown (Knit Document)
##Alternatively, one can generate codebook for each dataset (Mixdf and Data2) using 
##codebook function using memisc package:
##  Write(codebook(Mixdf), file="./UCI HAR Dataset/fulldata.rmd")
##  Write(codebook(Data2), file="./UCI HAR Dataset/averagedata.rmd")

