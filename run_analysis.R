## Substitute the path below to your working directory that has all the files
## to be imported

setwd("C:/Personal/Krithi/KProfessional/Coursera_GettingandCleaningData/CourseProject")

## Read the test and training files into R
Xtest <- read.table("./X_test.txt")
Ytest <- read.table("./y_test.txt")
Subjtest <- read.table("./subject_test.txt")
Xtrain <- read.table("./X_train.txt")
Ytrain <- read.table("./y_train.txt")
Subjtrain <- read.table("./subject_train.txt")
Features <- read.table("./features.txt")

## Combine test and train data for X, Y and subject individually

Xdata <- rbind(Xtest,Xtrain)
Ydata <- rbind(Ytest,Ytrain)
Subjdata <- rbind(Subjtest,Subjtrain)

## Xdata has the various measurements and is assigned column names using the 
## data from Features.txt file
## The columns in Y and Subject are named "Activity" and "Subject" respectively

colnames(Xdata) <- Features$V2
colnames(Ydata) <- "Activity"
colnames(Subjdata) <- "Subject"

## From Xdata, get only the columns that are either "means" or 
## "standard deviations"
X_Mean <- Xdata[grep("mean",colnames(Xdata))]
X_Std <- Xdata[grep("std",colnames(Xdata))]
  
## Create a consolidated data that now includes the measurements (X_Mean and 
## X_Std), Activities (Ydata) and Subjects (Subjdata)
HAR_Data <- data.frame(cbind(X_Mean, X_Std,Ydata,Subjdata))

## Using the data from activity_labels file, create a new column that
## contains the desciption of the activities (EG: Walking, Walking_Upstairs,etc.)
Act_Lab <- read.table("./activity_labels.txt")
colnames(Act_Lab) <- c("Activity","ActivityName")
HAR <- merge(HAR_Data,Act_Lab,by.x="Activity",by.y="Activity",all=TRUE)
HAR$Activity <- NULL

## In order to create more meaningful column names, first download the 
## current column names to a .csv file in the working directory

write.table(Test,file="FinalColNames.csv")

## This file was used to reformat the column names using the following logic

## F or T indicate Frequency Domain and Time Domain respectively

## Since most measurements are for Body acceleration, and very few are for 
## measuring Gravity, "Body" is not explicitly specified. Unless the variable 
## name contains "Gravity", the measurement is for "Body"

## Acc indicates measurements from Accelerator
## Gyro indicates measurements from Gyroscope

## Jerk indicates Jerk signals

## Mean and Std indicate Mean and Standard Deviation respectively
## X,Y,Z indicate the axial direction of the signals. If a variable name does
## does contain X,Y or Z, it indicates the effective magnitude of the signals
## across all 3 axes combined

## Following is the command to read the file with the formatted variable names
## This file is also saved as .csv in the github repo

NewLabels <- read.table("./NewColNames.csv", sep=",", header=TRUE)

## Assign the new labels as column names to HAR dataset
colnames(HAR) <- NewLabels$New_Labels

HAR$Act_Subj <- paste(HAR$ActivityName,HAR$Subject)

HARMelt <- melt(HAR,id=c("Act_Subj"),measure.vars=c('T_Acc_Mean_X','T_Acc_Mean_Y','T_Acc_Mean_Z','T_Gravity_Acc_Mean_X','T_Gravity_Acc_Mean_Y','T_Gravity_Acc_Mean_Z','T_Acc_Jerk_Mean_X','T_Acc_Jerk_Mean_Y','T_Acc_Jerk_Mean_Z','T_Gyro_Mean_X','T_Gyro_Mean_Y','T_Gyro_Mean_Z','T_Gyro_Jerk_Mean_X','T_Gyro_Jerk_Mean_Y','T_Gyro_Jerk_Mean_Z','T_Acc_Mean','T_Gravity_Acc_Mean','T_Acc_Jerk_Mean','T_Gyro_Mean','T_Gyro_Jerk_Mean','F_Acc_Mean_X','F_Acc_Mean_Y','F_Acc_Mean_Z','F_Acc_MeanFreq_X','F_Acc_MeanFreq_Y','F_Acc_MeanFreq_Z','F_Acc_Jerk_Mean_X','F_Acc_Jerk_Mean_Y','F_Acc_Jerk_Mean_Z','F_Acc_Jerk_Meanfreq_X','F_Acc_Jerk_MeanFreq_Y','F_Acc_Jerk_MeanFreq_Z','F_Gyro_Mean_X','F_Gyro_Mean_Y','F_Gyro_Mean_Z','F_Gyro_MeanFreq_X','F_Gyro_MeanFreq_Y','F_Gyro_MeanFreq_Z','F_Acc_Mean','F_Acc_MeanFreq','F_Acc_Jerk_Mean','F_Acc_Jerk_MeanFreq','F_Gyro_Mean','F_Gyro_MeanFreq','F_Gyro_Jerk_Mean','F_Gyro_Jerk_MeanFreq','T_Acc_Std_X','T_Acc_Std_Y','T_Acc_Std_Z','T_Gravity_Acc_Std_X','T_Gravity_Acc_Std_Y','T_Gravity_Acc_Std_Z','T_Acc_Jerk_Std_X','T_Acc_Jerk_Std_Y','T_Acc_Jerk_Std_Z','T_Gyro_Std_X','T_Gyro_Std_Y','T_Gyro_Std_Z','T_Gyro_Jerk_Std_X','T_Gyro_Jerk_Std_Y','T_Gyro_Jerk_Std_Z','T_Acc_Std','T_Gravity_Acc_STD','T_Acc_Jerk_Std','T_Gyro_Std','T_Gyro_Jerk_Std','F_Acc_Std_X','F_Acc_Std_Y','F_Acc_Std_Z','F_Acc_Jerk_Std_X','F_Acc_Jerk_Std_Y','F_Acc_Jerk_Std_Z','F_Gyro_Std_X','F_Gyro_Std_Y','F_Gyro_Std_Z','F_Acc_Std','F_Acc_Jerk_Std','F_Gyro_Std','F_Gyro_Jerk_Std'))

Final <- dcast(HARMelt,Act_Subj ~ variable, mean)
