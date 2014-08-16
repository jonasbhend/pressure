## main script to process atmospheric pressure data from repository

## load package with helper functions
library(pressurehelper)

## filepath for output files
storpath <- '~/Unibe/pressure/long_data'

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

## Get the 1815-17 period to do statistics
PP <- lapply(PP, function(x) x[x$Year %in% 1815:1817, ])

pdf('figures/simple_pressure_evaluation.pdf', width=8.3, height=11.7, paper='special')
par(mfrow=c(3,1), mar=c(0.5, 5, 0.5, 0.5), oma=c(15, 0, 0.5, 0.5), cex.axis=1.4, cex.lab=1.4)
## plot the average number of observations a day per station
plot(sapply(PP, nrow)/1096, type='h', lwd=10, lend=3, col=grey(0.5), ylab='Average number of obs. per day 1815-17', xaxt='n')

## plot the mean sea level pressure
qffcol <- hcl(13, l=c(10,40,80), c=20)
plot(sapply(PP, function(x) mean(x$QFF, na.rm=T)), type='h', lwd=10, lend=3, xaxt='n', ylim=c(950,1030), xlab='', ylab='Annual mean SLP (hPa)', col=qffcol[sapply(PP, function(x) median(x$QFF.flag[x$QFF.flag != 0], na.rm=T))])
legend('bottomleft', c('Available from digitized record', 'Reduced to SL with in-situ temperature', 'Reduced with derived temperature climatology (20CR)'), fill=qffcol, cex=par('cex.axis')*0.8, inset=0.02, bg='white')

## plot the mean sea level pressure
qfecol <- hcl(h=243, l=c(10,30,50,80), c=20)
plot(sapply(PP, function(x) mean(x$QFE, na.rm=T)), type='h', lwd=10, lend=3, xaxt='n',  xlab='', ylab='Annual mean absolute pressure (hPa)', col=qfecol[sapply(PP, function(x) median(x$QFE.flag[x$QFE.flag != 0], na.rm=T))], ylim=c(850, 1020))
axis(1, at=seq(PP), labels=names(PP), tick=F, las=3)
legend('bottomleft', c('Available from digitized record', 'Reduced to 0\u00b0 with temperature at barometer', 'Reduced to 0\u00b0 with outside air temperature', 'Reduced to 0\u00b0 with derived temperature climatology (20CR)'), fill=qfecol, cex=par('cex.axis')*0.8, inset=0.02, bg='white')
dev.off()


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
