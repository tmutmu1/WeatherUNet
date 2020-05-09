import wget
import datetime
import os
import time

# fDataset='f00'
fDataset='f01'
# hrrrLogFile='hrrr_processed_images.txt' # for hrrr
hrrrLogFile='hrrr_processed_images_combined.txt' # for combined
date = datetime.datetime(2018, 7, 1, 0)

timeInterval = datetime.timedelta(hours=1)
dir_path = os.path.dirname(os.path.realpath(__file__))
if not os.path.isfile(str(dir_path)+"/hrrr_processed_images.txt"):
		f= open("hrrr_processed_images.txt","w+")
		f.close()
if not os.path.isfile(str(dir_path)+"/hrrr_processed_images_combined.txt"):
		f= open("hrrr_processed_images_combined.txt","w+")
		f.close()
try:
	os.mkdir(str(dir_path)+"/hrrr/"+str(fDataset))
except:
	pass

for i in range(15000):	
	url = "https://pando-rgw01.chpc.utah.edu/hrrr/sfc/"+date.strftime("%Y")+date.strftime("%m")+date.strftime("%d")+"/hrrr.t"+date.strftime("%H")+"z.wrfsfc"+str(fDataset)+".grib2"
	directory = str(dir_path)+"/hrrr/"+str(fDataset)+"/"+date.strftime("%Y")+"/"+date.strftime("%m")+"/"+date.strftime("%d")
	try:
		os.mkdir(str(dir_path)+"/hrrr/"+str(fDataset)+"/"+date.strftime("%Y"))
	except:
		pass
	try:
		os.mkdir(str(dir_path)+"/hrrr/"+str(fDataset)+"/"+date.strftime("%Y")+"/"+date.strftime("%m"))
	except:
		pass
	try:
		os.mkdir(str(dir_path)+"/hrrr/"+str(fDataset)+"/"+date.strftime("%Y")+"/"+date.strftime("%m")+"/"+date.strftime("%d"))
	except:
		pass
	with  open(hrrrLogFile) as f:
		if not os.path.isfile(str(directory +"/hrrr.t"+date.strftime("%H")+"z.wrfsfc"+str(fDataset)+".grib2")) and not str("hrrr/"+str(fDataset)+date.strftime("/%Y/%m/%d/")+"hrrr.t"+date.strftime("%H")+"z.wrfsfc"+str(fDataset)+".grib2") in f.read():
			try:
				wget.download(url, out=directory)
			except:
				print(url, "did not download!")
	date += timeInterval