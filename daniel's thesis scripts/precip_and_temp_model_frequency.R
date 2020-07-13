# Calculates the frequency of GCMs appearing in the tenth, fiftieth, and ninetieth percentile of each
# model scenario, by land segment.

basepath <- '/var/www/R'
source(paste(basepath,"config.local.private", sep = "/"))
data.location <- paste0(cbp6_location, '\\Data\\CBP6_Temp_Prcp_Data')

# LOADING DATA -----
land.seg.info <- read.csv(paste0(data.location, '\\Land_Segment_CBWatershed_Area.csv'))
colnames(land.seg.info) <- c('landseg', 'state', 'county', 'area?')
land.seg.info <- land.seg.info[land.seg.info$state == 'VA',]

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

landseg.ens.prcp.data <- data.frame(matrix(NA, nrow = 31, ncol = 15))

colnames(landseg.ens.prcp.data) <- colnames(PRCP.ENS.50.PCT)

model.name.10 <- data.frame(matrix(NA, nrow = length(land.seg.info$landseg), ncol = 2))
colnames(model.name.10) <- c('Land Segment', 'Model')
model.name.10$`Land Segment` <- land.seg.info$landseg

model.name.50 <- data.frame(matrix(NA, nrow = length(land.seg.info$landseg), ncol = 2))
colnames(model.name.50) <- c('Land Segment', 'Model')
model.name.50$`Land Segment` <- land.seg.info$landseg

model.name.90 <- data.frame(matrix(NA, nrow = length(land.seg.info$landseg), ncol = 2))
colnames(model.name.90) <- c('Land Segment', 'Model')
model.name.90$`Land Segment` <- land.seg.info$landseg

for (i2 in 1:length(land.seg.info$landseg)) {
  land.seg <- as.character(land.seg.info$landseg[i2])
  
  for (i in 1:31) {
    tmp.prcp.namer <- paste0('prcp.ens.mod.', i)
    tmp.prcp.data <- get(tmp.prcp.namer)
    tmp.prcp.landseg.ens.data <- tmp.prcp.data[which(tmp.prcp.data$FIPS_NHL == land.seg),]
    landseg.ens.prcp.data[i,] <- tmp.prcp.landseg.ens.data[]
  }
  
  landseg.quant.precip.data <- data.frame(matrix(NA, nrow = 3, ncol = 15))
  colnames(landseg.quant.precip.data) <- colnames(PRCP.ENS.50.PCT)
  landseg.quant.precip.data[1,] <- PRCP.ENS.10.PCT[which(PRCP.ENS.10.PCT$FIPS_NHL == land.seg),]
  landseg.quant.precip.data[2,] <- PRCP.ENS.50.PCT[which(PRCP.ENS.50.PCT$FIPS_NHL == land.seg),]
  landseg.quant.precip.data[3,] <- PRCP.ENS.90.PCT[which(PRCP.ENS.90.PCT$FIPS_NHL == land.seg),]
  
  # Linking model quantile outputs to their respective models
  prcp.10.mod.num <- as.numeric(which(landseg.ens.prcp.data$Total == quantile(landseg.ens.prcp.data$Total, 0.10)))
  prcp.50.mod.num <- as.numeric(which(landseg.ens.prcp.data$Total == quantile(landseg.ens.prcp.data$Total, 0.50)))
  prcp.90.mod.num <- as.numeric(which(landseg.ens.prcp.data$Total == quantile(landseg.ens.prcp.data$Total, 0.90)))
  
  model.name.10$Model[i2] <- mod.names[prcp.10.mod.num]
  model.name.50$Model[i2] <- mod.names[prcp.50.mod.num]
  model.name.90$Model[i2] <- mod.names[prcp.90.mod.num]
}

model.name.10.appearances <- as.data.frame(table(model.name.10$Model))
model.name.50.appearances <- as.data.frame(table(model.name.50$Model))
model.name.90.appearances <- as.data.frame(table(model.name.90$Model))

model.name.10.appearances$Pct <- round(model.name.10.appearances$Freq / sum(model.name.10.appearances$Freq), 3)*100
model.name.50.appearances$Pct <- round(model.name.50.appearances$Freq / sum(model.name.50.appearances$Freq), 3)*100
model.name.90.appearances$Pct <- round(model.name.90.appearances$Freq / sum(model.name.90.appearances$Freq), 3)*100

write.csv(model.name.10, "model.name.10.csv")
write.csv(model.name.10.appearances, "model.name.10.appearances.csv")
