## Load necessary libraries

# Load dplyr library
library(dplyr)


## Read data from files

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


## Merge training and test set

# Bind together training data
train_vals <- cbind(y_train, subject_train, x_train)

# Bind togehther training data
test_vals <- cbind(y_test, subject_test, x_test)

# Combine data sets
data <- rbind(train_vals, test_vals)


## Set appropriate variable names and merge activities

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


## Create data set with average of each variable for each activity
## and each subject
data_mean <- data %>% group_by(SubjectID,Activity) %>% summarize_all(funs(mean))
