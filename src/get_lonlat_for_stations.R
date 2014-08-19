## R-script to read in station longitudes and latitudes and extract
## the 20CR 3-hourly climatologies for temperature reduction

## load necessary libraries
library(ncdf)
library(pressurehelper)
library(XLConnect) ## to read xls

## read in the xls file
stations <- readWorksheetFromFile('Working_inventory_pressure_1815-17.xls', sheet=1)

## convert longitudes and latitudes
stations$lon <- dms2dd(stations$Longitude)
stations$lat <- dms2dd(stations$Latitude)


## read in the 20CR climatologies
nc <- open.ncdf('../20CR/tmean.2m.1871-1900.nc')
lons <- nc$dim$lon$vals
lons[lons > 180] <- lons[lons > 180] - 360
lats <- nc$dim$lat$vals

## get time from netcdf
nctime <- strptime('1800-01-01 00:00', format='%Y-%m-%d %H:%M', tz='GMT') + nc$dim$time$vals *3600 

## read in tmean for stations (as in a loop but with apply)
## smoothed with a 11-day moving average
tmean <- apply(stations, 1, function(x, h=rep(1/11, 11)){
  h <- h / sum(h)
  if (!is.na(x['lon'])){
    lon.i <- which.min((as.numeric(x['lon']) - lons)**2)
    lat.i <- which.min((as.numeric(x['lat']) - lats)**2)
    out <- get.var.ncdf(nc, 'tmax', start=c(lon.i, lat.i, 1), count=c(1,1,-1))
    ## smooth with 5 day moving average
    nday <- length(out) / 8
    out.arr <- array(out, c(8, nday))
    out <- as.vector(t(apply(out.arr, 1, filter, filter=h, circular=TRUE)))
    return(out)    
  } else {
    return(rep(NA, 2928))
  }
})

## convert to data frame
tmean <- as.data.frame(tmean)
names(tmean) <- stations[,1]

## add in times
tmean$doy <- as.numeric(format(nctime, '%j'))
tmean$hour <- as.numeric(format(nctime, '%H'))
tmean$Hour <- paste0(format(nctime, '%H'), ':00')


## to plot the stations and temperature (optional)
library(maps)
library(ggplot2)
library(reshape2)

## plot all the time series with ggplot
ndf <- melt(tmean, id=c('doy', 'hour', 'Hour'))
ndf$temperature <- ndf$value - 273.15
ndf$Hour <- as.factor(ndf$Hour)
ggplot(ndf, aes(x=doy, y=temperature, group=Hour, colour=Hour, name='Time (GMT)')) + geom_line() + facet_wrap( ~ variable, ncol=8)



## plot the stations on a map (fancy)
library(maps)
## map(xlim=c(-120,60), ylim=c(10, 70))
map(xlim=range(stations$lon, na.rm=T) + diff(range(stations$lon, na.rm=T)) * c(-0.1, 0.1),
    ylim=range(stations$lat, na.rm=T) + diff(range(stations$lat, na.rm=T)) * c(-0.1, 0.1))
box()
points(lat ~ lon, data=stations, pch=16, cex=stations[['Total.values.in.1815.17']] / max(stations[['Total.values.in.1815.17']], na.rm=T)*1.5, col='darkred')

