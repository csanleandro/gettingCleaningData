# Getting and Cleaning Data. Course Project

+ Introduction
In this project we have to read and get tidy some experiment results.
We have to sets of data: test data and train data. We have information about subject, activity and a lot of variables for each one (test/train). We also have some files that are unique for both: information about the variables in the test/train files, information about de activities: description

+ Steps
The steps in this script (run_analysis.R) are:
++ Read features.txt, in order to know all the variables in the test/train data files. Check wich of them represent mean or standar deviation.

++ Read group (test(train) files: 
+++ Read Subjet info
+++ read activity info
+++ read data file
+++ select only de variables we are interested in (mean / std)
+++ combine those tables to get the group data set

++ union both data sets (test + train)
++ read activity info and join it with the data set to get activity descriptions

++ group by activity and subject_id, and summarize to get mean of every variable of our dataset

