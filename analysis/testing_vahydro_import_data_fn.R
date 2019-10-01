library(pander);
library(httr);
library(hydroTSM);

# Load Libraries
hydro_tools <- 'C:/Users/danie/Documents/HARP/GitHub/hydro-tools';
cbp6_link <- 'C:/Users/danie/Documents/HARP/GitHub/cbp6';
source(paste(hydro_tools,"VAHydro-2.0/rest_functions.R", sep = "/")); 
source(paste(hydro_tools,"VAHydro-1.0/fn_vahydro-1.0.R", sep = "/"));  
source(paste(hydro_tools,"LowFlow/fn_iha.R", sep = "/"));
source(paste(cbp6_link, 'code/cbp6_functions.R', sep = "/"))

site <- "http://deq2.bse.vt.edu/d.dh" 

source(paste(hydro_tools,"auth.private", sep = "/"));#load rest username and password, contained in auth.private file
token <- rest_token(site, token, rest_uname, rest_pw);
options(timeout=1200); # set timeout to twice default level to avoid abort due to high traffic


vahydro.dat <- vahydro_import_data_cfs(riv.seg = 'JU3_7400_7510', run.id = 100, site = site, token = token)

plot(vahydro.dat$flow ~ vahydro.dat$date, type = 'l')
quantile(vahydro.dat$flow)
mean(vahydro.dat$flow)

gage.dat <- gage_import_data_cfs('02018000', '1984-01-01', '2005-12-31')

lines(gage.dat$flow ~ gage.dat$date, type = 'l', col = 'red')
quantile(gage.dat$flow)
mean(gage.dat$flow)

lines(vahydro.dat$flow ~ vahydro.dat$date, type = 'l')

trim.gage.dat <- water_year_trim(gage.dat)
trim.vahydro.dat  <- water_year_trim(vahydro.dat)

gage.mets <- metrics_calc_all(trim.gage.dat)
vahydro.mets <- metrics_calc_all(trim.vahydro.dat)

all.metrics <- metrics_compare(gage.mets, vahydro.mets, riv.seg = 'JU3_7400_7510')
rownames(all.metrics) <- c('gage 02018000', 'va hydro seg JU3_7400_7510', 'pct difference')

write.csv(all.metrics, file = 'C:/Users/danie/Documents/HARP/vahydro.metrics.csv')
