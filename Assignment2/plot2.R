fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
fileZIP <- "Data.zip"
file_summ <- "summarySCC_PM25.rds"
file_class <- "Source_Classification_Code.rds"
exist_files <- (file.exists(file_summ) & file.exists(file_class))

if (!file.exists(fileZIP) & !exist_files  ) {
        download.file(fileURL,destfile=fileZIP,method="curl")
}
if (file.exists(fileZIP) & !exist_files  ) {
        unzip(zipfile=fileZIP)
}
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

pm25_year <- aggregate(Emissions ~ year, NEI[NEI$fips=="24510", ], sum)

png('plot2.png')
barplot(height=pm25_year$Emissions, 
        names.arg=pm25_year$year, 
        xlab="years", ylab=expression('PM'[2.5]*', tons'),
        main=expression('Total PM'[2.5]*' emissions in Baltimore'))
dev.off()