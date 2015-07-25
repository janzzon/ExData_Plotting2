# plot6.R
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

# Extract SCC:no where Data.Category == "Onroad", save as character
SCC_road <-  SCC %>% filter(Data.Category == "Onroad" ) %>% .$SCC %>% as.character()

# filter, group and summarise the data of the question
q6data <- NEI %>% filter ( fips == "24510" | fips == "06037")%>% filter (SCC %in% SCC_road) 
# create factor of fips and set labels
q6data$fips %<>% factor( levels = c("24510","06037"), labels = c("Baltimore City"," Los Angeles County"))
# Group an summarise
q6data %<>% group_by(year, fips) %>% summarise(Emissions_sum = sum(Emissions))

# Create plot object
q6plot <- 
  qplot(year,Emissions_sum, data = q6data, color = fips) +  geom_point (size = 5) + 
  ggtitle("question 6") +  coord_cartesian(ylim = c(0, max(q6data$Emissions_sum)*1.05)) +
  labs (y = "vehicle combustion-related sources, ton") + geom_smooth(method = "lm")

# create the plot to png-device and close the device
png("plot6.png")
q6plot
dev.off()

