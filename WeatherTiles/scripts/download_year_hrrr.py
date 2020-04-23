import wget
import datetime
import os
import time

date = datetime.datetime(2019, 1, 1, 0)

timeInterval = datetime.timedelta(hours=1)
dir_path = os.path.dirname(os.path.realpath(__file__))
for i in range(10000):	
	url = "https://pando-rgw01.chpc.utah.edu/hrrr/sfc/"+date.strftime("%Y")+date.strftime("%m")+date.strftime("%d")+"/hrrr.t"+date.strftime("%H")+"z.wrfsfcf00.grib2"
	directory = str(dir_path)+"/hrrr/"+date.strftime("%Y")+"/"+date.strftime("%m")+"/"+date.strftime("%d")
	try:
		os.mkdir(str(dir_path)+"/hrrr/"+date.strftime("%Y")+"/"+date.strftime("%m"))
	except:
		pass
	try:
		os.mkdir(str(dir_path)+"/hrrr/"+date.strftime("%Y")+"/"+date.strftime("%m")+"/"+date.strftime("%d"))
	except:
		pass
		
	if not os.path.isfile(str(directory +"/hrrr.t"+date.strftime("%H")+"z.wrfsfcf00.grib2")):
		try:
			wget.download(url, out=directory)
		except:
			print(url, "did not download!")
	date += timeInterval
	time.sleep(.1)