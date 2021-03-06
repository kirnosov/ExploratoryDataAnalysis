# clean up the environment
rm(list=ls())

# to start with, let us download the project data,
# unzip it and delete the zip.
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
fileName <- "household_power_consumption.txt"
cat("Checking file","\n")
if (!file.exists(fileName)) {
        cat("Downloading data","\n")
        download.file(fileUrl,destfile="./DataZIP.zip",method="curl")
        unzip(zipfile="./DataZIP.zip")
        unlink("DataZIP.zip")
}

# i will be using dplyr library functions to prepare the data for graphing
library(dplyr)
cat("Reading and preprocessing data","\n")
data <- read.table(fileName, header=TRUE, sep=";", stringsAsFactors=FALSE, dec=".") %>%
        mutate(Date = as.Date(Date, format="%d/%m/%Y")) %>%
        subset(Date =="2007-02-01" | Date =="2007-02-02") %>%
        mutate(DateTime = as.POSIXct(paste(Date, Time))) %>%
        select(-(Date:Time)) %>%
        mutate_each( funs(as.numeric), Global_active_power:Sub_metering_3 )

# plot 2
png("plot2.png", width=480, height=480)
with(data, {
        plot(Global_active_power~DateTime, type="l",
             ylab="Global Active Power (kilowatts)", xlab="")
})
invisible(dev.off())
cat("Plot 2 is placed into \n",getwd(),"\n")

# clean up
rm(list=ls())
