# Creates pct.changes scenario dataframes.  

va.or.cbw = 'va'

temp_ens_10_pct <- read.csv(
  paste0(
    data.location, 
    '/20121220_CC_Delta/Temperature/lseg_delta_tas_RCP45_Ensemble_CRT_2041_2070_P10.csv'), 
  nrows = 244
)
precp_ens_10_pct <- read.csv(
  paste0(data.location, 
         '/20121220_CC_Delta/Precipitation/lseg_delta_pr_RCP45_Ensemble_CRT_2041_2070_P10.csv'), 
  nrows = 244
)

temp_ens_50_pct <- read.csv(
  paste0(
    data.location, 
    '/20121220_CC_Delta/Temperature/lseg_delta_tas_RCP45_Ensemble_CRT_2041_2070_P50.csv'), 
  nrows = 244
)
precp_ens_50_pct <- read.csv(
  paste0(data.location, 
         '/20121220_CC_Delta/Precipitation/lseg_delta_pr_RCP45_Ensemble_CRT_2041_2070_P50.csv'), 
  nrows = 244
)

temp_ens_90_pct <- read.csv(
  paste0(
    data.location, 
    '/20121220_CC_Delta/Temperature/lseg_delta_tas_RCP45_Ensemble_CRT_2041_2070_P90.csv'), 
  nrows = 244
)
precp_ens_90_pct <- read.csv(
  paste0(data.location, 
         '/20121220_CC_Delta/Precipitation/lseg_delta_pr_RCP45_Ensemble_CRT_2041_2070_P90.csv'), 
  nrows = 244
)

temp_ens_90_pct <- read.csv(
  paste0(
    data.location, 
    '/20121220_CC_Delta/Temperature/lseg_delta_tas_RCP45_Ensemble_CRT_2041_2070_P90.csv'), 
  nrows = 244
)
precp_ens_90_pct <- read.csv(
  paste0(data.location, 
         '/20121220_CC_Delta/Precipitation/lseg_delta_pr_RCP45_Ensemble_CRT_2041_2070_P90.csv'), 
  nrows = 244
)


lseg.loc <- paste0(data.location, '/P6_LSegs_VA')
rseg.loc <- paste0(data.location, '/P6_RSegs_VA')

# CREATING DIRECTORY TO STORE DATA AND OUTPUTS
dir.create('~/Precip_and_Temp_Mapper/Land_Use')
dir.location <- '~/Precip_and_Temp_Mapper/Land_Use'
setwd(dir.location)

dat_climate_base <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/climate/N20150521J96_and_PRC20170731/evap.prcp.table.csv')
dat_climate_base <- dat_climate_base[,-1]
dat_climate_10 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/climate/5545HS10CA2_and_55R45KK1095/evap.prcp.table.csv')
dat_climate_10 <- dat_climate_10[,-1]
dat_climate_50 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/climate/5545HS50CA2_and_5545KK50AA/evap.prcp.table.csv')
dat_climate_50 <- dat_climate_50[,-1]
dat_climate_90 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/climate/5545HS90CA2_and_55R45KK9095/evap.prcp.table.csv')
dat_climate_90 <- dat_climate_90[,-1]

dat_landuse_base <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CFBASE30Y20180615/eos/land.use.table.csv')
dat_landuse_base <- dat_landuse_base[,-1]
dat_landuse_10 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CBASE1808L55CY55R45P10R45P10Y/eos/land.use.table.csv')
dat_landuse_10 <- dat_landuse_10[,-1]
dat_landuse_50 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CBASE1808L55CY55R45P50R45P50Y/eos/land.use.table.csv')
dat_landuse_50 <- dat_landuse_50[,-1]
dat_landuse_90 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CBASE1808L55CY55R45P90R45P90Y/eos/land.use.table.csv')
dat_landuse_90 <- dat_landuse_90[,-1]

library(dplyr)
dat.base <- as.data.frame(inner_join(dat_climate_base, dat_landuse_base, by = 'segment'))
k = 1
dbs <- names(dat.base)
for (i in dbs) {
  if (i == 'for.') {
    dbs[k] <- 'fors' # fix dot not liked by sqldf
  }
  k <- k+1
}
names(dat.base) <- dbs
dat.10 <- as.data.frame(inner_join(dat_climate_10, dat_landuse_10, by = 'segment'))
dat.50 <- as.data.frame(inner_join(dat_climate_50, dat_landuse_50, by = 'segment'))
dat.90 <- as.data.frame(inner_join(dat_climate_90, dat_landuse_90, by = 'segment'))

pct_changes_10 <- as.data.frame(matrix(data = NA, nrow = nrow(dat.base), ncol = ncol(dat.base)))
pct_changes_10[,1] <- dat.base[,1]
colnames(pct_changes_10) <- colnames(dat.base)
pct_changes_10[,2:ncol(pct_changes_10)] <- 100*(dat.10[,2:ncol(pct_changes_10)]-dat.base[,2:ncol(pct_changes_10)])/dat.base[,2:ncol(pct_changes_10)]

pct_changes_50 <- as.data.frame(matrix(data = NA, nrow = nrow(dat.base), ncol = ncol(dat.base)))
pct_changes_50[,1] <- dat.base[,1]
colnames(pct_changes_50) <- colnames(dat.base)
pct_changes_50[,2:ncol(pct_changes_50)] <- 100*(dat.50[,2:ncol(pct_changes_50)]-dat.base[,2:ncol(pct_changes_50)])/dat.base[,2:ncol(pct_changes_50)]

pct_changes_90 <- as.data.frame(matrix(data = NA, nrow = nrow(dat.base), ncol = ncol(dat.base)))
pct_changes_90[,1] <- dat.base[,1]
colnames(pct_changes_90) <- colnames(dat.base)
pct_changes_90[,2:ncol(pct_changes_90)] <- 100*(dat.90[,2:ncol(pct_changes_90)]-dat.base[,2:ncol(pct_changes_90)])/dat.base[,2:ncol(pct_changes_90)]

library(segmented)