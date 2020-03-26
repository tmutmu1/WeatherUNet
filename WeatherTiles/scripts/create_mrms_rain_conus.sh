#!/bin/bash

#
# /data2/weather/MRMS/20170209/
# /data2/weather/MRMS/20170209/MRMS_PrecipFlag_00.00_20170209-235800.grib2.gz  /data2/weather/MRMS/20170209/MRMS_SeamlessHSR_00.00_20170209-235800.grib2.gz
#

#
# $1 is the input file
# $2 is the output directory
# $3 is the precip type

#
# check to see if the file ends in gzip
#   if gzip, use the virtual file system so we don't have to uncompress the file
#### WE DON'T NEED TO GUNZIP - WILL USE zcat BELOW
file="$1"
#if [ ${file: -3} == ".gz" ]
#then
#  file=/vsigzip/${file}
#fi

file2="$3"
#### WE DON'T NEED TO GUNZIP - WILL USE zcat BELOW
#if [ ${file2: -3} == ".gz" ]
#then
#  file2=/vsigzip/${file2}
#fi


echo "file:" $file
#echo "file2:"
#echo $file2
echo "output:" $2
CONUSINPUT="${file::-9}-conusinput.grib2"
CONUSNEW="${file::-9}-conusnew.grib2"

#
# create a new grib that has both the precip flag (file2) and the seamless HSR on it (file)
#
zcat $file > $CONUSINPUT

wgrib2 $CONUSINPUT -set_var REFD -grib_out $CONUSNEW

gdaldem color-relief $CONUSNEW -alpha palettes/radar_pal3.txt -of PNG $2

#VRT conusnow.vrt

#gdal_translate -a_ullr -180 90 180 -90 -a_srs "EPSG:4326" -of VRT conusnow.vrt -of JPEG $2 

# 128x160 image
#gdal_translate -projwin -124.1 49 -115.85 42.4  -a_srs "EPSG:4326"  out.vrt -of PNG  $2

# create tiles
#python ./gdal2tiles.py -r bilinear  -z 0-9 now.vrt $2 


#python ./gdal2tiles.py -r bilinear  now.vrt $2 
#echo $1 > $2/source.txt

rm $CONUSINPUT
rm $CONUSNEW || echo "Failed to remove $COUNSNEW"
#rm conusnow.vrt
rm $CONUSNEW.aux.xml ||  echo "Failed to remove $COUNSNEW.aux.xml"
