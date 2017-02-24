library(sqldf)


# Function that merges two datasets and provides the means/stds of various factors
run_analysis <- function() {

  #First:  Read source data
        
        subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")     #Person
        x_test <- read.table("UCI HAR Dataset/test/X_test.txt")                 #DAta
        y_test <- read.table("UCI HAR Dataset/test/y_test.txt")                 #Activity
        activityNames <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F)      #Activity Names
        
        subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
        y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
        x_train <- read.table("UCI HAR Dataset/train/X_train.txt")


        
  #Second:  Merge the train and test data sets, eventually smoosh them into one huge set later

        # create Person data set
        x_merged <- rbind(x_train, x_test)
        
        # create Activity data set
        y_merged <- rbind(y_train, y_test)
        names(y_merged) <- "ActivityID"
        names(activityNames) <- c("ActivityID", "Activity")
        y_merged <- sqldf("SELECT activityNames.Activity FROM y_merged JOIN activityNames USING(ActivityID)")
        
        # create Ssubject data set
        subject_merged <- rbind(subject_train, subject_test)
        
        

  #Third:  Only get the columns that have "mean" or "std" in them


        features <- read.table("UCI HAR Dataset/features.txt")
        selectedFeatureNames <-  grep("mean|std", features[, 2])

        x_merged <- x_merged[, selectedFeatureNames]
        names(x_merged) <- sapply(features[selectedFeatureNames, 2], function(x) gsub("\\(\\)", "", x))
        names(x_merged) <- sapply(names(x_merged), function(x) gsub("\\-", "_", x))
        
        


  #Fourth:  Combine into single set then do column means
        names(subject_merged) <- "Subject"

        # bind all the data in a single data set
        allData <- cbind(subject_merged, y_merged, x_merged  )
        
        
        sqlQuery <- "SELECT Subject, Activity, "
        
        for(col in colnames(allData)) {
                if (col != "Subject" && col != "Activity") 
                        sqlQuery <- paste(sqlQuery, "AVG(", col, "), ", sep = "")
                        
                
        }
        
        sqlQuery <- paste(sqlQuery, "FROM allData GROUP BY Subject, Activity ")
        sqlQuery <- gsub(",  FROM", " FROM", sqlQuery)
        
   
        returnData <- sqldf(sqlQuery)
   
        write.table(returnData, "averages.txt", row.name=FALSE)

}
