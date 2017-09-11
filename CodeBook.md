## Code Book -- Getting and Cleaning Data: Week 4 Peer Review Assignment

### Overview

Dataset from motion capture smartphone study are downloaded from the web, merged, filtered, and analyzed.

Original Data Source: 
[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)  
Original Data Description: 
[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

An R script was generated, `run_analysis.R`, to accomplish the specific course instructions: 

1: Merge the training and the test sets to create one data set.  
2: Extract only the measurements on the mean and standard deviation for each measurement.  
3: Use descriptive activity names to name the activities in the data set.  
4: Appropriately labels the data set with descriptive variable names.  
5: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.  


### Notes about R Script

Required libraries: *dplyr, downloader*

The original data files were a mess -- I have no idea why the subject and activity variables weren't merged within the main data files or why the files all had to be named so ambiguously. They are extra columns that should be appended to the main data file; in pseudo code: `cbind(subject_text.txt, Y_test.txt, X_test.txt)` Also, the variable names are located in another directory, and that file ("features.txt") must be read used to give the columns from the main datasets descriptive names. Likewise, the activity data are given as codes and the factor labels are given in a separate data file, which must also be read, converted to an R factor, and used to translate the variables codes into variable labels for the activity variable.

The downloader library was used to more easily unzip the original data files. A working directory "peerproject" is created by the script, all work is performed here and the output file is generated in this directory. The code reads the data files, merges the subject and activity variables to the test or training datasets. Then, the test and training datasets are merged. The activity codes are translated into factor labels. The merged dataset is then trimmed to only include variables that are means or standard deviations (in addition to Subject and Activity variables). Then, the variables are renamed -- please consult the source code for a more direct explanation -- the code itself is more self-explanatory and interpretable than an abstract explanation of what I did or why. Then, the dplyr library is used to group the merged data.frame by Subject and Activity. The means for each of the columns are then calculated, and finally the results are output into `course3week4project.csv`

### Variables

..* activityfactor -- factor to convert activity codes into activity labels
..* activitylabels -- data.frame from `activity_labels.txt` with activity codes (V1) and activity labels (V2)
..* group.data -- grouped_df, tbl_df, and data.frame of merged data, by Subject and Activity variables
..* mean.sd.col -- logical array to select only columns in datasets that contain mean and standard deviation data
..* mergedata -- the merged training and test datasets, with Subject and Activity variables and feature variable names
..* testactivity -- test data activity variable, from `test/Y_test.txt`, to be appended to testdata 
..* testdata --  test data from `test/X_test.txt`, column merged with test subject and test activity variables
..* testsubject -- test data subject variable, from `test/subject_test.txt`, to be appended to testdata
..* tidy.result -- data.frame with means for each variable of mergedata, by Subject and Activity variables -- FINAL RESULT
..* trainactivity -- training data activity variable, from `train/Y_test.txt`, to be appended to traindata
..* traindata -- training data from `train/X_test.txt`, column merged with training subject and training activity variables
..* trainsubject -- training data subject variable, from `train/subject_test.txt`, to be appended to traindata
..* url -- character vector containing path to original data file
..* variablenames -- character vector of variable names for datasets, taken from `features.txt`  

### Output

course3week4project.csv
..* comma-separated dataset
..* The first column is Subject by ID
..* The second column is Activity by factor label
..* The next 66 columns are means for each of the indicated variables, by Subject and Activity
