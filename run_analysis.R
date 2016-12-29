library(plyr)
URL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Read train files
x_train<-read.table("UCI Har Dataset/train/X_train.txt")
y_train<-read.table("UCI Har Dataset/train/y_train.txt")
subject_train<-read.table("UCI Har Dataset/train/subject_train.txt")

#Read test files
x_test<-read.table("UCI Har Dataset/test/X_test.txt")
y_test<-read.table("UCI Har Dataset/test/y_test.txt")
subject_test<-read.table("UCI Har Dataset/test/subject_test.txt")

#Create x, y and subject datasets
x<-rbind(x_train,x_test)
y<-rbind(y_train,y_test)
subject<-rbind(subject_train,subject_test)

#Get only columns with Mean and Standard Deviation
features<-read.table("UCI Har Dataset/features.txt")
featuresNeeded<-grep("-(mean|std)\\(\\)",features[,2])

#Subset columns and rename
x<-x[,featuresNeeded]
names(x)<-features[featuresNeeded,2]

#Read activity file and correct activity names with descriptive names
activity_labels<-read.table("UCI Har Dataset/activity_labels.txt")
y[,1]<-activity_labels[y[,1],2]
names(y)<-"Activity"

#Correct column name
names(subject)<-"Subject"

#Create one dataset
all<-cbind(x,y,subject)

#Create independent tidy dataset. Leaves out last two columns as they are activity and subject
averages<-ddply(all,. (Subject,Activity),function(x) colMeans(x[,1:66]))

#Writes to txt file
write.table(averages,"tidy_dataset.txt",row.name=FALSE)