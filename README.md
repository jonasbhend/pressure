Conversion of historical air pressure data
==========================================

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
  * Correct reading for local gravity
  * Correct reading for temperature
  * Convert to mean sea level

To Do
------------
* Check missing longitudes and latitudes (street addresses in Yuri's paper)
* Check pressure units / values of Paris_b series
* Check calendar dates (Gregorian or Julian?), difference is 12 days from 1st March 1800- 28th of Feb. 1900 where March 1 1800 after Julian is March 13 after Gregorian calendars (difference in accuracy of leap time). Gregorian is the de facto standard since 1582 but countries adopted the Gregorian calendar as late as Greece in 1923.
* Temperature flag: 0 known, 1 unkonwn (at barometer or outside)


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
  * 0 missing value
  * 1 corrected in original record (and sometimes rebased, e.g. from 55F to 0C)
  * 2 corrected using temperature at the barometer
  * 3 corrected using in-situ outside air temperature
  * 4 corrected using 20CR climatology
* **QFF** sea level pressure in hPa
* **QFF.flag** temperature used to reduce to sea level
  * 0 missing value
  * 1 QFF available from original record
  * 2 corrected using in-situ outside air temperature
  * 3 corrected using 20CR climatology
* **TP and TA** for temperature at barometer and temperature of outside air



Processing of pressure data
---------------------------------------------

### Conversion of units ###
Pressure in original units is converted to mm Hg using the appropriate conversion factors. The conversion factors are detailed below. Generally, only the largest length unit used is indicated, sub-units follow base 12 unless specified.
* **English inches:** 1 in = 2.54 cm
* **French inches:** 1 in = 2.707 cm
* **Swedish inches:** 1 tum = 2.969 cm
* **Rijnlands inches:** 1 in = 2.62 cm

### Correction of barometer readings to standard conditions ###
We correct all converted barometer readings in mmHg to standard correction. This involves a correction for local gravity and a correction for temperature following [WMO 2010][WMO2010]. Barometer readings that are available in hPa are only corrected for temperature if metadata does not indicate that such a correction has already been performed. 

#### Correction for local gravity ####
To convert the pressure reading in mmHg to hPa we use the following formula:
$$ P_{n} = \rho * g_{\Phi,h} * mmHg * 1e-5 $$
where $P_{n}$ is the absolute pressure in hPa reduced to normal gravity, $\rho=1.35951e4$ is the density of mercury at 0\u00b0 C, $g_{\Phi,h}$ is the local gravity (see below), and $mmHg$ is the barometer reading in mm. This is equivalent to correcting pressure in hPa for local gravity by using
$$ P_{n} = g_{\Phi,h} / g_{n} * P_{0} $$
where $P_{0}$ is the absolute pressure not reduced to normal gravity and $g_{n}=9.80665 ms**{–2}$.

Local gravity $g_{\Phi,h}$ is estimated based on the latitude and elevation assuming flat terrain around the station
$$g_{\Phi,h} = 9.80620 ms**{-2} * (1 - 0.0026442 * \cos{\Phi} - 0.0000058 * \cos{\phi}**2) - 0.000003086 * h$$
where $h$ is the elevation above mean sea level in m.


[WMO2010]: http://library.wmo.int/pmb_ged/wmo_8_en-2012.pdf "Guide to Meteorological Instruments and Methods of Observation. WMO-No. 8, 2008 edition, updated in 2010."

