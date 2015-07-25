# plot5.R
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

# names(SCC)

# Extract SCC:no where Data.Category == "Onroad", save as character
SCC_road <-  SCC %>% filter(Data.Category == "Onroad" ) %>% .$SCC %>% as.character()

# filter, group and summarise the data of the question
q5data <- NEI %>% filter ( fips == "24510" )%>% filter (SCC %in% SCC_road) %>% group_by(year) %>% summarise(Emissions_sum = sum(Emissions))

# Create plot object
q5plot <- qplot(year,Emissions_sum, data = q5data) +  geom_point (size = 5) + 
  ggtitle("question 5") +  coord_cartesian(ylim = c(0, max(q5data$Emissions_sum)*1.05)) +
  labs (y = "vehicle combustion-related sources, ton") 

# create the plot to png-device and close the device
png("plot5.png")
q5plot
dev.off()

