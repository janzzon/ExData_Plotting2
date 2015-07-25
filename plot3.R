# plot3.R
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
head(NEI)

# filter, group and summarise the data of the question
q3data <- NEI %>% filter ( fips == "24510" ) %>% group_by(year, type) %>% summarise(Emissions_sum = sum(Emissions))
# make type a factor
q3data$type %<>% as.factor()

# Create plot object
q3plot <- qplot(year,Emissions_sum, data = q3data, color = type) +  geom_point (size = 5) + geom_smooth(method = "loess") +
  ggtitle("question 3") + labs (y = "coal combustion-related sources, ton") 

# create the plot to png-device and close the device
png("plot3.png")
suppressWarnings(q3plot)
dev.off()
