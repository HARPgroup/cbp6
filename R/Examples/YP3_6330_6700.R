# This script is meant to show how to download formatted data from USGS, CBP model, or VA Hydro sources,
# trim the data to the proper study period, calculate all the comparison metrics, and generate the
# data frame containing all data and the percent differences between them.

# INPUTS -----

basepath <- '/var/www/R' # must contain "config.local.private" file with directions to github repositories
site <- 'http://deq2.bse.vt.edu/d.dh' # vahydro site to download from -- d.dh or d.bet
riv.seg <- 'YP3_6330_6700' # river segment of interest
gage.num <- '01671020' # USGS gage associated with river segment
start.date <- '1984-01-01'
end.date <- '2014-12-31'


# SETUP -----

setwd(basepath) # sets working directory to /var/www/R directory -- the output location

source(paste(basepath,"config.local.private", sep = "/")) # loads in repository directories
source(paste0(cbp6_location,"/code/cbp6_functions.R")) # loads in functions of cbp6 package
source(paste(github_location,"auth.private", sep = "/")) # loads in VA Hydro authorization creds
source(paste(cbp6_location, "/code/fn_vahydro-1.0.R", sep = '')) # loads in essential VA Hydro fns
token <- rest_token(site, token, rest_uname, rest_pw); # gets token used to download VA Hydro data
options(timeout=1200); # set timeout to twice default level to avoid abort due to high traffic


# OBTAINING DATA -----
gage.dat <- gage_import_data_cfs(gage.num, start.date, end.date)
model.dat <- model_import_data_cfs(riv.seg, mod.phase = 'p6/p6_gb604', mod.scenario = 'CFBASE30Y20180615',
                                   start.date, end.date)
vahydro.dat <- vahydro_import_data_cfs(riv.seg, run.id = 11, token, site, start.date, end.date)


# TRIMMING DATA -----
gage.dat <- water_year_trim(gage.dat)
model.dat <- water_year_trim(model.dat)
vahydro.dat <- water_year_trim(vahydro.dat)

# CALCULATING METRICS -----
gage.metrics <- metrics_calc_all(gage.dat)
model.metrics <- metrics_calc_all(model.dat)
vahydro.metrics <- metrics_calc_all(vahydro.dat)

# VAHYDRO METRIC PUSH/PULL -----
# METRICS WOULD USUALLY BE POSTED TO VAHYDRO CONTAINERS AT THIS POINT
# METRICS WOULD THEN BE PULLED FROM VAHYDRO CONTAINERS IN A DIFFERENT SCRIPT, HERE.

# COMPARING METRICS -----
gage.v.model <- metrics_compare(gage.metrics, model.metrics, riv.seg)
gage.v.vahydro <- metrics_compare(gage.metrics, vahydro.metrics, riv.seg)

# EXPORTING METRICS AS .CSV
write.csv(gage.v.model, paste0(basepath, "/gage.v.model.csv"))
write.csv(gage.v.vahydro, paste0(basepath, "/gage.v.vahydro.csv"))