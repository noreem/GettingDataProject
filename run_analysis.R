# Setting up

if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

library(data.table)
library(reshape2)


# Getting the data

setwd("C:/Work/DataScience/GettingDataProject")

# Download the file to "./Data/Dataset.zip" if it doesn't exist

downloadUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataDirPath <- "./Data"
zipFilepath <- file.path(dataDirPath,"Dataset.zip")

if(!file.exists(dataDirPath)) {
  dir.create(dataDirPath)
  if(!file.exists(zipFilepath)) {
    download.file(downloadUrl, zipFilepath)
  }
}


#Unzip the dataset to the "./Data" directory

unzip(zipFilepath, exdir = dataDirPath)
datasetPath = file.path(dataDirPath, "UCI HAR Dataset")

# Load the data

subjectTrain <- read.csv(file.path(datasetPath, "train", "subject_train.txt"), sep = "", header = FALSE)
subjectTest <- read.csv(file.path(datasetPath, "test", "subject_test.txt"), sep = "", header = FALSE)
trainingSet <- read.csv(file.path(datasetPath, "train", "X_train.txt"), sep = "", header = FALSE)
trainingLabels <- read.csv(file.path(datasetPath, "train", "y_train.txt"), sep = "", header = FALSE)
testSet <- read.csv(file.path(datasetPath, "test", "X_test.txt"), sep = "", header = FALSE)
testLabels <- read.csv(file.path(datasetPath, "test", "y_test.txt"), sep = "", header = FALSE)

features <- read.csv(file.path(datasetPath, "features.txt"), sep = "", header = FALSE)[,2]
activityLabels <- read.csv(file.path(datasetPath, "activity_labels.txt"), sep = "", header = FALSE)[,2]

# Merge the data and add descriptive activity names

subject <- rbind(subjectTrain, subjectTest)
colnames(subject)[1] <- "Subject"

labels <- rbind(trainingLabels, testLabels)
colnames(labels)[1] <- "ActivityNumber"

dataset <- rbind(trainingSet, testSet)

colnames(dataset) <- features

subject <- cbind(subject, labels, activityLabels[labels[,1]])
colnames(subject)[3] <- "ActivityName"
dataset <- cbind(subject, dataset)

# Extract only the mean and standard deviation

filterFeatures <- grepl("mean|std", features)
dataset <- dataset[,filterFeatures]

# Pivot data

idLabels = c("Subject", "ActivityNumber", "ActivityName")
dataLabels = setdiff(colnames(dataset), idLabels)
pivotData = melt(dataset, id = idLabels, measure.vars = dataLabels)

# Tidy data

tidyData   = dcast(pivotData, Subject + ActivityName ~ variable, mean)
write.table(tidyData, file = "./tidyData.txt")