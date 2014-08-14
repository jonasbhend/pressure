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
* Convert compact to long format
* Expand long format (see details):
  * Convert units of pressure and temperature readings
  * Correct reading for temperature
  * Convert to mean sea level

To Do
------------
* Check missing longitudes and latitudes (street addresses in Yuri's paper)
* Check pressure units / values of Paris_b series
* Check calendar dates (Gregorian or Julian?), difference is 12 days from 1st March 1800- 28th of Feb. 1900 where March 1 1800 after Julian is March 13 after Gregorian calendars (difference in accuracy of leap time). Gregorian is the de facto standard since 1582 but countries adopted the Gregorian calendar as late as Greece in 1923.


Common data format
-----------------------------

The common data format is a table with all available information from the original digitised files. Each line represents a unique observation time and the following list of standard names are used whenever applicable:

* **Latitude, Longitude, Elevation** for the location of the station
* **Location.missing, Elevation.missing** to indicate whether location is known or estimated
  0 location or elevation is known
  1 location or elevation has been estimated
* **Year, Day, Month, Time** for observation date and time from original record
* **Local.time** for observation time converted to HH:MM
* **Time.missing** to indicate whether time has been estimated
  0 time is known
  1 time has been estimated (e.g. sunrise)
* **Local.date** Datestring collating the above in local time (YYYY-MM-DD HH:MM:SS)
* **UTC.date** Datestring in UTC (YYYY-MM-DD HH:MM:SS)
* **P, P.1, P.2, P.3** pressure reading in original units
* **P.units** pressure units in original file
* **Tcorr** flag for temperature correction in original record
  0 no temperature correction
  1 corrected 
* **mmHg** barometer readings in mm
* **P.orig** barometer readings in hPa corrected for local gravity
* **QFE** station pressure in hPa reduced to 0 deg. C
* **QFE.flag** temperature correction of station pressure
  0 missing value
  1 corrected in original record (and sometimes rebased, e.g. from 55F to 0C)
  2 corrected using temperature at the barometer
  3 corrected using in-situ outside air temperature
  4 corrected using 20CR climatology
* **QFF** sea level pressure in hPa
* **QFF.flag** temperature used to reduce to sea level
  0 missing value
  1 QFF available from original record
  2 corrected using in-situ outside air temperature
  3 corrected using 20CR climatology
* **TP and TA** for temperature at barometer and temperature of outside air
