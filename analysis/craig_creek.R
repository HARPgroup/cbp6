library(pander);
library(httr);
library(hydroTSM);
#----------------------------------------------
site <- "http://deq2.bse.vt.edu/d.dh"    #Specify the site of interest, either d.bet OR d.dh
#----------------------------------------------
# Load Libraries
hydro_tools <- 'C:/Users/danie/Documents/HARP/GitHub/hydro-tools';
source(paste(hydro_tools,"VAHydro-2.0/rest_functions.R", sep = "/")); 
source(paste(hydro_tools,"VAHydro-1.0/fn_vahydro-1.0.R", sep = "/"));  
source(paste(hydro_tools,"LowFlow/fn_iha.R", sep = "/"));  
#retrieve rest token - DISABLED
#fxn_locations <-  '/usr/local/home/git/r-dh-ecohydro/ELFGEN';
#source(paste(fxn_locations,"elf_rest_token.R", sep = "/"));   
#elf_rest_token (site, token)
# to run in knit'r, need to preload token
#token = 'W-THcwwvstkINd9NIeEMrmNRls-8kVs16mMEcN_-jOA';
source(paste(hydro_tools,"auth.private", sep = "/"));#load rest username and password, contained in auth.private file
token <- rest_token(site, token, rest_uname, rest_pw);
options(timeout=1200); # set timeout to twice default level to avoid abort due to high traffic

hydrocode = "vahydrosw_wshed_JU3_7400_7510";
ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
inputs <- list (
  hydrocode = hydrocode,
  bundle = 'watershed',
  ftype = 'vahydro'
)
#property dataframe returned
feature = FALSE;
odata <- getFeature(inputs, token, site, feature);
# Ex: flows <- fn_get_rundata(207885, 402);
#     fn_iha_7q10(flows);
# Get data frame for stashing multirun data
stash <- data.frame();
mostash <- data.frame();
tsstash = FALSE;
featureid <- odata[1,"hydroid"];
fname <- as.character(odata[1,]$name );
inputs <- list(
  varkey = "wshed_local_area_sqmi",
  featureid = featureid,
  entity_type = "dh_feature"
)
da <- getProperty(inputs, site, model)

inputs <- list(
  varkey = "om_model_element",
  featureid = featureid,
  entity_type = "dh_feature",
  propcode = "vahydro-1.0"
)
model <- getProperty(inputs, site, model)
mid = as.numeric(as.character(model[1,]$pid))
inputs <- list(
  varkey = "om_element_connection",
  featureid = mid,
  entity_type = "dh_properties"
)
prop <- getProperty(inputs, site, prop)
# Manual elid

elid = as.numeric(as.character(prop[1,]$propvalue))

# Analsyis config
#runids = c(20021,20023);
#runids = c(20051,20054);

runid = 100


wshed_summary_tbl = data.frame(
  "Run ID" = character(), 
  "Segment Name (D. Area)" = character(), 
  "7Q10/ALF/LF-90" = character(), 
  "WD (mean/max)" = character(), 
  stringsAsFactors = FALSE) ;
#pander(odata);
#pander(odata);

omsite = site <- "http://deq2.bse.vt.edu"
dat <- fn_get_runfile(elid, runid, site = omsite,  cached = FALSE);

plot(as.numeric(dat$Qout) ~ as.Date(as.character(dat$thisdate)), ylim = c(0,200))
points(as.Date(as.character(dat$thisdate)),as.numeric(dat107$Qout), col='blue')
points(as.Date(as.character(dat$thisdate)),as.numeric(dat107$wd_mgd), col='blue')
points(as.Date(as.character(dat$thisdate)),as.numeric(dat$wd_mgd), col='green')

quantile(as.numeric(dat$Qout))
quantile(as.numeric(dat107$Qout))

quantile(as.numeric(dat$wd_cumulative_mgd))


dat107 = dat
