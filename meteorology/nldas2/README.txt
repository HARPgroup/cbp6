Install instructions

- Edit Makefile and uncomment the correct GDAL_INC and GDAL_LIB for your install
  (there's got to be a better way... 
    for example: 
      gdal-config --libs 
    returns
      -L/usr/lib -lgdal
  )

- create a shared executable so users can just type NLDAS2_GRIB_to_ASCII
  sudo ln [path to nldas2]/NLDAS2_GRIB_to_ASCII /usr/local/bin/NLDAS2_GRIB_to_ASCII
for example:
  sudo ln /opt/model/cbp6/meteorology/nldas2/NLDAS2_GRIB_to_ASCII /usr/local/bin/NLDAS2_GRIB_to_ASCII


COMPILE 
- "make all" will create NLDAS2_GRIB_to_ASCII, but not NLDAS2_ASCII_to_LSegs
- "make NLDAS2_ASCII_to_LSegs" will make NLDAS2_ASCII_to_LSegs (to do, add this to the "all" section)
