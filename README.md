Air pressure
============

This repository contains a collection of scripts to format air pressure observations for use in historical reanalysis. 

To bring historical air pressure readings to a common format, multiple steps will be needed, some of which may be performed manually on the original data. The remainder of the tasks performed is documented here.

Achievements
-----------------------
* Compute 30-year climatologies from 20CR (3hourly tmin and tmax)
* Insert missing longitudes and latitudes
* Extract 20CR climatologies for all stations
* read in all new stations into R and converted to standard format
* Common long and compact format defined
* Reorganised original files into compact format (Matthias)

Common data format
-----------------------------

The common data format is a table with all available information from the original digitised files. Each line represents a unique observation time and the following list of standard names are used whenever applicable:

* Latitude, Longitude, Elevation for the location of the station
* Location.missing, Elevation.missing to indicate whether location is known or estimated
* Year, Day, Month for observation date
* Local.time for observation time 
* Time.missing to indicate whether time has been estimated
* mmHg.orig (mmHg.derived) for barometer readings in mm
* QFE (.orig, .derived) for station pressure in hPa
* QFF (.orig, .derived) for mean sea level pressure
* TP and TA for temperature at barometer and temperature of outside air


To Do
------------
* Check missing longitudes and latitudes (street addresses in Yuri's paper)
* Check unit conversion of Swedish Series (dec tum, or 1/12 inch?)
* Convert units
* Correct reading for temperature
* Convert to mean sea level
