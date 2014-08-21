## main script to process atmospheric pressure data from repository
setwd('~/Unibe/pressure')

## load package with helper functions
library(pressurehelper)

## filepath for output files
storpath <- 'long_data'

## get stations to be read in (from main Excel file)
inventory <- read_inventory()
stations <- sort(inventory$Standard.Name)

## loop through stations and read in pressure data
PP <- list()
for (stn in stations){
  PP[[stn]] <- try(expand_long(read_pressure(stn)), silent=TRUE)
  if (class(PP[[stn]]) == 'try-error') PP[[stn]] <- NULL
}

## print output on success-rate
print(paste('Read in and converted', length(PP), 'out of', length(stations), 'stations'))
print('Atmospheric pressure conversion for:')
for (stn in setdiff(stations, names(PP))) print(stn)
print('not successful')

## merge all the data into one giant data.frame
dnames <- Reduce(intersect, lapply(PP, names))
PPmerge <- Reduce(rbind, lapply(PP, function(x) x[,dnames]))

## write out complete (as far as truncated .xls files go) data set to Rdata object
save(PP, file='data/all_station_and_travel_pressure_data.Rdata')

## Get the 1815-17 period to do statistics
PP <- lapply(PP, function(x) x[x$Year %in% 1815:1817, ])
PPmerge <- PPmerge[PPmerge$Year %in% 1815:1817,]

## write out subset for 1815-1817
save(PP, file='data/all_station_and_travel_pressure_data_1815-17.Rdata')

for (stn in names(PP)){
  ## convert date objects in data frame to character for output
  ptmp <- PP[[stn]]
  ptmp$UTC.date <- as.character(ptmp$UTC.date)
  ptmp$Local.date <- as.character(ptmp$Local.date)
  
  ## write output to Excel
  writeWorksheetToFile(paste0(storpath, '/', stn, '_long.xls'), ptmp, sheet=stn)
  ## garbage collection (for memory management)
  gc()
}

## quit and say goodbye
print('Good-bye')
## q(save='no')
