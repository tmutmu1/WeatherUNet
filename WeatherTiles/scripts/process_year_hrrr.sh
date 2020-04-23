#!/bin/bash

mkdir -p data
mkdir -p output
mkdir -p output/conus/
numjobs=8

runprocess() {
    FILE=$1
    #DATE=`echo $FILE | cut -f 3 -d _ | cut -f 1 -d .`
    YEAR=`echo ${FILE} | cut -f 3 -d / | cut -f 4 -d /`
    MONTH=`echo ${FILE} | cut -f 4 -d / | cut -f 5 -d /`
    DAY=`echo ${FILE} | cut -f 5 -d / | cut -f 6 -d /`
    HOUR=`echo ${FILE} | cut -f 3 -d . | cut -f 4 -d . | cut -f 2 -d t | cut -f 1 -d z`
    DATE=${YEAR}${MONTH}${DAY}-${HOUR}0000
    if [ ! -f  output/hrrr/CONUS_$DATE.png  ]; then
       THECMD="./create_hrrr_rain.sh  $FILE output/hrrr/CONUS_$DATE.png" 
       $THECMD

     fi 
}
export -f runprocess

find -type f -wholename './hrrr/*/*/*/*.grib2' | sort -g | parallel -j $numjobs runprocess
