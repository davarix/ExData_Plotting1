setwd("/Users/dariagan/Documents/COURSERA/exploratory_analysis")
# Load libraries
library (dplyr)

# If raw data file is missing in the working directory, download and unzip the file from url

if (!file.exists("household_power_consumption.txt") == TRUE) {
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(url, file.path(getwd(), "HPC.zip"), method = "curl")
        unzip("EPC.zip")
}

# Load data

## load first 5 rows to get columns names and classes
hpc5rows <- read.table(file = "household_power_consumption.txt", 
                       header = TRUE, 
                       sep =";", 
                       na.strings = "?", 
                       nrows = 5)

classes <- sapply(hpc5rows, class)

## load data from source for 2 dates : 1/2/2007 and 2/2/207
hpc <- read.table(file = "household_power_consumption.txt", 
                  header = FALSE, 
                  sep =";", 
                  na.strings = "?", 
                  skip = 66637, 
                  nrows = 2880, 
                  col.names = names(hpc5rows),
                  colClasses = classes)

# Transform data and time variables from character to date

date.format <- as.Date(hpc$Date, format = "%d/%m/%Y")
date.time.format <- strptime(paste(hpc$Date, hpc$Time, sep = " "), format = "%d/%m/%Y %H:%M:%S")

# Transform data as numeric vectors
globalActivePower <- as.numeric(hpc$Global_active_power)
globalReactivePower <- as.numeric(hpc$Global_reactive_power)
voltage <- as.numeric(hpc$Voltage)
subMetering1 <- as.numeric(hpc$Sub_metering_1)
subMetering2 <- as.numeric(hpc$Sub_metering_2)
subMetering3 <- as.numeric(hpc$Sub_metering_3)

#Print the graph to the plot4.png
png("plot4.png", width=480, height=480)
par(mfrow = c(2, 2)) 
## plot 1
plot(date.time.format, globalActivePower, type="l", xlab="", ylab="Global Active Power", cex=0.2)
## plot 2 
plot(date.time.format, voltage, type="l", xlab="datetime", ylab="Voltage")
## plot 3
plot(date.time.format, subMetering1, type="l", ylab="Energy Submetering", xlab="")
lines(date.time.format, subMetering2, type="l", col="red")
lines(date.time.format, subMetering3, type="l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=, lwd=2.5, col=c("black", "red", "blue"), bty="o")
## plot4
plot(date.time.format, globalReactivePower, type="l", xlab="datetime", ylab="Global_reactive_power")

dev.off()