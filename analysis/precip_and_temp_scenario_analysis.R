data.location <- 'C:\\Users\\danie\\Documents\\HARP\\GitHub\\cbp6\\Data\\CBP6_Temp_Prcp_Data'
land.seg <- 'H24021'

# LOADING DATA -----
land.seg.info <- read.csv(paste0(data.location, '\\Land_Segment_CBWatershed_Area.csv'))

mod.names <- c('access1-0.1', 'bcc-csm1-1.1', 'bcc-csm1-1-m.1', 'canesm2.1',
               'ccsm4.1', 'cesm1-bgc.1', 'cesm1-cam5.1', 'cmcc-cm.1',
               'cnrm-cm5.1', 'csiro-mk3-6-0.1', 'ec-earth.8', 'fgoals-g2.1',
               'fio-esm.1', 'gfdl-cm3.1', 'gfdl-esm2g.1', 'gfdl-esm2m.1',
               'giss-e2-r.1', 'hadgem2-ao.1', 'hadgem2-cc.1', 'hadgem2-es.1',
               'inmcm4.1', 'ipsl-cm5a-lr.1', 'ipsl-cm5a-mr.1', 'ipsl-cm5b-lr.1',
               'miroc5.1', 'miroc-esm.1', 'miroc-esm-chem.1', 'mpi-esm-lr.1',
               'mpi-esm-mr.1', 'mri-cgcm3.1', 'noresm1-m.1')

PRCP.ENS.10.PCT <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_Ensemble_CRT_2041_2070_P10.csv'))
PRCP.ENS.50.PCT <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_Ensemble_CRT_2041_2070_P50.csv'))
PRCP.ENS.90.PCT <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_Ensemble_CRT_2041_2070_P90.csv'))

prcp.ens.mod.1 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_access1-0.1_2041_2070.csv'))
prcp.ens.mod.2 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_bcc-csm1-1.1_2041_2070.csv'))
prcp.ens.mod.3 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_bcc-csm1-1-m.1_2041_2070.csv'))
prcp.ens.mod.4 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_canesm2.1_2041_2070.csv'))
prcp.ens.mod.5 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_ccsm4.1_2041_2070.csv'))
prcp.ens.mod.6 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_cesm1-bgc.1_2041_2070.csv'))
prcp.ens.mod.7 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_cesm1-cam5.1_2041_2070.csv'))
prcp.ens.mod.8 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_cmcc-cm.1_2041_2070.csv'))
prcp.ens.mod.9 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_cnrm-cm5.1_2041_2070.csv'))
prcp.ens.mod.10 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_csiro-mk3-6-0.1_2041_2070.csv'))
prcp.ens.mod.11 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_ec-earth.8_2041_2070.csv'))
prcp.ens.mod.12 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_fgoals-g2.1_2041_2070.csv'))
prcp.ens.mod.13 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_fio-esm.1_2041_2070.csv'))
prcp.ens.mod.14 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_gfdl-cm3.1_2041_2070.csv'))
prcp.ens.mod.15 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_gfdl-esm2g.1_2041_2070.csv'))
prcp.ens.mod.16 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_gfdl-esm2m.1_2041_2070.csv'))
prcp.ens.mod.17 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_giss-e2-r.1_2041_2070.csv'))
prcp.ens.mod.18 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_hadgem2-ao.1_2041_2070.csv'))
prcp.ens.mod.19 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_hadgem2-cc.1_2041_2070.csv'))
prcp.ens.mod.20 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_hadgem2-es.1_2041_2070.csv'))
prcp.ens.mod.21 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_inmcm4.1_2041_2070.csv'))
prcp.ens.mod.22 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_ipsl-cm5a-lr.1_2041_2070.csv'))
prcp.ens.mod.23 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_ipsl-cm5a-mr.1_2041_2070.csv'))
prcp.ens.mod.24 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_ipsl-cm5b-lr.1_2041_2070.csv'))
prcp.ens.mod.25 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_miroc5.1_2041_2070.csv'))
prcp.ens.mod.26 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_miroc-esm.1_2041_2070.csv'))
prcp.ens.mod.27 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_miroc-esm-chem.1_2041_2070.csv'))
prcp.ens.mod.28 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_mpi-esm-lr.1_2041_2070.csv'))
prcp.ens.mod.29 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_mpi-esm-mr.1_2041_2070.csv'))
prcp.ens.mod.30 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_mri-cgcm3.1_2041_2070.csv'))
prcp.ens.mod.31 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_noresm1-m.1_2041_2070.csv'))

TEMP.ENS.10.PCT <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_Ensemble_CRT_2041_2070_P10.csv'))
TEMP.ENS.50.PCT <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_Ensemble_CRT_2041_2070_P50.csv'))
TEMP.ENS.90.PCT <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_Ensemble_CRT_2041_2070_P90.csv'))

temp.ens.mod.1 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_access1-0.1_2041_2070.csv'))
temp.ens.mod.2 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_bcc-csm1-1.1_2041_2070.csv'))
temp.ens.mod.3 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_bcc-csm1-1-m.1_2041_2070.csv'))
temp.ens.mod.4 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_canesm2.1_2041_2070.csv'))
temp.ens.mod.5 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_ccsm4.1_2041_2070.csv'))
temp.ens.mod.6 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_cesm1-bgc.1_2041_2070.csv'))
temp.ens.mod.7 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_cesm1-cam5.1_2041_2070.csv'))
temp.ens.mod.8 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_cmcc-cm.1_2041_2070.csv'))
temp.ens.mod.9 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_cnrm-cm5.1_2041_2070.csv'))
temp.ens.mod.10 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_csiro-mk3-6-0.1_2041_2070.csv'))
temp.ens.mod.11 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_ec-earth.8_2041_2070.csv'))
temp.ens.mod.12 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_fgoals-g2.1_2041_2070.csv'))
temp.ens.mod.13 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_fio-esm.1_2041_2070.csv'))
temp.ens.mod.14 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_gfdl-cm3.1_2041_2070.csv'))
temp.ens.mod.15 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_gfdl-esm2g.1_2041_2070.csv'))
temp.ens.mod.16 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_gfdl-esm2m.1_2041_2070.csv'))
temp.ens.mod.17 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_giss-e2-r.1_2041_2070.csv'))
temp.ens.mod.18 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_hadgem2-ao.1_2041_2070.csv'))
temp.ens.mod.19 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_hadgem2-cc.1_2041_2070.csv'))
temp.ens.mod.20 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_hadgem2-es.1_2041_2070.csv'))
temp.ens.mod.21 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_inmcm4.1_2041_2070.csv'))
temp.ens.mod.22 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_ipsl-cm5a-lr.1_2041_2070.csv'))
temp.ens.mod.23 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_ipsl-cm5a-mr.1_2041_2070.csv'))
temp.ens.mod.24 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_ipsl-cm5b-lr.1_2041_2070.csv'))
temp.ens.mod.25 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_miroc5.1_2041_2070.csv'))
temp.ens.mod.26 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_miroc-esm.1_2041_2070.csv'))
temp.ens.mod.27 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_miroc-esm-chem.1_2041_2070.csv'))
temp.ens.mod.28 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_mpi-esm-lr.1_2041_2070.csv'))
temp.ens.mod.29 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_mpi-esm-mr.1_2041_2070.csv'))
temp.ens.mod.30 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_mri-cgcm3.1_2041_2070.csv'))
temp.ens.mod.31 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_noresm1-m.1_2041_2070.csv'))

landseg.ens.prcp.data <- data.frame(matrix(NA, nrow = 31, ncol = 15))
landseg.ens.temp.data <- data.frame(matrix(NA, nrow = 31, ncol = 15))

colnames(landseg.ens.prcp.data) <- colnames(PRCP.ENS.50.PCT)
colnames(landseg.ens.temp.data) <- colnames(TEMP.ENS.50.PCT)

for (i in 1:31) {
  tmp.prcp.namer <- paste0('prcp.ens.mod.', i)
  tmp.temp.namer <- paste0('temp.ens.mod.', i)
  
  tmp.prcp.data <- get(tmp.prcp.namer)
  tmp.temp.data <- get(tmp.temp.namer)
  
  tmp.prcp.landseg.ens.data <- tmp.prcp.data[which(tmp.prcp.data$FIPS_NHL == land.seg),]
  tmp.temp.landseg.ens.data <- tmp.temp.data[which(tmp.temp.data$FIPS_NHL == land.seg),]
  
  landseg.ens.prcp.data[i,] <- tmp.prcp.landseg.ens.data[]
  landseg.ens.temp.data[i,] <- tmp.temp.landseg.ens.data[]
}

landseg.quant.precip.data <- data.frame(matrix(NA, nrow = 3, ncol = 15))
colnames(landseg.quant.precip.data) <- colnames(PRCP.ENS.50.PCT)
landseg.quant.precip.data[1,] <- PRCP.ENS.10.PCT[which(PRCP.ENS.10.PCT$FIPS_NHL == land.seg),]
landseg.quant.precip.data[2,] <- PRCP.ENS.50.PCT[which(PRCP.ENS.50.PCT$FIPS_NHL == land.seg),]
landseg.quant.precip.data[3,] <- PRCP.ENS.90.PCT[which(PRCP.ENS.90.PCT$FIPS_NHL == land.seg),]

landseg.quant.temp.data <- data.frame(matrix(NA, nrow = 3, ncol = 15))
colnames(landseg.quant.temp.data) <- colnames(TEMP.ENS.50.PCT)
landseg.quant.temp.data[1,] <- TEMP.ENS.10.PCT[which(TEMP.ENS.10.PCT$FIPS_NHL == land.seg),]
landseg.quant.temp.data[2,] <- TEMP.ENS.50.PCT[which(TEMP.ENS.50.PCT$FIPS_NHL == land.seg),]
landseg.quant.temp.data[3,] <- TEMP.ENS.90.PCT[which(TEMP.ENS.90.PCT$FIPS_NHL == land.seg),]

# PRINTING OUTPUTS
print(paste('Precipitation quantiles of the 31-member forecast for land segment', land.seg, 'are:'))
quantile(landseg.ens.prcp.data$Total, c(.10, .50, .90))

print(paste('The total average precipitation for scenarios p10, p50, and p90 are:'))
landseg.quant.precip.data$Total

print(paste('Temperature quantiles of the 31-member forecast for land segment', land.seg, 'are:'))
quantile(landseg.ens.temp.data$Total, c(.10, .50, .90))

print(paste('The total average temperature for scenarios p10, p50, and p90 are:'))
landseg.quant.temp.data$Total

# TOTAL PRECIP/TEMPERATURE FOR SCENARIOS ARE THE SAME AS THE QUANTILES OF 31 MODELS OF THE TOTAL FOR THAT 
# LAND SEGMENT

# Linking model quantile outputs to their respective models
prcp.10.mod.num <- as.numeric(which(landseg.ens.prcp.data$Total == quantile(landseg.ens.prcp.data$Total, 0.10)))
prcp.50.mod.num <- as.numeric(which(landseg.ens.prcp.data$Total == quantile(landseg.ens.prcp.data$Total, 0.50)))
prcp.90.mod.num <- as.numeric(which(landseg.ens.prcp.data$Total == quantile(landseg.ens.prcp.data$Total, 0.90)))

temp.10.mod.num <- as.numeric(which(landseg.ens.temp.data$Total == quantile(landseg.ens.temp.data$Total, 0.10)))
temp.50.mod.num <- as.numeric(which(landseg.ens.temp.data$Total == quantile(landseg.ens.temp.data$Total, 0.50)))
temp.90.mod.num <- as.numeric(which(landseg.ens.temp.data$Total == quantile(landseg.ens.temp.data$Total, 0.90)))

# Comparing ensemble model values to Total quantile model values
tmp.prcp.namer <- paste0('prcp.ens.mod.', prcp.10.mod.num)
tmp.prcp.data <- get(tmp.prcp.namer)
tmp.prcp.landseg.ens.data.10 <- tmp.prcp.data[which(tmp.prcp.data$FIPS_NHL == land.seg),]
print(paste('Precipitation 10th pctile ensemble monthly values are:'))
landseg.quant.precip.data[1,3:15]
print(paste('Precipitation monthly values from the model with the 10th pctile Total are:'))
tmp.prcp.landseg.ens.data.10[3:15]

# Monthly values are NOT simply linked to the models 

# PRINTING OUTPUTS FOR JANUARY
print(paste('Precipitation quantiles of the 31-member forecast for land segment', land.seg, 'are:'))
quantile(landseg.ens.prcp.data$Jan, c(.10, .50, .90))

print(paste('The total average precipitation for scenarios p10, p50, and p90 are:'))
landseg.quant.precip.data$Jan

print(paste('Temperature quantiles of the 31-member forecast for land segment', land.seg, 'are:'))
quantile(landseg.ens.prcp.data$Jan, c(.10, .50, .90))

print(paste('The total average temperature for scenarios p10, p50, and p90 are:'))
landseg.quant.precip.data$Jan

# THIS SUGGESTS THAT EACH MONTH's PERCENTILE SCENARIO VALUE IS DETERMINED INDIVIDUALLY AS THAT PERCENTILE
# WITHIN THE 31-MEMBER ENSEMBLE

# check for feb as well
print(paste('Precipitation quantiles of the 31-member forecast for land segment', land.seg, 'are:'))
quantile(landseg.ens.prcp.data$Feb, c(.10, .50, .90))

print(paste('The total average precipitation for scenarios p10, p50, and p90 are:'))
landseg.quant.precip.data$Feb

print(paste('Temperature quantiles of the 31-member forecast for land segment', land.seg, 'are:'))
quantile(landseg.ens.prcp.data$Feb, c(.10, .50, .90))

print(paste('The total average temperature for scenarios p10, p50, and p90 are:'))
landseg.quant.precip.data$Feb

prcp.10.mod.num.1 <- as.numeric(which(landseg.ens.prcp.data$Jan == quantile(landseg.ens.prcp.data$Jan, 0.10)))
prcp.10.mod.num.2 <- as.numeric(which(landseg.ens.prcp.data$Feb == quantile(landseg.ens.prcp.data$Feb, 0.10)))
prcp.10.mod.num.3 <- as.numeric(which(landseg.ens.prcp.data$Mar == quantile(landseg.ens.prcp.data$Mar, 0.10)))
prcp.10.mod.num.4 <- as.numeric(which(landseg.ens.prcp.data$Apr == quantile(landseg.ens.prcp.data$Apr, 0.10)))
prcp.10.mod.num.5 <- as.numeric(which(landseg.ens.prcp.data$May == quantile(landseg.ens.prcp.data$May, 0.10)))
prcp.10.mod.num.6 <- as.numeric(which(landseg.ens.prcp.data$Jun == quantile(landseg.ens.prcp.data$Jun, 0.10)))
prcp.10.mod.num.7 <- as.numeric(which(landseg.ens.prcp.data$Jul == quantile(landseg.ens.prcp.data$Jul, 0.10)))
prcp.10.mod.num.8 <- as.numeric(which(landseg.ens.prcp.data$Aug == quantile(landseg.ens.prcp.data$Aug, 0.10)))
prcp.10.mod.num.9 <- as.numeric(which(landseg.ens.prcp.data$Sep == quantile(landseg.ens.prcp.data$Sep, 0.10)))
prcp.10.mod.num.10 <- as.numeric(which(landseg.ens.prcp.data$Oct == quantile(landseg.ens.prcp.data$Oct, 0.10)))
prcp.10.mod.num.11 <- as.numeric(which(landseg.ens.prcp.data$Nov == quantile(landseg.ens.prcp.data$Nov, 0.10)))
prcp.10.mod.num.12 <- as.numeric(which(landseg.ens.prcp.data$Dec == quantile(landseg.ens.prcp.data$Dec, 0.10)))
prcp.10.mod.num.13 <- as.numeric(which(landseg.ens.prcp.data$Total == quantile(landseg.ens.prcp.data$Total, 0.10)))

mod.names[prcp.10.mod.num.1]
mod.names[prcp.10.mod.num.2]
mod.names[prcp.10.mod.num.3]
mod.names[prcp.10.mod.num.4]
mod.names[prcp.10.mod.num.5]
mod.names[prcp.10.mod.num.6]
mod.names[prcp.10.mod.num.7]
mod.names[prcp.10.mod.num.8]
mod.names[prcp.10.mod.num.9]
mod.names[prcp.10.mod.num.10]
mod.names[prcp.10.mod.num.11]
mod.names[prcp.10.mod.num.12]
mod.names[prcp.10.mod.num.13]

temp.10.mod.num.1 <- as.numeric(which(landseg.ens.temp.data$Jan == quantile(landseg.ens.temp.data$Jan, 0.10)))
temp.10.mod.num.2 <- as.numeric(which(landseg.ens.temp.data$Feb == quantile(landseg.ens.temp.data$Feb, 0.10)))
temp.10.mod.num.3 <- as.numeric(which(landseg.ens.temp.data$Mar == quantile(landseg.ens.temp.data$Mar, 0.10)))
temp.10.mod.num.4 <- as.numeric(which(landseg.ens.temp.data$Apr == quantile(landseg.ens.temp.data$Apr, 0.10)))
temp.10.mod.num.5 <- as.numeric(which(landseg.ens.temp.data$May == quantile(landseg.ens.temp.data$May, 0.10)))
temp.10.mod.num.6 <- as.numeric(which(landseg.ens.temp.data$Jun == quantile(landseg.ens.temp.data$Jun, 0.10)))
temp.10.mod.num.7 <- as.numeric(which(landseg.ens.temp.data$Jul == quantile(landseg.ens.temp.data$Jul, 0.10)))
temp.10.mod.num.8 <- as.numeric(which(landseg.ens.temp.data$Aug == quantile(landseg.ens.temp.data$Aug, 0.10)))
temp.10.mod.num.9 <- as.numeric(which(landseg.ens.temp.data$Sep == quantile(landseg.ens.temp.data$Sep, 0.10)))
temp.10.mod.num.10 <- as.numeric(which(landseg.ens.temp.data$Oct == quantile(landseg.ens.temp.data$Oct, 0.10)))
temp.10.mod.num.11 <- as.numeric(which(landseg.ens.temp.data$Nov == quantile(landseg.ens.temp.data$Nov, 0.10)))
temp.10.mod.num.12 <- as.numeric(which(landseg.ens.temp.data$Dec == quantile(landseg.ens.temp.data$Dec, 0.10)))
temp.10.mod.num.13 <- as.numeric(which(landseg.ens.temp.data$Total == quantile(landseg.ens.temp.data$Total, 0.10)))

mod.names[temp.10.mod.num.1]
mod.names[temp.10.mod.num.2]
mod.names[temp.10.mod.num.3]
mod.names[temp.10.mod.num.4]
mod.names[temp.10.mod.num.5]
mod.names[temp.10.mod.num.6]
mod.names[temp.10.mod.num.7]
mod.names[temp.10.mod.num.8]
mod.names[temp.10.mod.num.9]
mod.names[temp.10.mod.num.10]
mod.names[temp.10.mod.num.11]
mod.names[temp.10.mod.num.12]
mod.names[temp.10.mod.num.13]
