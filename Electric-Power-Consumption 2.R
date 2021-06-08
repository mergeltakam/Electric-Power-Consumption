tbl = read.table('household_power_consumption.txt', dec = ".", stringsAsFactors = FALSE, 
                 colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), header = TRUE, sep = ";", na.strings = "?")

names(tbl) <- c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")

# subset data to and remove original data table to free space
data = subset(tbl, tbl$Date == "1/2/2007" | tbl$Date == "2/2/2017")

library(dplyr)
# new column date_time for x axis
data$Date <- as.Date(data$Date, "%d/%m/%Y")
data = mutate(data, date_time = as.POSIXct(paste(data$Date, data$Time, sep=" "), template = "%d/%m/%Y %H:%M:%S", tz = Sys.timezone()))

png("plot1.png", width=480, height=480)
hist(data$Global_active_power, col = "red", main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)", ylim = c(0,1200), 
     xlim = c(0,6), breaks = 12)
dev.off()

png("plot2.png", width=480, height=480)
plot(x=data$date_time, y = data$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
dev.off()

png("plot3.png", width=480, height=480)
with(data, 
     { plot(x=date_time, y = Sub_metering_1, type="l", col = "black", xlab="", ylab="Energy sub metering")
       lines(x=date_time, y = Sub_metering_2, type="l", col = "red")
       lines(x=date_time, y = Sub_metering_3, type="l", col = "blue")
       legend("topright", lty = "solid", col = c("black", "red", "blue"), 
              legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"))
     })
dev.off()

png("plot4.png", width=480, height=480)
par(mfrow = c(2,2))

#Test de commit

# Top-left
# Line, x = time_date, y = Global Active Power
plot(x=data$date_time, y = data$Global_active_power, type="l", col = "black", xlab="", ylab="Global active power")

# Top-right
# Line, x = time_date, y = Voltage, ylab: datetime
plot(x=data$date_time, y = data$Voltage, type="l", col = "black", ylab="Voltage", xlab = "datetime")

# Bottom-left
# Plot 3
with(data, 
     { plot(x=date_time, y = Sub_metering_1, type="l", col = "black", xlab="", ylab="Energy sub metering")
       lines(x=date_time, y = Sub_metering_2, type="l", col = "red")
       lines(x=date_time, y = Sub_metering_3, type="l", col = "blue")
       legend("topright", lty = "solid", col = c("black", "red", "blue"), 
              legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"))
     })

# Line, x = time_date, y = Global_reactive_power, ylim[0.0:0.5], ylab: datetime
plot(x=data$date_time, y = data$Global_reactive_power, type="l", col = "black", ylab="Global_reactive_power", xlab = "datetime")
dev.off()





