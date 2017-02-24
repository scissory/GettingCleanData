# Introduction

The script `run_analysis.R`performs the analysis to converge multiple datasets and finds column averages for average 
and standard deviation columns

* First, all data us the similar data is read into separate data frames.  
* Second, we merge the training and testing sets and merge in the clear text definitions of the activities
* Third, we filter out all the columns that do not have "mean" or "std" in their names.  Also clean up troblesome
characters in the column names like () and -
* Finally, cbind all the datasets together and do a sqldf query to get column averages by Subject and Activity

# Variables

* `x_train`, `y_train`, `x_test`, `y_test`, `activityNames`, `subject_train` and `subject_test` contain the data from the downloaded files.
* `x_merge`, `y_merge` and `subject_merge` merge the previous datasets to further analysis.
* `features` and `selectedFeatureNames` contains the names for the columns specified for this assignment.
* `allData` merges all the data into one super set
* `returnData` computes the column averages, grouped by Subject and Activity
