import wget
import datetime
import os
import time

# fDataset='f00'
fDataset='f01'

field = "sfc" # reflectivity
# field = "prs" # pressure files for combined

hrrrLogFile='hrrr_processed_images.txt' # for hrrr
# hrrrLogFile='hrrr_processed_images_combined.txt' # for combined

if field == "prs":
	fDataset='f00'
	dataType = "hrrr_prs"
	hrrrLogFile='hrrr_processed_images_combined.txt'
elif field == "sfc":
	dataType = "hrrr"

date = datetime.datetime(2018, 7, 1, 0)

timeInterval = datetime.timedelta(hours=1)
dir_path = os.path.dirname(os.path.realpath(__file__))
if not os.path.isfile(str(dir_path)+str(hrrrLogFile)):
		f= open(str(hrrrLogFile),"w+")
		f.close()

try:
	os.mkdir(str(dir_path)+"/"+str(dataType))
except:
	pass

try:
	os.mkdir(str(dir_path)+"/"+str(dataType)+"/"+str(fDataset))
except:
	pass

for i in range(15000):	
	url = "https://pando-rgw01.chpc.utah.edu/hrrr/"+str(field)+"/"+date.strftime("%Y")+date.strftime("%m")+date.strftime("%d")+"/hrrr.t"+date.strftime("%H")+"z.wrf"+str(field)+str(fDataset)+".grib2"
	directory = str(dir_path)+"/"+str(dataType)+"/"+str(fDataset)+"/"+date.strftime("%Y")+"/"+date.strftime("%m")+"/"+date.strftime("%d")
	try:
		os.mkdir(str(dir_path)+"/"+str(dataType)+"/"+str(fDataset)+"/"+date.strftime("%Y"))
	except:
		pass
	try:
		os.mkdir(str(dir_path)+"/"+str(dataType)+"/"+str(fDataset)+"/"+date.strftime("%Y")+"/"+date.strftime("%m"))
	except:
		pass
	try:
		os.mkdir(str(dir_path)+"/"+str(dataType)+"/"+str(fDataset)+"/"+date.strftime("%Y")+"/"+date.strftime("%m")+"/"+date.strftime("%d"))
	except:
		pass
	with  open(hrrrLogFile) as f:
		if not os.path.isfile(str(directory +"/hrrr.t"+date.strftime("%H")+"z.wrf"+str(field)+str(fDataset)+".grib2")) and not str(str(dataType)+"/"+str(fDataset)+date.strftime("/%Y/%m/%d/")+"hrrr.t"+date.strftime("%H")+"z.wrf"+str(field)+str(fDataset)+".grib2") in f.read():
			try:
				wget.download(url, out=directory)
			except:
				print(url, "did not download!")
	date += timeInterval