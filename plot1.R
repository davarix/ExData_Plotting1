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

hpc <- tbl_df(hpc)
arrange(hpc, Date, Time)
date.format <- as.Date(hpc$Date, format = "%d/%m/%Y")
date.time.format <- strptime(paste(hpc$Date, hpc$Time, sep = " "), format = "%d/%m/%Y %H:%M:%S")
hpc_data <- hpc[, 3:9]
hpc_wdates <- cbind(date.format, date.time.format, hpc_data)
colnames(hpc_wdates) <- names(hpc5rows)

# Creates histogram png
png("plot1.png", width=480, height=480)
with(hpc_wdates, 
     hist(Global_active_power, 
          main = "Global active power",
          freq = TRUE,
          col = "red",
          xlab = "Global active power (in kilowatt)",
          ylab = "Frequency",
          xlim = c(0, 6),
          ylim = c(0, 1200),
          xaxt = "n"))
axis(side=1, at=c(0, 2, 4, 6))

dev.off()