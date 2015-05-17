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
dt <- merge(NEI, SCC[grepl("coal", SCC$Short.Name, ignore.case=TRUE),], by='SCC')

pm25_year_type <- aggregate(Emissions ~ year,dt ,sum)

library(ggplot2)
png("plot4.png", width=640, height=480)
ggplot(data=pm25_year_type, aes(x=as.factor(year), y=Emissions)) + 
        ylab(expression(paste('PM'[2.5], ' emissions, tons'))) + xlab('Year') + 
        ggtitle('Cole-related emissions') +
        geom_bar(stat="identity",fill="blue")+
        geom_text(aes(label=round(Emissions,0)), vjust=0)+
        geom_line(aes(group=1, col="red")) + geom_point(aes(size=2, col="red")) + 
        theme(legend.position='none') 
dev.off()