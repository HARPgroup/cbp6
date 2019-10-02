library(pander);
library(httr);
library(hydroTSM);
library(lfstat); #required for metrics_calc_all()

#output_directory <- 'C:/Users/danie/Documents/HARP/'
output_directory <- 'C:/Users/nrf46657/Desktop/VAHydro Development/GitHub/OUTPUTS/'

# Load Libraries
#hydro_tools <- 'C:/Users/danie/Documents/HARP/GitHub/hydro-tools';
hydro_tools <- 'C:/Users/nrf46657/Desktop/VAHydro Development/GitHub/hydro-tools';
#cbp6_link <- 'C:/Users/danie/Documents/HARP/GitHub/cbp6';
cbp6_link <- 'C:/Users/nrf46657/Desktop/VAHydro Development/GitHub/cbp6';

site <- "http://deq2.bse.vt.edu/d.dh" 
#----------------------------------------------------------------------------------

source(paste(hydro_tools,"VAHydro-2.0/rest_functions.R", sep = "/")); 
source(paste(hydro_tools,"VAHydro-1.0/fn_vahydro-1.0.R", sep = "/"));  
source(paste(hydro_tools,"LowFlow/fn_iha.R", sep = "/"));
source(paste(cbp6_link, 'code/cbp6_functions.R', sep = "/"))
source(paste(hydro_tools,"auth.private", sep = "/"));#load rest username and password, contained in auth.private file
token <- rest_token(site, token, rest_uname, rest_pw);
options(timeout=1200); # set timeout to twice default level to avoid abort due to high traffic


riv.seg <- 'JU3_7400_7510'

vahydro.dat <- vahydro_import_data_cfs(riv.seg = riv.seg, run.id = 100, site = site, token = token)

png(paste(output_directory ,riv.seg,".png",sep=""), width = 1000, height = 700)
plot(vahydro.dat$flow ~ vahydro.dat$date, type = 'l', log="y", 
     xlim=c(as.Date("1991-01-01"),as.Date("1991-12-31")),
     main= riv.seg,
     xlab="Date", ylab="Flow (cfs)"
     )

quantile(vahydro.dat$flow)
mean(vahydro.dat$flow)


gage.dat <- gage_import_data_cfs('02018000', '1984-01-01', '2005-12-31')

lines(gage.dat$flow ~ gage.dat$date, type = 'l', col = 'red')
quantile(gage.dat$flow)
mean(gage.dat$flow)
lines(vahydro.dat$flow ~ vahydro.dat$date, type = 'l')
dev.off()

trim.gage.dat <- water_year_trim(gage.dat)
trim.vahydro.dat  <- water_year_trim(vahydro.dat)

gage.mets <- metrics_calc_all(trim.gage.dat) #requires lfstat package
vahydro.mets <- metrics_calc_all(trim.vahydro.dat)

all.metrics <- metrics_compare(gage.mets, vahydro.mets, riv.seg = 'JU3_7400_7510')
rownames(all.metrics) <- c('gage 02018000', 'va hydro seg JU3_7400_7510', 'pct difference')


#transpose dataframe 
all.metrics <- t(all.metrics)
write.csv(all.metrics, file = paste(output_directory,'vahydro.metrics.csv',sep=""))
