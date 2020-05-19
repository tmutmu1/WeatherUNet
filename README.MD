# Using Radar Data to Predict the Weather


Steps to clone and use WeatherUNet:

1. Clone repo
2. Change path in runit.sh to path of repo
3. `./buildit.sh`
4. `./runit.sh`
5. cd to scripts in WeatherTiles
6. `./download_year.sh` for mrms or edit and run fDataset, field, and hrrrLogFile in download_year_hrrr.py for hrrr or combined (hrrr f01 and hrrr_prs f00)
7. `./process_year.sh`, `./process_year_hrrr.sh`, or `./process_year_combined.sh` respectively
8. Install Pillow, opencv, numpy, nodejs for tqdm, pytorch, matplotlib, imageio, torchsummary if you plan to run the UNet or process images other than for the combined dataset
9. Open `jupyter-lab`
10. If not using combined, change the paths and run all cells of the respective crop_and_resize notebook
11. If mrms, run remove_nulls notebook
12. Change paths, _dataset, _channels, train and val sizes, and _usingColab. Then run all cells of pytorch_resnet18_unet notebook
    - eg. change the ubuntuos/etc... to your own repository where the data is located and etc...

