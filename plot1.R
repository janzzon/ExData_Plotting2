# plot1.R
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

# summarise emissions per year and create a dataframe w. numeric values
q1data <- with(NEI, tapply(Emissions, year, FUN = sum))
q1dataDf <- data.frame("Year" = as.character(names(q1data)), "Emissions" = as.numeric(q1data))
q1dataDf$Year <- as.numeric(levels(q1dataDf$Year)[q1dataDf$Year])
q1dataDf$Emissions %<>% as.numeric() 
str(q1dataDf)

# create the plot to png-device and close the device
png("plot1.png")

with(q1dataDf, plot(Year, Emissions, ylim = c(0, max(Emissions)), main = "question 1", ylab = "Emissions, ton"))

dev.off()
