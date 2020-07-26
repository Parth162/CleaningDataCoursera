---
title: "CodeBook"
author: "Parth Goel"
date: "7/26/2020"
output: html_document
---

# Getting and Cleaning Data Course Project

**Instructions:**
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

Here are the data for the project:

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Data Description

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. 
These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and
a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated 
into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). 
Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, 
tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, 
fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

## Dataset Information

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

### Files in folder ‘UCI HAR Dataset’ that will be used are:

1. SUBJECT FILES
    + test/subject_test.txt
    + train/subject_train.txt
2. ACTIVITY FILES
    + test/X_test.txt
    + train/X_train.txt
3. DATA FILES
    + test/y_test.txt
    + train/y_train.txt
4. features.txt - Names of column variables in the dataTable
5. activity_labels.txt - Links the class labels with their activity name.

### Packages Required:

* dplyr
* plyr

## 1. Reads and merges datato create on data set

```{r}
# First, reading all the required text files to form and merge training and test dataset

featureLabels <- read.table('./UCI HAR Dataset/features.txt', sep = " ")

subjectTrain<- read.table('./UCI HAR Dataset/train/subject_train.txt',
                          col.names = "subjectId")
activityTrain <- read.table('./UCI HAR Dataset/train/y_train.txt',
                           col.names = "activity")
trainData <- read.table('./UCI HAR Dataset/train/X_train.txt',
                       col.names = featureLabels[,2])

combinedTrain <- cbind.data.frame(subjectTrain,activityTrain,trainData)

subjectTest <- read.table('./UCI HAR Dataset/test/subject_test.txt',
                          col.names = "subjectId")
activityTest <- read.table('./UCI HAR Dataset/test/y_test.txt',
                           col.names = "activity")
testData <- read.table('./UCI HAR Dataset/test/X_test.txt',
                       col.names = featureLabels[,2])

combinedTest <- cbind.data.frame(subjectTest,activityTest,testData)

# Merge train and test data formed
combinedDataset <- rbind.data.frame(combinedTest,combinedTrain)
```

## 2. Extract mean and standard deviation columns

```{r}
# Extracting columns with only mean and standard deviation value
combinedDataset <- select(combinedDataset,c('subjectId','activity',contains(".mean."),contains(".std.")))

# Cleaning up the column names formed
colnames(combinedDataset) <- gsub("\\.\\.+",".",colnames(combinedDataset))
colnames(combinedDataset) <- gsub("\\.$","",colnames(combinedDataset))
```
## 3. Use descriptive activity names

```{r}
# Naming the activities by providing them labels
activityLabels <- read.table('./UCI HAR Dataset/activity_labels.txt', sep = " ")
combinedDataset[["activity"]] <- factor(combinedDataset[["activity"]],
                                        levels = activityLabels[,1],
                                        labels = activityLabels[,2])
```

## 4. Appropriate labels given to columns

```{r}
# Creating descriptive names for columns 
names(combinedDataset) <- gsub("^t", "time", names(combinedDataset))
names(combinedDataset) <- gsub("^f", "frequency", names(combinedDataset))
names(combinedDataset) <- gsub("Acc", "Accelerometer", names(combinedDataset))
names(combinedDataset) <- gsub("Gyro", "Gyroscope", names(combinedDataset))
names(combinedDataset) <- gsub("Mag", "Magnitude", names(combinedDataset))
names(combinedDataset) <- gsub("BodyBody", "Body", names(combinedDataset))
```

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```{r}
# Using ddply to calculate mean for all columns for each activity in each subject
groupCol = colnames(combinedDataset)[1:2]
finalDataset <- ddply(combinedDataset,groupCol,numcolwise(mean))

# Finally, output the data in text format
write.table(finalDataset,file = 'Tidydataset.txt',row.names = FALSE)
```
