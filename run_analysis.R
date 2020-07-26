library(dplyr)
library(plyr)

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

# Extracting columns with only mean and standard deviation value
combinedDataset <- select(combinedDataset,c('subjectId','activity',contains(".mean."),contains(".std.")))

# Cleaning up the column names formed
colnames(combinedDataset) <- gsub("\\.\\.+",".",colnames(combinedDataset))
colnames(combinedDataset) <- gsub("\\.$","",colnames(combinedDataset))

# Naming the activities by providing them labels
activityLabels <- read.table('./UCI HAR Dataset/activity_labels.txt', sep = " ")
combinedDataset[["activity"]] <- factor(combinedDataset[["activity"]],
                                        levels = activityLabels[,1],
                                        labels = activityLabels[,2])

# Creating descriptive names for columns 
names(combinedDataset) <- gsub("^t", "time", names(combinedDataset))
names(combinedDataset) <- gsub("^f", "frequency", names(combinedDataset))
names(combinedDataset) <- gsub("Acc", "Accelerometer", names(combinedDataset))
names(combinedDataset) <- gsub("Gyro", "Gyroscope", names(combinedDataset))
names(combinedDataset) <- gsub("Mag", "Magnitude", names(combinedDataset))
names(combinedDataset) <- gsub("BodyBody", "Body", names(combinedDataset))

# Using ddply to calculate mean for all columns for each activity in each subject
groupCol = colnames(combinedDataset)[1:2]
finalDataset <- ddply(combinedDataset,groupCol,numcolwise(mean))

# Finally, output the data in text format
write.table(finalDataset,file = 'Tidydataset.txt',row.names = FALSE)