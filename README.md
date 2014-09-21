Getting_Cleaning_Data_P1
========================

Repo for project submission for coursera course "Getting and Cleaning Data" 

The following is a summary of how the R script run_analysis.R works

Step1 : The script reads the necessary .txt files from the working directory. 
All test and training files as well as the features and activity_labels files are read
The command read.table without the header option (since none of the files have headers) achieves the above objective

Step2 : The next few commands in the scipt are to combine the test (X_test, y_test, subject_test) and training (X_train, y_train, subject_train) datasets
The X, y and subject files are merged seperately (using rbind) so that the test and training data are merged seperately to create one each of X, y & subject
dataset. The measurement columns (from the X datasets) are named using the variable names from features.txt file

Step3 : The next step is to extract only the column names from X that contain either "mean" or "std". This extracted data is then merged with the Y and subject
data to get a final dataset called HAR

Step4 : In order to create more meaningful column names, the current column names to a .csv file in the working directory. The file is reformatted to create
column names that are easier to comprehend. The file with the new column names are uploaded to R using write.table. The new column names are then assigned 
to HAR dataset

Step5 : The script then creates and independent tidy data set with the average of each variable for each activity and each subject

