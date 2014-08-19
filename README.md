Conversion of historical air pressure data
==========================================

This repository contains a collection of scripts to format and analyse air pressure observations for use in historical reanalysis. 

To bring historical air pressure readings to a common format, multiple steps will be needed, some of which may be performed manually on the original data. The remainder of the tasks and the common (long) data format is documented in [docs] ([.Rmd](docs/pressure_documentation.Rmd)).

Achievements
-----------------------
* Compute 30-year climatologies from 20CR (3hourly tmin and tmax)
* Insert missing longitudes and latitudes
* Extract 20CR climatologies for all stations and travel reports
* read in all new stations into R and converted to standard format
* Common long and compact format defined
* Reorganised original files into compact format (Matthias)
* Convert compact to long format
* Expand long format (see details):
  * Convert units of pressure and temperature readings
  * Correct reading for local gravity
  * Correct reading for temperature
  * Convert to mean sea level
* Added temperature flag for temperature at barometer (0 not available, 1 available, 2 available but maybe outside air temperature)

To Do
------------
* Check missing longitudes and latitudes (street addresses in Yuri's paper)
* Check calendar dates (Gregorian or Julian?), difference is 12 days from 1st March 1800- 28th of Feb. 1900 where March 1 1800 after Julian is March 13 after Gregorian calendars (difference in accuracy of leap time). Gregorian is the de facto standard since 1582 but countries adopted the Gregorian calendar as late as Greece in 1923.
