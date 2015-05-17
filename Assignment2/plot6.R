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

subSCC <- SCC[grepl("Highway Veh | Duty Vehicles | Traffic",SCC$Short.Name),]
dt <- merge(NEI, subSCC,by='SCC')

pm25_year_type <- aggregate(Emissions ~ year+fips,
                            dt[dt$fips == "24510" | dt$fips == "06037",] ,sum)
difference <- round(diff(pm25_year_type$Emissions),0)
difference[length(unique(pm25_year_type$year))] <- ""

library(ggplot2)
png("plot6.png", width=640, height=480)
ggplot(data=pm25_year_type, aes(x=as.factor(year), y=Emissions)) + 
        ylab(expression(paste('PM'[2.5], ' emissions, tons'))) + xlab('Year') + 
        ggtitle('Vehicle-related emissions in 
                \nLos-Angeles (06037)         and         Baltimore (24510)   ') +
        geom_bar(stat="identity",fill="blue")+
        geom_text(aes(label=c("",difference)), vjust=0)+
        geom_line(aes(group=1, col="red")) + 
        theme(legend.position='none') + facet_grid(. ~ fips)
dev.off()