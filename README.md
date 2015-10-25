# How the script works

1. Getting the data: downloading and unziping in `./Data` directory
2. Load the data in memory
3. Merge the data and add descriptive activity names
4. Extract only the mean and standard deviation
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# How to run the scrip
1. Put the `run_analysis.R` script wherever
2. setwd() to where you downloaded `run_analysis.R`
2. Run source("run_analysis.R") and it'll generate tidyData.txt
