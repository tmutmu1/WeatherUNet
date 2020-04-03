#!/bin/bash


mkdir -p data
mkdir -p output

#FILECOUNT=$(ls -f mtarchive.geol.iastate.edu/*/*/*/mrms/ncep/SeamlessHSR/*.grib2.gz | wc -l)
FILECOUNT=1
INDEX=0
maxjobs=8


echo "Files:" $FILECOUNT
for file in mtarchive.geol.iastate.edu/*/*/*/mrms/ncep/SeamlessHSR/*.grib2.gz; do
    FILE=$file
    DATE=`echo $FILE | cut -f 3 -d _ | cut -f 1 -d .`
    mkdir -p output/conus/
    if [ ! -f  output/conus/CONUS_$DATE.png  ]; then
       THECMD="./create_mrms_rain_conus.sh  $FILE output/conus/CONUS_$DATE.png" 
       #echo $THECMD
       if (( $(($((++n)) % $maxjobs)) == 0 )) ; then
       	$THECMD &
       fi

       #let "INDEX = $((INDEX+1))"
       #PERCENTCOMPLETE=$((100*INDEX/FILECOUNT))
       #echo  "$PERCENTCOMPLETE% Complete"
     fi 
done
