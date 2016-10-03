# Getting-and-Cleaning-Data-Course-Project
This is the course project for “Getting and Cleaning Data” is to create one R script to obtain tidy Dataset. This repo contains 3 files for this project: README.md, CodeBook.md and the run_analysis.R to fulfill the requirement of this project. Below is the project description:

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
Here are the data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
You should create one R script called run_analysis.R that does the following.
	1	Merges the training and the test sets to create one data set.
	2	Extracts only the measurements on the mean and standard deviation for each measurement.
	3	Uses descriptive activity names to name the activities in the data set
	4	Appropriately labels the data set with descriptive variable names.
	5	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Detailed analysis and data feature is described in the R script and codebook. One particular note is that the feature dataset (feature.txt) contains duplicated elements that required to be clean up or modify. Therefore, checking the NA value and searching for duplicated elements is particularly important to obtain a tidy dataset. In my script, I didn’t follow exactly the order described above. Instead, I tidy the whole dataset first before I moved on to the 2nd one, which requires extraction for measurement of interest. The requirement for step3 is performed during step 1. Enjoy your reading and thanks for your time!
