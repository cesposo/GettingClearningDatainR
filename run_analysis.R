library(plyr)

test <- read.table(file = 'C:/Coursera Classes/Getting and Cleaning Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt')
test_lab <- read.table(file = 'C:/Coursera Classes/Getting and Cleaning Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt')
subject_test <- read.table(file = 'C:/Coursera Classes/Getting and Cleaning Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt')

training <- read.table('C:/Coursera Classes/Getting and Cleaning Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt')
training_lab <- read.table('C:/Coursera Classes/Getting and Cleaning Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt')
subject_training <- read.table(file = 'C:/Coursera Classes/Getting and Cleaning Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt')

features <- read.table('C:/Coursera Classes/Getting and Cleaning Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt', colClasses = 'character')
actvity_lab <- read.table('C:/Coursera Classes/Getting and Cleaning Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt', col.names = c('ID', 'Activity'))


# Merging the training and testing set
  
merged_dat_1 <- cbind(cbind(test, subject_test), test_lab)  
merged_dat_2 <- cbind(cbind(training, subject_training), training_lab)
merged_dat_3 <- rbind(merged_dat_1, merged_dat_2)

merged_dat_4 <- rbind(features, c(562, "Subject"))
merged_dat_5 <- rbind(merged_dat_4, c(563, "ID"))

# Extract the measurements on the mean and standard deviation for each measurment 

col_var_1 <- merged_dat_5[, 2]
names(merged_dat_3) <- col_var_1

Extraction <- merged_dat_3[, grepl("mean|std|Subject|ID", names(merged_dat_3))]  


# Use descriptive actitivity names to name the activities of the data set

Extraction <- join(Extraction, actvity_lab,  by = 'ID', match = "first" )
Extraction <- Extraction[, -1]


# Appropriately labels the data set with descriptive variable names


names(Extraction) <- gsub("\\(|\\)", "", names(Extraction), perl = TRUE)
names(Extraction) <- make.names(names(Extraction))



# From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject
# Write Data to text file


Extraction_1 = ddply(Extraction, c("Subject","Activity"), numcolwise(mean))
write.table(Extraction_1, file = "C:/Coursera Classes/Getting and Cleaning Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/Extraction_1.txt", row.names = FALSE)