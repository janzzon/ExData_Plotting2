# plot4.R
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

# Extract SCC:no where EI.Selector conains "coal", save as character
SCC_coal <- SCC$SCC[grep("coal", SCC$EI.Sector, ignore.case = T)] %>% unique() %>% as.character()

# filter, group and summarise the data of the question
q4data <- NEI %>% filter (SCC %in% SCC_coal) %>% group_by(year) %>% summarise(Emissions_sum = sum(Emissions))

# Create plot object
q4plot <- qplot(year,Emissions_sum, data = q4data) +  geom_point (size = 5) + 
  ggtitle("question 4") +  coord_cartesian(ylim = c(0, max(q4data$Emissions_sum)*1.05)) +
  labs (y = "coal combustion-related sources, ton") 

# create the plot to png-device and close the device
png("plot4.png")
q4plot
dev.off()

