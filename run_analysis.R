### COURSERA COURSE: Getting and Cleaning Data
### Week 4, Preview Assignment
### Scripted Solution by: Peter Scarbrough
### Last Revision: 9/11/2017, 1:01 PM EST

### OVERVIEW: Downloads, extracts dataset. Merges data to one file. 
### Replaces activity codes with factor labels. Creates more descriptive variable names.
### Filters dataset to only include motion variables with "mean" and "std" data
### Creates tidy dataset summarizing these variables (with mean and std) by acitivity, by subject
### Note: This takes mean of means, mean of standard deviations

### REQUIRED PACKAGES: downloader, dplyr
### Will be prompted to download, install package if not already installed....


### SOURCE CODE:



### Part 1 -- Create install directory, download zip, decompress files

if(!dir.exists("./peerproject")){dir.create("./peerproject")}
if("downloader" %in% rownames(installed.packages()) == F){install.packages("downloader")}
setwd("./peerproject")
require(downloader)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download(url, dest="peerprojectdata.zip", mode="wb")
unzip("peerprojectdata.zip")



### Part 2 -- Read datasets, merge files to create one dataset

# Read the test datasets
setwd("./UCI HAR Dataset")
testsubject <- read.table("./test/subject_test.txt")
testdata <- read.table("./test/X_test.txt")
testactivity <- read.table("./test/y_test.txt")

# Read the training datasets
trainsubject <- read.table("./train/subject_train.txt")
traindata <- read.table("./train/X_train.txt")
trainactivity <- read.table("./train/Y_train.txt")

# Read variable name data, convert to vector
variablenames <- read.table("features.txt")
variablenames <- variablenames$V2 

# Add varible names to test dataset, add then name subject and activity variables
names(testdata) <- variablenames 
testdata <- cbind(testsubject, testactivity, testdata)
names(testdata)[1:2] <- c("Subject", "Activity")

# Add varible names to training dataset, add then name subject and activity variables
names(traindata) <- variablenames
traindata <- cbind(trainsubject, trainactivity, traindata)
names(traindata)[1:2] <- c("Subject", "Activity")

# Merge the test and training datasets
mergedata <- rbind(testdata, traindata)




### Part 3 -- Grab activity code/label data, convert to factor, apply to dataset activity variable

activitylabels <- read.table("activity_labels.txt")
activityfactor <- factor(activitylabels$V2)
mergedata$Activity <- activityfactor[mergedata$Activity]




### Part 4 -- Filter dataset to only include mean() and std() variables, tidy variable names

# create a logical vector to select only mean and standard deviation-containing variables
# modify logical vector so we can keep the subject and activity variables in mergedata
# filter meregedata to only include the selected columns
mean.sd.cols <- grepl("mean\\()|std\\()", variablenames)
mean.sd.cols <- c(T, T, mean.sd.cols)
mergedata <- mergedata[,mean.sd.cols]

# clean up variable names to something more readable
names(mergedata) <- gsub("^t", "Time", names(mergedata))
names(mergedata) <- gsub("^f", "Freq", names(mergedata))
names(mergedata) <- gsub("BodyAcc", "Body", names(mergedata))
names(mergedata) <- gsub("GravityAcc", "Gravity", names(mergedata))
names(mergedata) <- gsub("mean\\()", "Mean", names(mergedata))
names(mergedata) <- gsub("std\\()", "Sd", names(mergedata))
names(mergedata) <- gsub("-", "", names(mergedata))



### Part 5 -- Use merge data to create a tidy dataset with mean of each variable, by subject, by activity

# check is 'dplyr' is installed, and start package (makes the next steps much easier)
if("downloader" %in% rownames(installed.packages()) == F){install.packages("downloader")}
require(dplyr)

# group data by Subject and Activity
group.data <- group_by(mergedata, Subject, Activity)

# generate mean for each variable in merged data, by Subject and Activity
tidy.result <- summarize_all(group.data, mean)
tidy.result <- data.frame(tidy.result)

# Change the variable names to reflect mean calculation, keep old Subject and Activity variable names
names(tidy.result) <- paste(names(tidy.result), "MEAN", sep=".")
names(tidy.result)[1:2] <- c("Subject", "Activity")

# Create an output file of the tidy data for review
setwd("../")
write.table(tidy.result, "course3week4project.txt", row.names=F)
