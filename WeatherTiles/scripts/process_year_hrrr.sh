#!/bin/bash

#fDataset='f00'
fDataset='f01'
export fDataset

mkdir -p data
mkdir -p output
mkdir -p output/hrrr/
mkdir -p output/hrrr/$fDataset
numjobs=8

runprocess() {
    FILE=$1
    #DATE=`echo $FILE | cut -f 3 -d _ | cut -f 1 -d .`
    YEAR=`echo ${FILE} | cut -f 3 -d / | cut -f 4 -d /`
    MONTH=`echo ${FILE} | cut -f 4 -d / | cut -f 5 -d /`
    DAY=`echo ${FILE} | cut -f 5 -d / | cut -f 6 -d /`
    HOUR=`echo ${FILE} | cut -f 2 -d . | cut -f 3 -d . | cut -f 2 -d t | cut -f 1 -d z`
    DATE=${YEAR}${MONTH}${DAY}-${HOUR}0000
    if [ ! -f  output/hrrr/$fDataset/CONUS_$DATE.png  ]; then
       THECMD="./create_hrrr_rain.sh  $FILE output/hrrr/$fDataset/CONUS_$DATE.png" 
       $THECMD

     fi 
}
export -f runprocess

find hrrr/$fDataset/*/*/*/ -name "*.grib2" | sort -g | parallel -j $numjobs --env $fDataset runprocess
