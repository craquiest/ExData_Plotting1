# This script creates plot4
# Four graphs in 1
# For 2007-02-01 and 2007-02-02 
# data:Electric power consumption, UC Irvine Machine Learning Repository


# Download and unzip data
# If not necessary, comment out next 4 lines of code 
# destfile <- file.path(".", "the_data.zip")
# url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
# 
# download.file(url,destfile=destfile, method="curl")
# unzip(destfile)


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
# divide Active power by 1000 to have kW
# divide submetering by 1000
# join date and time to make datetime
plot_set_4 <- 
      dataset %>%
      mutate(gApkw = Global_active_power/1000) %>%
      mutate(Voltage =Voltage/1000) %>%
      mutate(gRpkw = Global_reactive_power/1000) %>%
      mutate(Sub_metering_1 = Sub_metering_1/1000) %>%
      mutate(Sub_metering_2 = Sub_metering_2/1000) %>%
      mutate(Sub_metering_3 = Sub_metering_3/1000) %>%
      mutate(datetime = make_datetime(
            year= year(Date),
            month = month(Date),
            day = day(Date),
            hour = hour(Time),
            min = minute(Time)
      ))
      

#Set up png device with pixel size 480 x 480
png(filename = "plot4.png",
   width = 480, height = 480, units = "px")

# Setup layout for 4 graphs 
par(mfrow = c(2, 2))

# Draw graphs one by one 
plot(plot_set_4$datetime  ,plot_set_4$gApkw, type = "l",
     xlab = "", ylab = "Global Active Power")

plot(plot_set_4$datetime  ,plot_set_4$Voltage, type = "l",
     xlab = "datetime", ylab = "Voltage")

plot(plot_set_4$datetime  ,plot_set_4$Sub_metering_1,
     type = "l", xlab = "", ylab = "Energy sub metering")
lines(plot_set_4$datetime , plot_set_4$Sub_metering_2,col="red")
lines(plot_set_4$datetime , plot_set_4$Sub_metering_3,col="blue")
legend("topright", lty = 1, col = c("black", "red","blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       bty = "n") 
# bty = "n" is for the legend box not to have any border

plot(plot_set_4$datetime  ,plot_set_4$gRpkw, type = "l",
     xlab = "datetime", ylab = "Global_reactive_power" )

# Turn off png device
dev.off()



