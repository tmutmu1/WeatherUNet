#!/bin/bash

mkdir -p output
mkdir -p output/combined/
mkdir -p output/combined/mrms
mkdir -p output/combined/hrrr
numjobs=8

runprocessmrms() {
    FILE=$1
    DATE=`echo $FILE | cut -f 3 -d _ | cut -f 1 -d .`
    HOUR="`echo $FILE | cut -f 2 -d - | cut -f 1 -d .`"
    if [[ $HOUR == [0-2][0-9]0000 ]]; then
        if [ ! -f  output/combined/mrms/CONUS_$DATE.png  ]; then
           THECMD="./create_rain_combined.sh  $FILE output/combined/mrms/CONUS_$DATE.png mrms" 
           $THECMD
        fi 
    fi 
}
export -f runprocessmrms

runprocesshrrr() {
    FILE=$1
    YEAR=`echo ${FILE} | cut -f 3 -d / | cut -f 4 -d /`
    MONTH=`echo ${FILE} | cut -f 4 -d / | cut -f 5 -d /`
    DAY=`echo ${FILE} | cut -f 5 -d / | cut -f 6 -d /`
    HOUR=`echo ${FILE} | cut -f 2 -d . | cut -f 3 -d . | cut -f 2 -d t | cut -f 1 -d z`
    DATE=${YEAR}${MONTH}${DAY}-${HOUR}0000
    if [ ! -f  output/combined/hrrr/CONUS_$DATE.png  ]; then
       THECMD="./create_rain_combined.sh  $FILE output/combined/hrrr/CONUS_$DATE.png hrrr" 
       $THECMD

     fi 
}
export -f runprocesshrrr

find mtarchive.geol.iastate.edu/*/*/*/mrms/ncep/SeamlessHSR/ -name "*.grib2.gz" | sort -g | parallel -j $numjobs runprocessmrms
find hrrr/f01/*/*/*/ -name "*.grib2" | sort -g | parallel -j $numjobs runprocesshrrr