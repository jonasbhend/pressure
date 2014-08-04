#!/bin/bash

## script to compute 6-hourly climatologies from 20CR

## data are actually 3-hourly not 6-hourly
datapath=/mnt/climstor/noaa/20cr/6-hourly/gaussian/monolevel
storpath=/scratch/jonas/20cr

## set up temporary files
tmp1=$storpath/tmp1.nc ## contains the result of previous sum
tmp2=$storpath/tmp2.nc ## contains the result of new sum

## compute climatologies for two periods
for syear in 1871 1961 ; do
    for varname in tmin tmax ; do
	let eyear=syear+29
	## first iteration
	let yr=syear+1
	## important to start sum with 1872 in order to get 366 days
	cdo -b 32 add $datapath/$varname.2m.$yr.nc $datapath/$varname.2m.$syear.nc $tmp1
	
	## loop through remaining years
	while [[ $yr -lt $eyear ]] ; do
	    let yr=yr+1
	    ## order of sum is important to keep leap years (366 days)
	    if [[ $syear -eq 1961 && $yr -eq 1964 ]] ; then
		## reverse order for first leap year in second period
		cdo -b 32 add $datapath/$varname.2m.$yr.nc $tmp1 $tmp2
	    else
		cdo -b 32 add $tmp1 $datapath/$varname.2m.$yr.nc $tmp2
	    fi
	    mv $tmp2 $tmp1 
	done ## end of while loop on years
	
	## compute the average
	cdo -r divc,30 $tmp1 $storpath/$varname.2m.$syear-$eyear.nc
	rm $tmp1

    done ## end of loop on variable names
done ## end of loop on startyears for climatologies

exit