#!/bin/bash

mkdir -p data
mkdir -p output
mkdir -p output/conus/
numjobs=2

runprocess() {
    FILE=$1
    DATE=`echo $FILE | cut -f 3 -d _ | cut -f 1 -d .`
    if [ ! -f  output/conus/CONUS_$DATE.png  ]; then
       THECMD="./create_mrms_rain_conus.sh  $FILE output/conus/CONUS_$DATE.png" 
       $THECMD

     fi 
}
export -f runprocess

find -type f -wholename './mtarchive.geol.iastate.edu/*/*/*/mrms/ncep/SeamlessHSR/*.grib2.gz' | sort -g | parallel -j $numjobs runprocess
