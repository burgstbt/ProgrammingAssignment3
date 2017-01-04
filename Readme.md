# Analysis of Activity Tracking Data


This project is about tidying, transforming and analysing data from an accelerometers eperiment from the Samsung Galaxy S smartphone. Detailed information about the data sets origin are available under <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>


## 1. Contents

This Github project contains several files:
+ This Markdown readme file `Readme.md`
+ Analysis script `run_analysis.R` written in R language which is described in detail below
+ A tidy data set called `tidy_data`
+ A code book Markdown file called `CodeBook.md` describing the variables, the data, and any transformations or work that has been performed to clean up the data

## 2. Description of `run_analysis.R` Script

### Read Data

In a first step, the script first reads all data from the respective files using the `read.table` function to make use of the default values for headers already set to **FALSE** and separator set to **""**.

```R
# Read master data
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

# Read test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")

# Read training data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("UCI HAR Dataset/train/x_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

```

### Merge training and test set

In the next step, the data is merged together. First, the three files of the trainings data are merged: Activities, subjects performing the activities, and recorded data. The same is done for the test data set resulting in two identically structure data sets.
Afterwards, the test data is concatenated to the training data using row-binding resulting in a total data frame called `data`.

```R
# Bind together training data
train_vals <- cbind(y_train, subject_train, x_train)

# Bind togehther training data
test_vals <- cbind(y_test, subject_test, x_test)

# Combine data sets
data <- rbind(train_vals, test_vals)

```

### Set appropriate variable names and merge activities

In this step, variable names are set for the total data set `data` using the names contained in the data set `features`. Then the headers for the activity data set which contains the activity labels for the activity identifiers are set.
Next, the activity labels are merged into the total data set, using the **Activity ID** as a common identifier.
As a last step of this section, the colum containing *Activity IDs* is removed from the data set, because it is not needed anymore and the activities are  identified by their name.

```R
# Set headers for total data set
names(data)[1] <- "Activity ID"
names(data)[2] <- "SubjectID"
names(data)[3:length(data)] <- t(features[2])

# Set headers for activity data set
names(activity_labels) <- c("ID", "Activity")

# Merge activity labels
data <- merge(activity_labels, data, by.x = "ID", by.y = "Activity ID")

# Remove not needed column containing activity IDs
data <- data[c(2,3,grep("[Mm]ean|std", names(data)))]
```

### Create data set with average of each variable for each activity and each subject

The last section of the script uses **dplyr** to group the data set by *SubjectID* and *Activity*, and then calculate the mean of every variable contained in the data set. The data set is handed from one function to the next using the *pipe* operator `%>%`. This is the data set that has also been uploaded to this git repository.

```R
data_mean <- data %>%
  group_by(SubjectID,Activity) %>%
  summarize_all(funs(mean))
```