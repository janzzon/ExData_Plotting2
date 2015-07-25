# plot2.R
# https://class.coursera.org/exdata-030/human_grading/view/courses/975125/assessments/4/submissions

# read data
# source("./getDataPlotting2.R", encoding = "UTF-8")

# load required packages
lapply(c("dplyr","magrittr","ggplot2","RCurl","ggplot2"), library, character.only = T)

# location of the data
datasetUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

# create data directory if missing
if (!file.exists("./data")) dir.create("./data")

# download zipped file if missing
if(!file.exists("./data/FNEI_data.zip")) {
  download.file(datasetUrl, "./data/FNEI_data.zip", method="curl")
}

# unzip file
unzip("./data/FNEI_data.zip", exdir = "./data")

# read data from file
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# ---------------------------------------------------------

# filter only  Baltimore City, Maryland (fips == "24510")

NEI_Baltimore <- NEI %>% filter ( fips == "24510" ) 

# summarise emissions per year and create a dataframe w. numeric values
q2data <- with(NEI_Baltimore, tapply(Emissions, year, FUN = sum))
q2dataDf <- data.frame("Year" = as.character(names(q2data)), "Emissions" = as.numeric(q2data))
q2dataDf$Year <- as.numeric(levels(q2dataDf$Year)[q2dataDf$Year])
q2dataDf$Emissions %<>% as.numeric() 
str(q2dataDf)

# create the plot to png-device and close the device
png("plot2.png")

with(q2dataDf, plot(Year, Emissions, ylim = c(0, max(Emissions)), main = "question 2", ylab = "Emissions, ton"))

dev.off()

