# creates a data folder if doesn't exist
if (!file.exists("data")) {
    dir.create("data")
}

# downloads zip file from link
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

download.file(url, destfile = "powerconsumption.zip")

# unzips file
unzip("powerconsumption.zip", exdir = "data")

# reads results into a dataframe
power <- read.table("./data/household_power_consumption.txt", header = TRUE,
                    sep = ";", stringsAsFactors = FALSE)

# cleans up dataframe (replace ? with NA)
for (i in names(power)) {
    power[i][power[i] == '?'] <- NA
}

# changes the classes of the columns
for (i in 3:9) {
    power[,i] <- as.numeric(power[,i])
}
# limits dates to only 2007-02-01 and 2007-02-02
power <- power[power$Date == '1/2/2007' | power$Date == '2/2/2007',]

# changes date and time from character to date and time 
power$DateTime <- strptime(paste(power$Date, power$Time, sep = " "),
                           "%d/%m/%Y %H:%M:%S")


# This section covers the plotting of the chart
png(filename = "plot3.png", width = 480, height = 480)
plot(power$DateTime, power$Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering")
lines(power$DateTime, power$Sub_metering_1, col="black", type = "l")
lines(power$DateTime, power$Sub_metering_2, col="red", type = "l")
lines(power$DateTime, power$Sub_metering_3, col="blue", type = "l")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lwd = 1)
dev.off()