# This script creates plot1
# Histogram of Global Active Power 
# For 2007-02-01 and 2007-02-02 
# data:Electric power consumption, UC Irvine Machine Learning Repository


# Download and unzip data
# If not necessary, comment out next 4 lines of code 
destfile <- file.path(".", "the_data.zip")
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

download.file(url,destfile=destfile, method="curl")
unzip(destfile)


# If data already in working directory start here
library(tidyverse)
library(lubridate)

# Set paath , platform independant
path <- file.path(".", "household_power_consumption.txt")

# set the column types for read_csv2 (readr package)
col_types <- cols(
      Date = col_date(format = "%d/%m/%Y"),
      Time = col_time(format = "%H:%M:%S"),
      Global_active_power = col_number(),
      Global_reactive_power = col_number(),
      Voltage = col_number(),
      Global_intensity = col_number(),
      Sub_metering_1 = col_number(),
      Sub_metering_2 = col_number(),
      Sub_metering_3 = col_number()
)

#Read in data with col_types, and filter to only 2 dates before storing     
dataset <- 
      read_csv2(path, na=c("?",""), col_types = col_types) %>%
      filter(Date %in% c(ymd("2007-02-01"), ymd("2007-02-02")))

# Setup the plot_set, ie the data to be plotted 
# with necessary transformations
plot_set_1 <- 
      dataset %>% select(Global_active_power) %>%
      mutate(gapkw =Global_active_power/1000)

#Set up png device with pixel size 480 x 480
png(filename = "plot1.png", width = 480, height = 480, units = "px")

# Draw histogram, specifying color, title, and label 
hist(plot_set_1$gapkw,
     col= "red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     )

# Turn off png device
dev.off()



