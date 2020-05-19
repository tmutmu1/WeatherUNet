#!/bin/bash
file="$1"

dataType="$3"



echo "file:" $file
echo "output:" $2

if [ $dataType = "mrms" ]; then
	conusnew="`echo ${file} | cut -f -7 -d /`/CONUSNEW_`echo ${file} | cut -f 8 -d / | cut -f -2 -d .`.grib2"
	conusinput="`echo ${file} | cut -f -7 -d /`/CONUSINPUT_`echo ${file} | cut -f 8 -d / | cut -f -2 -d .`.grib2"
	conustranslated="`echo ${file} | cut -f -7 -d /`/CONUSTRANSLATED_`echo ${file} | cut -f 8 -d / | cut -f -2 -d .`.grib2"
	zcat "${file}" > $conusnew || { rm $file; echo "${file} was corrupted so it has been deleted."; exit 1; }
	wgrib2 "${conusnew}" -set_var REFD -grib_out $conusinput
	gdal_translate -projwin_srs "EPSG:4326" -projwin -90.769043 37.527154 -88.209043 34.967154 "${conusinput}" "${conustranslated}"
fi
if [ $dataType = "hrrr" ]; then
	conusnew="`echo ${file} | cut -f -5 -d /`/CONUSNEW_`echo ${file} | cut -f 6 -d /`"
	conusinput="`echo ${file} | cut -f -5 -d /`/CONUSINPUT_`echo ${file} | cut -f 6 -d /`"
	conustranslated="`echo ${file} | cut -f -5 -d /`/CONUSTRANSLATED_`echo ${file} | cut -f 6 -d /`"
	wgrib2 "${file}" -match "REFC" -grib_out $conusnew || { rm $file; echo "${file} was corrupted so it has been deleted."; exit 1; }
	gdal_translate -projwin_srs "EPSG:4326" -projwin -90.769043 37.527154 -88 34 -tr 1000 1000 "${conusnew}" "${conusinput}"
	gdal_translate -srcwin 0 0 256 256 "${conusinput}" "${conustranslated}"
fi
if [ $dataType = "hrrr_pressure_velocity" ]; then
	conusnew="`echo ${file} | cut -f -5 -d /`/CONUSNEW_`echo ${file} | cut -f 6 -d /`"
	conusinput="`echo ${file} | cut -f -5 -d /`/CONUSINPUT_`echo ${file} | cut -f 6 -d /`"
	conustranslated="`echo ${file} | cut -f -5 -d /`/CONUSTRANSLATED_`echo ${file} | cut -f 6 -d /`"
	wgrib2 "${file}" -match "VVEL" -match "500 mb" -grib_out $conusnew || { rm $file; echo "${file} was corrupted so it has been deleted."; exit 1; }
	gdal_translate -projwin_srs "EPSG:4326" -projwin -90.769043 37.527154 -88 34 -tr 1000 1000 "${conusnew}" "${conusinput}"
	gdal_translate -srcwin 0 0 256 256 "${conusinput}" "${conustranslated}"
	gdaldem color-relief "${conustranslated}" -alpha palettes/radar_pal_pressure_velocity.txt -of PNG "${2}"

fi
if [ $dataType = "hrrr_pressure" ]; then
	conusnew="`echo ${file} | cut -f -5 -d /`/CONUSNEW_`echo ${file} | cut -f 6 -d /`"
	conusinput="`echo ${file} | cut -f -5 -d /`/CONUSINPUT_`echo ${file} | cut -f 6 -d /`"
	conustranslated="`echo ${file} | cut -f -5 -d /`/CONUSTRANSLATED_`echo ${file} | cut -f 6 -d /`"
	wgrib2 "${file}" -match "PRES" -match "surface" -grib_out $conusnew || { rm $file; echo "${file} was corrupted so it has been deleted."; exit 1; }
	gdal_translate -projwin_srs "EPSG:4326" -projwin -90.769043 37.527154 -88 34 -tr 1000 1000 "${conusnew}" "${conusinput}"
	gdal_translate -srcwin 0 0 256 256 "${conusinput}" "${conustranslated}"
	gdaldem color-relief "${conustranslated}" -alpha palettes/radar_pal_pressure.txt -of PNG "${2}"

fi
if [ $dataType = "hrrr_temperature" ]; then
	conusnew="`echo ${file} | cut -f -5 -d /`/CONUSNEW_`echo ${file} | cut -f 6 -d /`"
	conusinput="`echo ${file} | cut -f -5 -d /`/CONUSINPUT_`echo ${file} | cut -f 6 -d /`"
	conustranslated="`echo ${file} | cut -f -5 -d /`/CONUSTRANSLATED_`echo ${file} | cut -f 6 -d /`"
	wgrib2 "${file}" -match "TMP" -match "500 mb" -grib_out $conusnew || { rm $file; echo "${file} was corrupted so it has been deleted."; exit 1; }
	gdal_translate -projwin_srs "EPSG:4326" -projwin -90.769043 37.527154 -88 34 -tr 1000 1000 "${conusnew}" "${conusinput}"
	gdal_translate -srcwin 0 0 256 256 "${conusinput}" "${conustranslated}"
	gdaldem color-relief "${conustranslated}" -alpha palettes/radar_pal_temperature.txt -of PNG "${2}"

fi
if [ $dataType = "mrms" ] || [ $dataType = "hrrr" ]; then
	gdaldem color-relief "${conustranslated}" -alpha palettes/radar_pal3.txt -of PNG "${2}"
fi


if [ $dataType = "hrrr" ] || [ $dataType = "hrrr_pressure_velocity" ]; then
	grep -qxF "$file" hrrr_processed_images_combined.txt || echo "$file" >> hrrr_processed_images_combined.txt
fi

rm "$conusinput"
rm "$conustranslated"
rm "$conusnew"
