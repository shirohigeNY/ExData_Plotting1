# by ShirohigeNY
#
#Plot 2 script

#check if dat file exists, first for the zipped and then for the unzipped data files
#
#
does<-file.exists('./exdata-data-household_power_consumption.zip')

if (does == FALSE)
{download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
               ,destfile='./exdata-data-household_power_consumption.zip')
  unzip ('./exdata-data-household_power_consumption.zip')
}

does2<-file.exists('./household_power_consumption.txt')

if (does2 == FALSE){
  unzip ('./exdata-data-household_power_consumption.zip')
}

#
#
#

library(readr)
#library(lubridate)

pwrdata<-read_csv2('./household_power_consumption.txt',col_types='ccccccccc',na='?')

#Coerce columns to desired type

pwrdata$Global_active_power<-as.numeric(pwrdata$Global_active_power)
pwrdata$Global_reactive_power<-as.numeric(pwrdata$Global_reactive_power)
pwrdata$Voltage<-as.numeric(pwrdata$Voltage)
pwrdata$Global_intensity<-as.numeric(pwrdata$Global_intensity)
pwrdata$Sub_metering_1<-as.numeric(pwrdata$Sub_metering_1)
pwrdata$Sub_metering_2<-as.numeric(pwrdata$Sub_metering_2)
pwrdata$Sub_metering_3<-as.numeric(pwrdata$Sub_metering_3)

#make new column "Date_Time" which has date and time in POSIXlt combined to ease subsetting
colshem<-c("Date","Time")
pwrdata$Date_Time<-do.call("paste", c(pwrdata[colshem],sep=" "))
pwrdata$Date_Time<-strptime(pwrdata$Date_Time, "%d/%m/%Y %H:%M:%S")


#subset desired dates
pwrdata_sub<-subset(pwrdata, Date_Time > as.POSIXlt('2007-02-01 00:00:00') & 
                      Date_Time < as.POSIXlt('2007-02-02 23:59:59'))

# add column with name of day
#pwrdata_sub$dayofweek<-wday(as.POSIXlt(pwrdata_sub$Date_Time), label=TRUE, abbr=FALSE)



#Plot the subset as plot FOR global active power for the desired days


with(pwrdata_sub, plot (Date_Time, Global_active_power , type = 'l',
                            ylab = 'Global Active Power (kilowatts)',
                            xlab = ''   ))






#Copy the plot into file 'plot2.png'

dev.copy(png, file = "plot2.png")
dev.off()






