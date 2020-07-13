basepath <- '/var/www/R'
source(paste(basepath,"config.local.private", sep = "/"))
source(paste0(cbp6_location,"/code/cbp6_functions.R"))
source(paste0(github_location, "/auth.private"));
source(paste(cbp6_location, "/code/fn_vahydro-1.0.R", sep = ''))
site <- "http://deq2.bse.vt.edu/d.dh"
token <- rest_token(site, token, rest_uname, rest_pw)

setwd('~/Precip_and_Temp_Mapper/Runit_Qout_data')

jaup.up <- jame.up.up
jami.up <- jame.up.mid

AllSegList <- c('OR5_7980_8200', 'OR2_8020_8130', 'OR2_8070_8120', 'OR4_8120_7890',
                'OR2_8130_7900', 'OR5_8200_8370', 'OR4_8271_8120', 'TU3_8480_8680',
                'TU1_8570_8680', 'TU3_8650_8800', 'TU4_8680_8810', 'TU2_8790_9070',
                'TU4_8800_9290', 'TU4_8810_9000', 'BS4_8540_8441', 'BS3_8580_8440',
                'BS2_8590_8440', 'BS1_8730_8540', 'MN2_8250_8190', 'MN4_8260_8400',
                'MN0_8300_0001', 'MN4_8400_8380', 'MN4_8510_8380', 'MN2_8530_8510',
                'NR6_7820_7960', 'NR1_7880_8050', 'BS3_8350_8330', 'BS4_8440_8441',
                'MN3_7540_7680', 'MN1_7590_7860', 'MN1_7620_7710', 'MN3_7680_7860',
                'MN4_7710_8161', 'MN2_7720_7830', 'MN1_7730_8160', 'MN3_7770_7930',
                'MN4_7810_8080', 'MN2_7830_7950', 'MN3_7860_8080', 'MN3_7930_8010',
                'MN4_7950_7710', 'MN1_7990_8100', 'MN3_8010_7950', 'MN4_8080_8110',
                'MN2_8100_8190', 'MN5_8161_8160', 'MN3_8190_8260', 'MN5_8230_8161',
                'NR6_7960_8050', 'NR1_8030_8051', 'NR6_8050_8051', 'NR6_8051_8000',
                'NR6_8170_7960', 'NR6_8180_8051', 'NR2_8210_8180', 'NR3_8290_8170',
                'NR3_8420_8430', 'NR3_8430_7820', 'NR6_8640_8500', 'NR3_8690_8500',
                'NR5_8700_8640', 'NR3_8740_8500', 'NR5_8760_8640', 'NR1_8820_8760',
                'NR5_8870_8760', 'NR1_8960_8870', 'NR1_9030_9080', 'NR5_9050_8870',
                'NR5_9080_9050', 'NR4_9130_9080', 'NR1_9150_9050', 'NR3_9170_9130',
                'NR3_9190_9170', 'NR3_9240_9130', 'NR2_9250_9170', 'NR3_9310_9240',
                'OD3_8340_8520', 'OD3_8520_8621', 'OD2_8560_8630', 'OD6_8621_8470',
                'OD3_8630_8720', 'OD6_8660_8621', 'OD2_8670_8890', 'OD3_8710_8470',
                'OD3_8720_8900', 'OD5_8770_8780', 'OD5_8780_8660', 'OD2_8830_8710',
                'OD2_8840_9020', 'OD3_8850_8931', 'OD5_8890_8770', 'OD5_8900_8770',
                'OD1_8910_8930', 'OD2_8920_8830', 'OD3_8930_8931', 'OD3_8931_9140',
                'OD5_8940_8780', 'OD4_8990_8900', 'OD3_9020_9110', 'OD4_9110_9140',
                'OD4_9140_8990', 'OD1_9270_9110', 'OR2_7610_7780', 'OR2_7650_8070',
                'OR2_7670_7840', 'OR1_7700_7980', 'OR3_7740_8271', 'OR2_7780_7890',
                'OR2_7840_7970', 'OR5_7890_7970', 'OR2_7900_7740', 'OR5_7910_8410',
                'OR5_7970_8200', 'OR1_8280_8020', 'OR1_8320_8271', 'OR5_8370_8410',
                'OR5_8410_8470', 'OR2_8450_8490', 'OR2_8460_8271', 'OR7_8470_8490',
                'TU2_8860_9000', 'TU3_8880_9230', 'TU2_8950_9040', 'TU2_8970_9280',
                'TU5_9000_9280', 'TU1_9010_9290', 'TU3_9040_9180', 'TU3_9060_9230',
                'TU2_9070_9090', 'TU2_9100_9200', 'TU3_9180_9090', 'TU2_9200_9180',
                'TU1_9220_9200', 'TU3_9230_9260', 'NR2_8600_8700', 'NR6_8500_7820',
                'EL0_4560_4562','EL0_4561_4562','EL0_4562_0001','EL2_4400_4590',
                'EL2_4590_0001','EL2_5110_5270','EL2_5270_0001','PM0_4640_4820',
                'PM1_3120_3400','PM1_3450_3400','PM1_3510_4000','PM1_3710_4040',
                'PM1_4000_4290','PM1_4250_4500','PM1_4430_4200','PM1_4500_4580',
                'PM2_2860_3040','PM2_3400_3340','PM2_4860_4670','PM3_3040_3340',
                'PM3_4660_4620','PM3_4670_4660','PM4_3340_3341','PM4_3341_4040',
                'PM4_4040_4410','PM7_4150_4290','PM7_4200_4410','PM7_4290_4200',
                'PM7_4410_4620','PM7_4580_4820','PM7_4620_4580','PM7_4820_0001',
                'PS0_6150_6160','PS0_6160_6161','PS1_4790_4830','PS1_4830_5080',
                'PS2_5550_5560','PS2_5560_5100','PS2_6420_6360','PS2_6490_6420',
                'PS2_6660_6490','PS2_6730_6660','PS3_5100_5080','PS3_5990_6161',
                'PS3_6161_6280','PS3_6280_6230','PS3_6460_6230','PS4_5080_4380',
                'PS4_5840_5240','PS4_6230_6360','PS4_6360_5840','PS5_4370_4150',
                'PS5_4380_4370','PS5_5200_4380','PS5_5240_5200','PU0_3000_3090',
                'PU0_3601_3602','PU0_3611_3530','PU0_3751_3752','PU0_3871_3690',
                'PU0_5620_5380','PU0_6080_5620','PU1_3030_3440','PU1_3100_3690',
                'PU1_3170_3580','PU1_3580_3780','PU1_3850_4190','PU1_3940_3970',
                'PU1_4190_4300','PU1_4300_4440','PU1_4840_4760',
                'PU1_5380_5050','PU1_5520_5210','PU1_5820_5380','PU2_2790_3290',
                'PU2_2840_3080','PU2_3080_3640','PU2_3090_4050','PU2_3140_3680',
                'PU2_3180_3370','PU2_3370_4020','PU2_3630_3590','PU2_3770_3600',
                'PU2_3900_3750','PU2_4050_4180','PU2_4160_3930','PU2_4220_3900',
                'PU2_4340_3860','PU2_4360_4160','PU2_4720_4750','PU2_4730_4220',
                'PU2_5190_4310','PU2_5700_5210','PU2_6050_5190',
                'PU3_2510_3290','PU3_3290_3390','PU3_3390_3730','PU3_3680_3890',
                'PU3_3860_3610','PU3_4280_3860','PU3_4450_4440','PU3_5210_5050',
                'PU4_3780_3930','PU4_3890_3990','PU4_3970_3890','PU4_3990_3780',
                'PU4_4210_4170','PU4_4310_4210','PU4_4440_3970','PU4_5050_4310',
                'PU5_3930_4170','PU5_4170_4020','PU6_3440_3590','PU6_3530_3440',
                'PU6_3590_3640','PU6_3600_3602','PU6_3602_3730','PU6_3610_3530',
                'PU6_3640_3600','PU6_3690_3610','PU6_3730_3750','PU6_3750_3752',
                'PU6_3752_4080','PU6_3870_3690','PU6_4020_3870','PU6_4080_4180',
                'PU6_4180_4150','JA0_7291_7290','JA2_7290_0001','JA1_7600_7570',
                'JA1_7640_7280','JA2_7410_7470','JA2_7550_7280','JA2_7570_7480',
                'JA4_7280_7340','JA4_7340_7470','JA4_7470_7480','JA5_7480_0001',
                'JB3_6820_7053','JB3_7053_0001','PL1_4460_4780','PL1_4780_0001',
                'JL1_6560_6440','JL1_6760_6910','JL1_6770_6850','JL1_6910_6960',
                'JL1_6940_7200','JL1_7080_7190','JL1_7170_6800','JL1_7190_7250',
                'JL1_7200_7250','JL1_7530_7430','JL2_6240_6520','JL2_6440_6441',
                'JL2_6441_6520','JL2_6850_6890','JL2_7110_7120','JL2_7120_6970',
                'JL2_7240_7350','JL2_7250_7090','JL2_7350_7090','JL3_7020_7100',
                'JL3_7090_7150','JL4_6520_6710','JL4_6710_6740','JL6_6740_7100',
                'JL6_6890_6990','JL6_6960_6970','JL6_6970_6740','JL6_6990_6960',
                'JL6_7150_6890','JL6_7160_7440','JL6_7320_7150','JL6_7430_7320',
                'JL6_7440_7430','JL7_6800_7070','JL7_7030_6800','JL7_7070_0001',
                'JL7_7100_7030','JU1_6290_6590','JU1_6300_6650','JU1_6340_6650',
                'JU1_6590_6600','JU1_6880_7260','JU1_7560_7500','JU1_7630_7490',
                'JU1_7690_7490','JU1_7750_7560','JU2_6410_6640','JU2_6600_6810',
                'JU2_6810_6900','JU2_7140_7330','JU2_7180_7380','JU2_7360_7000',
                'JU2_7450_7360','JU3_6380_6900','JU3_6640_6790','JU3_6650_7300',
                'JU3_6790_7260','JU3_6900_6950','JU3_6950_7330','JU3_7400_7510',
                'JU3_7490_7400','JU4_7000_7300','JU4_7260_7380','JU4_7330_7000',
                'JU4_7380_7160','JU5_7300_7510','JU5_7420_7160','JU5_7500_7420',
                'JU5_7510_7500','PL0_5141_5140','PL1_5370_5470','PL2_4970_5250',
                'PL2_5140_5360','PL2_5470_5360','PL3_5250_0001','PL3_5360_5250',
                'PL0_5010_5130','PL1_5130_0001','PL0_5490_0001','PL0_5540_5490',
                'PL2_5300_5630','PL2_5630_0001','PL0_5730_5690','PL1_5690_0001',
                'PL0_5530_5710','PL0_5710_0001','RU2_5220_5640','RU2_5500_5610',
                'RU2_5810_5610','RU2_5940_6200','RU2_6090_6220','RU2_6200_6170',
                'RU2_6220_6170','RU3_5610_5640','RU3_6170_6040','RU4_5640_6030',
                'RU4_6040_6030','RU5_6030_0001','XU0_4090_4270','XU0_4091_4270',
                'XU0_4130_4070','XU2_4070_4330','XU2_4270_4650','XU2_4330_4480',
                'XU2_4480_4650','XU3_4650_0001','YM1_6370_6620','YM2_6120_6430',
                'YM3_6430_6620','YM4_6620_0001','YP1_6570_6680','YP1_6680_6670',
                'YP2_6390_6330','YP3_6330_6700','YP3_6470_6690','YP3_6670_6720',
                'YP3_6690_6720','YP3_6700_6670','YP4_6720_6750','YP4_6750_0001',
                'YP0_6840_0001','YP0_6860_6840',
                'EL0_5400_0001','EL1_5150_0001',
                'EL1_5430_0001','EL1_5570_0001','EL1_6000_0001','JB0_7051_0001',
                'JB0_7052_0001','JB1_8090_0001','JB2_7800_0001','PL0_4510_0001',
                'PL0_5000_0001','PL0_5070_0001','PL0_5510_0001','PL0_5720_0001',
                'PL0_5750_0001','PL0_5830_0001','PL1_4540_0001','PL1_5230_0001',
                'PL1_5910_0001','RL0_6540_0001','RL1_6180_0001','YL2_6580_0001', 
                'PU1_4760_4451','PU2_4750_4451','PU3_4451_4450','PM1_3711_3710',
                'PM1_4251_4250','PM1_4252_4250')

`%nin%` = Negate(`%in%`)

shen.up = append('PS5_4370_4150', fn_ALL.upstream('PS5_4370_4150', AllSegList))
matt.up = append('YM4_6620_0001', fn_ALL.upstream('YM4_6620_0001', AllSegList))
pamu.up = append('YP4_6750_0001', fn_ALL.upstream('YP4_6750_0001', AllSegList))
rapp.up = append('RU5_6030_0001', fn_ALL.upstream('RU5_6030_0001', AllSegList))
appo.up = append('JA5_7480_0001', fn_ALL.upstream('JA5_7480_0001', AllSegList))
jame.up.up = append('JU5_7420_7160', fn_ALL.upstream('JU5_7420_7160', AllSegList))
jame.up.up2 = append('JU4_7380_7160', fn_ALL.upstream('JU4_7380_7160', AllSegList))
jame.up.up = append(jame.up.up, jame.up.up2)
jame.up.mid = append('JL7_7070_0001', fn_ALL.upstream('JL7_7070_0001', AllSegList))
jame.up.mid = jame.up.mid[which(jame.up.mid %nin% jame.up.up)]

for (i in 1:length(shen.up)) {
  namer <- paste0('qout_', shen.up[i])
  temp <- read.csv(paste0('~/Precip_and_Temp_Mapper/Runit_Qout_data/', namer, '.csv'))
  assign(namer, temp)
}

for (i in 1:length(matt.up)) {
  namer <- paste0('qout_', matt.up[i])
  temp <- read.csv(paste0('~/Precip_and_Temp_Mapper/Runit_Qout_data/', namer, '.csv'))
  assign(namer, temp)
}

for (i in 1:length(pamu.up)) {
  namer <- paste0('qout_', pamu.up[i])
  temp <- read.csv(paste0('~/Precip_and_Temp_Mapper/Runit_Qout_data/', namer, '.csv'))
  assign(namer, temp)
}

for (i in 1:length(rapp.up)) {
  namer <- paste0('qout_', rapp.up[i])
  temp <- read.csv(paste0('~/Precip_and_Temp_Mapper/Runit_Qout_data/', namer, '.csv'))
  assign(namer, temp)
}

for (i in 1:length(appo.up)) {
  namer <- paste0('qout_', appo.up[i])
  temp <- read.csv(paste0('~/Precip_and_Temp_Mapper/Runit_Qout_data/', namer, '.csv'))
  assign(namer, temp)
}

for (i in 1:length(jame.up.up)) {
  namer <- paste0('qout_', jame.up.up[i])
  temp <- read.csv(paste0('~/Precip_and_Temp_Mapper/Runit_Qout_data/', namer, '.csv'))
  assign(namer, temp)
}

for (i in 1:length(jame.up.mid)) {
  namer <- paste0('qout_', jame.up.mid[i])
  temp <- read.csv(paste0('~/Precip_and_Temp_Mapper/Runit_Qout_data/', namer, '.csv'))
  assign(namer, temp)
}

all.segs <- as.character(Reduce(c, list(shen.up, matt.up, pamu.up, rapp.up,
                                        appo.up, jame.up.up, jame.up.mid)))

for (i in 1:length(all.segs)) {
  namer <- paste0("area_", all.segs[i])
  
  # GETTING MODEL DATA FROM VA HYDRO
  hydrocode = paste("vahydrosw_wshed_",all.segs[i],sep="");
  ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
  inputs <- list (
    hydrocode = hydrocode,
    bundle = 'watershed',
    ftype = 'vahydro'
  )
  #property dataframe returned
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);
  hydroid <- odata[1,"hydroid"];
  fname <- as.character(odata[1,]$name );
  print(paste("Retrieved hydroid",hydroid,"for", fname,all.segs[i], sep=' '));
  # Getting the local drainage area feature
  areainfo <- list(
    varkey = "wshed_drainage_area_sqmi",
    featureid = as.integer(as.character(hydroid)),
    entity_type = "dh_feature"
  )
  model.area <- getProperty(areainfo, site, model.area)
  model.area <- model.area$propvalue
  
  assign(namer, model.area)
}

test <- data.frame(matrix(data = NA, nrow = length(all.segs), ncol = 2))

for (i in 1:length(all.segs)) {
  area.namer <- paste0("area_", all.segs[i])
  qout.namer <- paste0("qout_", all.segs[i])
  #runit.namer <- paste0("runit_", all.segs[i])
  qout.namer.weighted <- paste0("qout_", all.segs[i], "_weighted")
  
  temp.area <- get(area.namer)
  temp.data <- get(qout.namer)
  temp.data.qout <- temp.data[,3:6]/temp.area
  
  assign(qout.namer.weighted, temp.data.qout)
  
  #runit.data <- get(runit.namer)
  
  #test[i,1] <- mean(runit.data[,3])
  #test[i,2] <- mean(temp.data.qout[,3])
}

#pct.diff <- (test[,2]-test[,1])/test[,1]*100
mean.shen.11 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.shen.14 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.shen.15 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.shen.16 <- vector(mode = "numeric", length = length(temp$data11.date))

mean.matt.11 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.matt.14 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.matt.15 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.matt.16 <- vector(mode = "numeric", length = length(temp$data11.date))

mean.pamu.11 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.pamu.14 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.pamu.15 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.pamu.16 <- vector(mode = "numeric", length = length(temp$data11.date))

mean.rapp.11 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.rapp.14 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.rapp.15 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.rapp.16 <- vector(mode = "numeric", length = length(temp$data11.date))

mean.jaup.11 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.jaup.14 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.jaup.15 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.jaup.16 <- vector(mode = "numeric", length = length(temp$data11.date))

mean.jami.11 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.jami.14 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.jami.15 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.jami.16 <- vector(mode = "numeric", length = length(temp$data11.date))

mean.appo.11 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.appo.14 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.appo.15 <- vector(mode = "numeric", length = length(temp$data11.date))
mean.appo.16 <- vector(mode = "numeric", length = length(temp$data11.date))

# mean of all qout in basin, then take flow exceedance of this?
for (i in 1:length(temp$data11.date)) {
  mean.shen.11[i] <- mean(as.numeric(list(qout_PS5_4370_4150_weighted$data11.flow[i], qout_PS5_4380_4370_weighted$data11.flow[i], qout_PS4_5080_4380_weighted$data11.flow[i],
                                          qout_PS1_4830_5080_weighted$data11.flow[i], qout_PS1_4790_4830_weighted$data11.flow[i], qout_PS5_5200_4380_weighted$data11.flow[i],
                                          qout_PS5_5240_5200_weighted$data11.flow[i], qout_PS4_5840_5240_weighted$data11.flow[i], qout_PS4_6360_5840_weighted$data11.flow[i],
                                          qout_PS2_6420_6360_weighted$data11.flow[i], qout_PS2_6490_6420_weighted$data11.flow[i], qout_PS2_6660_6490_weighted$data11.flow[i],
                                          qout_PS2_6730_6660_weighted$data11.flow[i], qout_PS3_5100_5080_weighted$data11.flow[i], qout_PS2_5560_5100_weighted$data11.flow[i],
                                          qout_PS2_5550_5560_weighted$data11.flow[i], qout_PS4_6230_6360_weighted$data11.flow[i], qout_PS3_6280_6230_weighted$data11.flow[i],
                                          qout_PS3_6161_6280_weighted$data11.flow[i], qout_PS0_6160_6161_weighted$data11.flow[i], qout_PS0_6150_6160_weighted$data11.flow[i],
                                          qout_PS3_6460_6230_weighted$data11.flow[i], qout_PS3_5990_6161_weighted$data11.flow[i])))
  
  mean.matt.11[i] <- mean(as.numeric(list(qout_YM4_6620_0001_weighted$data11.flow[i], qout_YM1_6370_6620_weighted$data11.flow[i], qout_YM3_6430_6620_weighted$data11.flow[i],
                                          qout_YM2_6120_6430_weighted$data11.flow[i])))
  
  mean.pamu.11[i] <- mean(as.numeric(list(qout_YP4_6750_0001_weighted$data11.flow[i], qout_YP4_6720_6750_weighted$data11.flow[i], qout_YP3_6670_6720_weighted$data11.flow[i],
                                          qout_YP1_6680_6670_weighted$data11.flow[i], qout_YP1_6570_6680_weighted$data11.flow[i], qout_YP3_6690_6720_weighted$data11.flow[i],
                                          qout_YP3_6470_6690_weighted$data11.flow[i], qout_YP3_6700_6670_weighted$data11.flow[i], qout_YP3_6330_6700_weighted$data11.flow[i],
                                          qout_YP2_6390_6330_weighted$data11.flow[i])))
  
  mean.rapp.11[i] <- mean(as.numeric(list(qout_RU5_6030_0001_weighted$data11.flow[i], qout_RU4_5640_6030_weighted$data11.flow[i], qout_RU2_5220_5640_weighted$data11.flow[i],
                                          qout_RU4_6040_6030_weighted$data11.flow[i], qout_RU3_6170_6040_weighted$data11.flow[i], qout_RU2_6200_6170_weighted$data11.flow[i],
                                          qout_RU2_5940_6200_weighted$data11.flow[i], qout_RU3_5610_5640_weighted$data11.flow[i], qout_RU2_5500_5610_weighted$data11.flow[i],
                                          qout_RU2_6220_6170_weighted$data11.flow[i], qout_RU2_6090_6220_weighted$data11.flow[i], qout_RU2_5810_5610_weighted$data11.flow[i])))
  
  mean.jaup.11[i] <- mean(as.numeric(list(qout_JU5_7420_7160_weighted$data11.flow[i], qout_JU5_7500_7420_weighted$data11.flow[i], qout_JU1_7560_7500_weighted$data11.flow[i],
                                          qout_JU1_7750_7560_weighted$data11.flow[i], qout_JU5_7510_7500_weighted$data11.flow[i], qout_JU3_7400_7510_weighted$data11.flow[i],
                                          qout_JU3_7490_7400_weighted$data11.flow[i], qout_JU1_7630_7490_weighted$data11.flow[i], qout_JU5_7300_7510_weighted$data11.flow[i],
                                          qout_JU3_6650_7300_weighted$data11.flow[i], qout_JU1_6300_6650_weighted$data11.flow[i], qout_JU1_7690_7490_weighted$data11.flow[i],
                                          qout_JU4_7000_7300_weighted$data11.flow[i], qout_JU2_7360_7000_weighted$data11.flow[i], qout_JU2_7450_7360_weighted$data11.flow[i],
                                          qout_JU1_6340_6650_weighted$data11.flow[i], qout_JU4_7330_7000_weighted$data11.flow[i], qout_JU2_7140_7330_weighted$data11.flow[i],
                                          qout_JU3_6950_7330_weighted$data11.flow[i], qout_JU3_6900_6950_weighted$data11.flow[i], qout_JU2_6810_6900_weighted$data11.flow[i],
                                          qout_JU2_6600_6810_weighted$data11.flow[i], qout_JU1_6590_6600_weighted$data11.flow[i], qout_JU1_6290_6590_weighted$data11.flow[i],
                                          qout_JU3_6380_6900_weighted$data11.flow[i], qout_JU4_7380_7160_weighted$data11.flow[i], qout_JU2_7180_7380_weighted$data11.flow[i],
                                          qout_JU4_7260_7380_weighted$data11.flow[i], qout_JU1_6880_7260_weighted$data11.flow[i], qout_JU3_6790_7260_weighted$data11.flow[i],
                                          qout_JU3_6640_6790_weighted$data11.flow[i], qout_JU2_6410_6640_weighted$data11.flow[i])))
  
  mean.jami.11[i] <- mean(as.numeric(list(qout_JL7_7070_0001_weighted$data11.flow[i], qout_JL7_6800_7070_weighted$data11.flow[i], qout_JL1_7170_6800_weighted$data11.flow[i],
                                          qout_JL7_7030_6800_weighted$data11.flow[i], qout_JL7_7100_7030_weighted$data11.flow[i], qout_JL3_7020_7100_weighted$data11.flow[i],
                                          qout_JL6_6740_7100_weighted$data11.flow[i], qout_JL4_6710_6740_weighted$data11.flow[i], qout_JL4_6520_6710_weighted$data11.flow[i],
                                          qout_JL2_6240_6520_weighted$data11.flow[i], qout_JL6_6970_6740_weighted$data11.flow[i], qout_JL2_7120_6970_weighted$data11.flow[i],
                                          qout_JL2_7110_7120_weighted$data11.flow[i], qout_JL2_6441_6520_weighted$data11.flow[i], qout_JL2_6440_6441_weighted$data11.flow[i],
                                          qout_JL1_6560_6440_weighted$data11.flow[i], qout_JL6_6960_6970_weighted$data11.flow[i], qout_JL1_6910_6960_weighted$data11.flow[i],
                                          qout_JL1_6760_6910_weighted$data11.flow[i], qout_JL6_6990_6960_weighted$data11.flow[i], qout_JL6_6890_6990_weighted$data11.flow[i],
                                          qout_JL2_6850_6890_weighted$data11.flow[i], qout_JL1_6770_6850_weighted$data11.flow[i], qout_JL6_7150_6890_weighted$data11.flow[i],
                                          qout_JL3_7090_7150_weighted$data11.flow[i], qout_JL2_7250_7090_weighted$data11.flow[i], qout_JL1_7190_7250_weighted$data11.flow[i],
                                          qout_JL1_7080_7190_weighted$data11.flow[i], qout_JL6_7320_7150_weighted$data11.flow[i], qout_JL6_7430_7320_weighted$data11.flow[i],
                                          qout_JL1_7530_7430_weighted$data11.flow[i], qout_JL2_7350_7090_weighted$data11.flow[i], qout_JL2_7240_7350_weighted$data11.flow[i],
                                          qout_JL1_7200_7250_weighted$data11.flow[i], qout_JL1_6940_7200_weighted$data11.flow[i], qout_JL6_7440_7430_weighted$data11.flow[i],
                                          qout_JL6_7160_7440_weighted$data11.flow[i])))
  
  mean.appo.11[i] <- mean(as.numeric(list(qout_JA5_7480_0001_weighted$data11.flow[i], qout_JA2_7570_7480_weighted$data11.flow[i], qout_JA1_7600_7570_weighted$data11.flow[i],
                                          qout_JA4_7470_7480_weighted$data11.flow[i], qout_JA2_7410_7470_weighted$data11.flow[i], qout_JA4_7340_7470_weighted$data11.flow[i],
                                          qout_JA4_7280_7340_weighted$data11.flow[i], qout_JA1_7640_7280_weighted$data11.flow[i], qout_JA2_7550_7280_weighted$data11.flow[i])))
  
  mean.shen.14[i] <- mean(as.numeric(list(qout_PS5_4370_4150_weighted$data14.flow[i], qout_PS5_4380_4370_weighted$data14.flow[i], qout_PS4_5080_4380_weighted$data14.flow[i],
                                          qout_PS1_4830_5080_weighted$data14.flow[i], qout_PS1_4790_4830_weighted$data14.flow[i], qout_PS5_5200_4380_weighted$data14.flow[i],
                                          qout_PS5_5240_5200_weighted$data14.flow[i], qout_PS4_5840_5240_weighted$data14.flow[i], qout_PS4_6360_5840_weighted$data14.flow[i],
                                          qout_PS2_6420_6360_weighted$data14.flow[i], qout_PS2_6490_6420_weighted$data14.flow[i], qout_PS2_6660_6490_weighted$data14.flow[i],
                                          qout_PS2_6730_6660_weighted$data14.flow[i], qout_PS3_5100_5080_weighted$data14.flow[i], qout_PS2_5560_5100_weighted$data14.flow[i],
                                          qout_PS2_5550_5560_weighted$data14.flow[i], qout_PS4_6230_6360_weighted$data14.flow[i], qout_PS3_6280_6230_weighted$data14.flow[i],
                                          qout_PS3_6161_6280_weighted$data14.flow[i], qout_PS0_6160_6161_weighted$data14.flow[i], qout_PS0_6150_6160_weighted$data14.flow[i],
                                          qout_PS3_6460_6230_weighted$data14.flow[i], qout_PS3_5990_6161_weighted$data14.flow[i])))
  
  mean.matt.14[i] <- mean(as.numeric(list(qout_YM4_6620_0001_weighted$data14.flow[i], qout_YM1_6370_6620_weighted$data14.flow[i], qout_YM3_6430_6620_weighted$data14.flow[i],
                                          qout_YM2_6120_6430_weighted$data14.flow[i])))
  
  mean.pamu.14[i] <- mean(as.numeric(list(qout_YP4_6750_0001_weighted$data14.flow[i], qout_YP4_6720_6750_weighted$data14.flow[i], qout_YP3_6670_6720_weighted$data14.flow[i],
                                          qout_YP1_6680_6670_weighted$data14.flow[i], qout_YP1_6570_6680_weighted$data14.flow[i], qout_YP3_6690_6720_weighted$data14.flow[i],
                                          qout_YP3_6470_6690_weighted$data14.flow[i], qout_YP3_6700_6670_weighted$data14.flow[i], qout_YP3_6330_6700_weighted$data14.flow[i],
                                          qout_YP2_6390_6330_weighted$data14.flow[i])))
  
  mean.rapp.14[i] <- mean(as.numeric(list(qout_RU5_6030_0001_weighted$data14.flow[i], qout_RU4_5640_6030_weighted$data14.flow[i], qout_RU2_5220_5640_weighted$data14.flow[i],
                                          qout_RU4_6040_6030_weighted$data14.flow[i], qout_RU3_6170_6040_weighted$data14.flow[i], qout_RU2_6200_6170_weighted$data14.flow[i],
                                          qout_RU2_5940_6200_weighted$data14.flow[i], qout_RU3_5610_5640_weighted$data14.flow[i], qout_RU2_5500_5610_weighted$data14.flow[i],
                                          qout_RU2_6220_6170_weighted$data14.flow[i], qout_RU2_6090_6220_weighted$data14.flow[i], qout_RU2_5810_5610_weighted$data14.flow[i])))
  
  mean.jaup.14[i] <- mean(as.numeric(list(qout_JU5_7420_7160_weighted$data14.flow[i], qout_JU5_7500_7420_weighted$data14.flow[i], qout_JU1_7560_7500_weighted$data14.flow[i],
                                          qout_JU1_7750_7560_weighted$data14.flow[i], qout_JU5_7510_7500_weighted$data14.flow[i], qout_JU3_7400_7510_weighted$data14.flow[i],
                                          qout_JU3_7490_7400_weighted$data14.flow[i], qout_JU1_7630_7490_weighted$data14.flow[i], qout_JU5_7300_7510_weighted$data14.flow[i],
                                          qout_JU3_6650_7300_weighted$data14.flow[i], qout_JU1_6300_6650_weighted$data14.flow[i], qout_JU1_7690_7490_weighted$data14.flow[i],
                                          qout_JU4_7000_7300_weighted$data14.flow[i], qout_JU2_7360_7000_weighted$data14.flow[i], qout_JU2_7450_7360_weighted$data14.flow[i],
                                          qout_JU1_6340_6650_weighted$data14.flow[i], qout_JU4_7330_7000_weighted$data14.flow[i], qout_JU2_7140_7330_weighted$data14.flow[i],
                                          qout_JU3_6950_7330_weighted$data14.flow[i], qout_JU3_6900_6950_weighted$data14.flow[i], qout_JU2_6810_6900_weighted$data14.flow[i],
                                          qout_JU2_6600_6810_weighted$data14.flow[i], qout_JU1_6590_6600_weighted$data14.flow[i], qout_JU1_6290_6590_weighted$data14.flow[i],
                                          qout_JU3_6380_6900_weighted$data14.flow[i], qout_JU4_7380_7160_weighted$data14.flow[i], qout_JU2_7180_7380_weighted$data14.flow[i],
                                          qout_JU4_7260_7380_weighted$data14.flow[i], qout_JU1_6880_7260_weighted$data14.flow[i], qout_JU3_6790_7260_weighted$data14.flow[i],
                                          qout_JU3_6640_6790_weighted$data14.flow[i], qout_JU2_6410_6640_weighted$data14.flow[i])))
  
  mean.jami.14[i] <- mean(as.numeric(list(qout_JL7_7070_0001_weighted$data14.flow[i], qout_JL7_6800_7070_weighted$data14.flow[i], qout_JL1_7170_6800_weighted$data14.flow[i],
                                          qout_JL7_7030_6800_weighted$data14.flow[i], qout_JL7_7100_7030_weighted$data14.flow[i], qout_JL3_7020_7100_weighted$data14.flow[i],
                                          qout_JL6_6740_7100_weighted$data14.flow[i], qout_JL4_6710_6740_weighted$data14.flow[i], qout_JL4_6520_6710_weighted$data14.flow[i],
                                          qout_JL2_6240_6520_weighted$data14.flow[i], qout_JL6_6970_6740_weighted$data14.flow[i], qout_JL2_7120_6970_weighted$data14.flow[i],
                                          qout_JL2_7110_7120_weighted$data14.flow[i], qout_JL2_6441_6520_weighted$data14.flow[i], qout_JL2_6440_6441_weighted$data14.flow[i],
                                          qout_JL1_6560_6440_weighted$data14.flow[i], qout_JL6_6960_6970_weighted$data14.flow[i], qout_JL1_6910_6960_weighted$data14.flow[i],
                                          qout_JL1_6760_6910_weighted$data14.flow[i], qout_JL6_6990_6960_weighted$data14.flow[i], qout_JL6_6890_6990_weighted$data14.flow[i],
                                          qout_JL2_6850_6890_weighted$data14.flow[i], qout_JL1_6770_6850_weighted$data14.flow[i], qout_JL6_7150_6890_weighted$data14.flow[i],
                                          qout_JL3_7090_7150_weighted$data14.flow[i], qout_JL2_7250_7090_weighted$data14.flow[i], qout_JL1_7190_7250_weighted$data14.flow[i],
                                          qout_JL1_7080_7190_weighted$data14.flow[i], qout_JL6_7320_7150_weighted$data14.flow[i], qout_JL6_7430_7320_weighted$data14.flow[i],
                                          qout_JL1_7530_7430_weighted$data14.flow[i], qout_JL2_7350_7090_weighted$data14.flow[i], qout_JL2_7240_7350_weighted$data14.flow[i],
                                          qout_JL1_7200_7250_weighted$data14.flow[i], qout_JL1_6940_7200_weighted$data14.flow[i], qout_JL6_7440_7430_weighted$data14.flow[i],
                                          qout_JL6_7160_7440_weighted$data14.flow[i])))
  
  mean.appo.14[i] <- mean(as.numeric(list(qout_JA5_7480_0001_weighted$data14.flow[i], qout_JA2_7570_7480_weighted$data14.flow[i], qout_JA1_7600_7570_weighted$data14.flow[i],
                                          qout_JA4_7470_7480_weighted$data14.flow[i], qout_JA2_7410_7470_weighted$data14.flow[i], qout_JA4_7340_7470_weighted$data14.flow[i],
                                          qout_JA4_7280_7340_weighted$data14.flow[i], qout_JA1_7640_7280_weighted$data14.flow[i], qout_JA2_7550_7280_weighted$data14.flow[i])))
  
  mean.shen.15[i] <- mean(as.numeric(list(qout_PS5_4370_4150_weighted$data15.flow[i], qout_PS5_4380_4370_weighted$data15.flow[i], qout_PS4_5080_4380_weighted$data15.flow[i],
                                          qout_PS1_4830_5080_weighted$data15.flow[i], qout_PS1_4790_4830_weighted$data15.flow[i], qout_PS5_5200_4380_weighted$data15.flow[i],
                                          qout_PS5_5240_5200_weighted$data15.flow[i], qout_PS4_5840_5240_weighted$data15.flow[i], qout_PS4_6360_5840_weighted$data15.flow[i],
                                          qout_PS2_6420_6360_weighted$data15.flow[i], qout_PS2_6490_6420_weighted$data15.flow[i], qout_PS2_6660_6490_weighted$data15.flow[i],
                                          qout_PS2_6730_6660_weighted$data15.flow[i], qout_PS3_5100_5080_weighted$data15.flow[i], qout_PS2_5560_5100_weighted$data15.flow[i],
                                          qout_PS2_5550_5560_weighted$data15.flow[i], qout_PS4_6230_6360_weighted$data15.flow[i], qout_PS3_6280_6230_weighted$data15.flow[i],
                                          qout_PS3_6161_6280_weighted$data15.flow[i], qout_PS0_6160_6161_weighted$data15.flow[i], qout_PS0_6150_6160_weighted$data15.flow[i],
                                          qout_PS3_6460_6230_weighted$data15.flow[i], qout_PS3_5990_6161_weighted$data15.flow[i])))
  
  mean.matt.15[i] <- mean(as.numeric(list(qout_YM4_6620_0001_weighted$data15.flow[i], qout_YM1_6370_6620_weighted$data15.flow[i], qout_YM3_6430_6620_weighted$data15.flow[i],
                                          qout_YM2_6120_6430_weighted$data15.flow[i])))
  
  mean.pamu.15[i] <- mean(as.numeric(list(qout_YP4_6750_0001_weighted$data15.flow[i], qout_YP4_6720_6750_weighted$data15.flow[i], qout_YP3_6670_6720_weighted$data15.flow[i],
                                          qout_YP1_6680_6670_weighted$data15.flow[i], qout_YP1_6570_6680_weighted$data15.flow[i], qout_YP3_6690_6720_weighted$data15.flow[i],
                                          qout_YP3_6470_6690_weighted$data15.flow[i], qout_YP3_6700_6670_weighted$data15.flow[i], qout_YP3_6330_6700_weighted$data15.flow[i],
                                          qout_YP2_6390_6330_weighted$data15.flow[i])))
  
  mean.rapp.15[i] <- mean(as.numeric(list(qout_RU5_6030_0001_weighted$data15.flow[i], qout_RU4_5640_6030_weighted$data15.flow[i], qout_RU2_5220_5640_weighted$data15.flow[i],
                                          qout_RU4_6040_6030_weighted$data15.flow[i], qout_RU3_6170_6040_weighted$data15.flow[i], qout_RU2_6200_6170_weighted$data15.flow[i],
                                          qout_RU2_5940_6200_weighted$data15.flow[i], qout_RU3_5610_5640_weighted$data15.flow[i], qout_RU2_5500_5610_weighted$data15.flow[i],
                                          qout_RU2_6220_6170_weighted$data15.flow[i], qout_RU2_6090_6220_weighted$data15.flow[i], qout_RU2_5810_5610_weighted$data15.flow[i])))
  
  mean.jaup.15[i] <- mean(as.numeric(list(qout_JU5_7420_7160_weighted$data15.flow[i], qout_JU5_7500_7420_weighted$data15.flow[i], qout_JU1_7560_7500_weighted$data15.flow[i],
                                          qout_JU1_7750_7560_weighted$data15.flow[i], qout_JU5_7510_7500_weighted$data15.flow[i], qout_JU3_7400_7510_weighted$data15.flow[i],
                                          qout_JU3_7490_7400_weighted$data15.flow[i], qout_JU1_7630_7490_weighted$data15.flow[i], qout_JU5_7300_7510_weighted$data15.flow[i],
                                          qout_JU3_6650_7300_weighted$data15.flow[i], qout_JU1_6300_6650_weighted$data15.flow[i], qout_JU1_7690_7490_weighted$data15.flow[i],
                                          qout_JU4_7000_7300_weighted$data15.flow[i], qout_JU2_7360_7000_weighted$data15.flow[i], qout_JU2_7450_7360_weighted$data15.flow[i],
                                          qout_JU1_6340_6650_weighted$data15.flow[i], qout_JU4_7330_7000_weighted$data15.flow[i], qout_JU2_7140_7330_weighted$data15.flow[i],
                                          qout_JU3_6950_7330_weighted$data15.flow[i], qout_JU3_6900_6950_weighted$data15.flow[i], qout_JU2_6810_6900_weighted$data15.flow[i],
                                          qout_JU2_6600_6810_weighted$data15.flow[i], qout_JU1_6590_6600_weighted$data15.flow[i], qout_JU1_6290_6590_weighted$data15.flow[i],
                                          qout_JU3_6380_6900_weighted$data15.flow[i], qout_JU4_7380_7160_weighted$data15.flow[i], qout_JU2_7180_7380_weighted$data15.flow[i],
                                          qout_JU4_7260_7380_weighted$data15.flow[i], qout_JU1_6880_7260_weighted$data15.flow[i], qout_JU3_6790_7260_weighted$data15.flow[i],
                                          qout_JU3_6640_6790_weighted$data15.flow[i], qout_JU2_6410_6640_weighted$data15.flow[i])))
  
  mean.jami.15[i] <- mean(as.numeric(list(qout_JL7_7070_0001_weighted$data15.flow[i], qout_JL7_6800_7070_weighted$data15.flow[i], qout_JL1_7170_6800_weighted$data15.flow[i],
                                          qout_JL7_7030_6800_weighted$data15.flow[i], qout_JL7_7100_7030_weighted$data15.flow[i], qout_JL3_7020_7100_weighted$data15.flow[i],
                                          qout_JL6_6740_7100_weighted$data15.flow[i], qout_JL4_6710_6740_weighted$data15.flow[i], qout_JL4_6520_6710_weighted$data15.flow[i],
                                          qout_JL2_6240_6520_weighted$data15.flow[i], qout_JL6_6970_6740_weighted$data15.flow[i], qout_JL2_7120_6970_weighted$data15.flow[i],
                                          qout_JL2_7110_7120_weighted$data15.flow[i], qout_JL2_6441_6520_weighted$data15.flow[i], qout_JL2_6440_6441_weighted$data15.flow[i],
                                          qout_JL1_6560_6440_weighted$data15.flow[i], qout_JL6_6960_6970_weighted$data15.flow[i], qout_JL1_6910_6960_weighted$data15.flow[i],
                                          qout_JL1_6760_6910_weighted$data15.flow[i], qout_JL6_6990_6960_weighted$data15.flow[i], qout_JL6_6890_6990_weighted$data15.flow[i],
                                          qout_JL2_6850_6890_weighted$data15.flow[i], qout_JL1_6770_6850_weighted$data15.flow[i], qout_JL6_7150_6890_weighted$data15.flow[i],
                                          qout_JL3_7090_7150_weighted$data15.flow[i], qout_JL2_7250_7090_weighted$data15.flow[i], qout_JL1_7190_7250_weighted$data15.flow[i],
                                          qout_JL1_7080_7190_weighted$data15.flow[i], qout_JL6_7320_7150_weighted$data15.flow[i], qout_JL6_7430_7320_weighted$data15.flow[i],
                                          qout_JL1_7530_7430_weighted$data15.flow[i], qout_JL2_7350_7090_weighted$data15.flow[i], qout_JL2_7240_7350_weighted$data15.flow[i],
                                          qout_JL1_7200_7250_weighted$data15.flow[i], qout_JL1_6940_7200_weighted$data15.flow[i], qout_JL6_7440_7430_weighted$data15.flow[i],
                                          qout_JL6_7160_7440_weighted$data15.flow[i])))
  
  mean.appo.15[i] <- mean(as.numeric(list(qout_JA5_7480_0001_weighted$data15.flow[i], qout_JA2_7570_7480_weighted$data15.flow[i], qout_JA1_7600_7570_weighted$data15.flow[i],
                                          qout_JA4_7470_7480_weighted$data15.flow[i], qout_JA2_7410_7470_weighted$data15.flow[i], qout_JA4_7340_7470_weighted$data15.flow[i],
                                          qout_JA4_7280_7340_weighted$data15.flow[i], qout_JA1_7640_7280_weighted$data15.flow[i], qout_JA2_7550_7280_weighted$data15.flow[i])))
  
  mean.shen.16[i] <- mean(as.numeric(list(qout_PS5_4370_4150_weighted$data16.flow[i], qout_PS5_4380_4370_weighted$data16.flow[i], qout_PS4_5080_4380_weighted$data16.flow[i],
                                          qout_PS1_4830_5080_weighted$data16.flow[i], qout_PS1_4790_4830_weighted$data16.flow[i], qout_PS5_5200_4380_weighted$data16.flow[i],
                                          qout_PS5_5240_5200_weighted$data16.flow[i], qout_PS4_5840_5240_weighted$data16.flow[i], qout_PS4_6360_5840_weighted$data16.flow[i],
                                          qout_PS2_6420_6360_weighted$data16.flow[i], qout_PS2_6490_6420_weighted$data16.flow[i], qout_PS2_6660_6490_weighted$data16.flow[i],
                                          qout_PS2_6730_6660_weighted$data16.flow[i], qout_PS3_5100_5080_weighted$data16.flow[i], qout_PS2_5560_5100_weighted$data16.flow[i],
                                          qout_PS2_5550_5560_weighted$data16.flow[i], qout_PS4_6230_6360_weighted$data16.flow[i], qout_PS3_6280_6230_weighted$data16.flow[i],
                                          qout_PS3_6161_6280_weighted$data16.flow[i], qout_PS0_6160_6161_weighted$data16.flow[i], qout_PS0_6150_6160_weighted$data16.flow[i],
                                          qout_PS3_6460_6230_weighted$data16.flow[i], qout_PS3_5990_6161_weighted$data16.flow[i])))
  
  mean.matt.16[i] <- mean(as.numeric(list(qout_YM4_6620_0001_weighted$data16.flow[i], qout_YM1_6370_6620_weighted$data16.flow[i], qout_YM3_6430_6620_weighted$data16.flow[i],
                                          qout_YM2_6120_6430_weighted$data16.flow[i])))
  
  mean.pamu.16[i] <- mean(as.numeric(list(qout_YP4_6750_0001_weighted$data16.flow[i], qout_YP4_6720_6750_weighted$data16.flow[i], qout_YP3_6670_6720_weighted$data16.flow[i],
                                          qout_YP1_6680_6670_weighted$data16.flow[i], qout_YP1_6570_6680_weighted$data16.flow[i], qout_YP3_6690_6720_weighted$data16.flow[i],
                                          qout_YP3_6470_6690_weighted$data16.flow[i], qout_YP3_6700_6670_weighted$data16.flow[i], qout_YP3_6330_6700_weighted$data16.flow[i],
                                          qout_YP2_6390_6330_weighted$data16.flow[i])))
  
  mean.rapp.16[i] <- mean(as.numeric(list(qout_RU5_6030_0001_weighted$data16.flow[i], qout_RU4_5640_6030_weighted$data16.flow[i], qout_RU2_5220_5640_weighted$data16.flow[i],
                                          qout_RU4_6040_6030_weighted$data16.flow[i], qout_RU3_6170_6040_weighted$data16.flow[i], qout_RU2_6200_6170_weighted$data16.flow[i],
                                          qout_RU2_5940_6200_weighted$data16.flow[i], qout_RU3_5610_5640_weighted$data16.flow[i], qout_RU2_5500_5610_weighted$data16.flow[i],
                                          qout_RU2_6220_6170_weighted$data16.flow[i], qout_RU2_6090_6220_weighted$data16.flow[i], qout_RU2_5810_5610_weighted$data16.flow[i])))
  
  mean.jaup.16[i] <- mean(as.numeric(list(qout_JU5_7420_7160_weighted$data16.flow[i], qout_JU5_7500_7420_weighted$data16.flow[i], qout_JU1_7560_7500_weighted$data16.flow[i],
                                          qout_JU1_7750_7560_weighted$data16.flow[i], qout_JU5_7510_7500_weighted$data16.flow[i], qout_JU3_7400_7510_weighted$data16.flow[i],
                                          qout_JU3_7490_7400_weighted$data16.flow[i], qout_JU1_7630_7490_weighted$data16.flow[i], qout_JU5_7300_7510_weighted$data16.flow[i],
                                          qout_JU3_6650_7300_weighted$data16.flow[i], qout_JU1_6300_6650_weighted$data16.flow[i], qout_JU1_7690_7490_weighted$data16.flow[i],
                                          qout_JU4_7000_7300_weighted$data16.flow[i], qout_JU2_7360_7000_weighted$data16.flow[i], qout_JU2_7450_7360_weighted$data16.flow[i],
                                          qout_JU1_6340_6650_weighted$data16.flow[i], qout_JU4_7330_7000_weighted$data16.flow[i], qout_JU2_7140_7330_weighted$data16.flow[i],
                                          qout_JU3_6950_7330_weighted$data16.flow[i], qout_JU3_6900_6950_weighted$data16.flow[i], qout_JU2_6810_6900_weighted$data16.flow[i],
                                          qout_JU2_6600_6810_weighted$data16.flow[i], qout_JU1_6590_6600_weighted$data16.flow[i], qout_JU1_6290_6590_weighted$data16.flow[i],
                                          qout_JU3_6380_6900_weighted$data16.flow[i], qout_JU4_7380_7160_weighted$data16.flow[i], qout_JU2_7180_7380_weighted$data16.flow[i],
                                          qout_JU4_7260_7380_weighted$data16.flow[i], qout_JU1_6880_7260_weighted$data16.flow[i], qout_JU3_6790_7260_weighted$data16.flow[i],
                                          qout_JU3_6640_6790_weighted$data16.flow[i], qout_JU2_6410_6640_weighted$data16.flow[i])))
  
  mean.jami.16[i] <- mean(as.numeric(list(qout_JL7_7070_0001_weighted$data16.flow[i], qout_JL7_6800_7070_weighted$data16.flow[i], qout_JL1_7170_6800_weighted$data16.flow[i],
                                          qout_JL7_7030_6800_weighted$data16.flow[i], qout_JL7_7100_7030_weighted$data16.flow[i], qout_JL3_7020_7100_weighted$data16.flow[i],
                                          qout_JL6_6740_7100_weighted$data16.flow[i], qout_JL4_6710_6740_weighted$data16.flow[i], qout_JL4_6520_6710_weighted$data16.flow[i],
                                          qout_JL2_6240_6520_weighted$data16.flow[i], qout_JL6_6970_6740_weighted$data16.flow[i], qout_JL2_7120_6970_weighted$data16.flow[i],
                                          qout_JL2_7110_7120_weighted$data16.flow[i], qout_JL2_6441_6520_weighted$data16.flow[i], qout_JL2_6440_6441_weighted$data16.flow[i],
                                          qout_JL1_6560_6440_weighted$data16.flow[i], qout_JL6_6960_6970_weighted$data16.flow[i], qout_JL1_6910_6960_weighted$data16.flow[i],
                                          qout_JL1_6760_6910_weighted$data16.flow[i], qout_JL6_6990_6960_weighted$data16.flow[i], qout_JL6_6890_6990_weighted$data16.flow[i],
                                          qout_JL2_6850_6890_weighted$data16.flow[i], qout_JL1_6770_6850_weighted$data16.flow[i], qout_JL6_7150_6890_weighted$data16.flow[i],
                                          qout_JL3_7090_7150_weighted$data16.flow[i], qout_JL2_7250_7090_weighted$data16.flow[i], qout_JL1_7190_7250_weighted$data16.flow[i],
                                          qout_JL1_7080_7190_weighted$data16.flow[i], qout_JL6_7320_7150_weighted$data16.flow[i], qout_JL6_7430_7320_weighted$data16.flow[i],
                                          qout_JL1_7530_7430_weighted$data16.flow[i], qout_JL2_7350_7090_weighted$data16.flow[i], qout_JL2_7240_7350_weighted$data16.flow[i],
                                          qout_JL1_7200_7250_weighted$data16.flow[i], qout_JL1_6940_7200_weighted$data16.flow[i], qout_JL6_7440_7430_weighted$data16.flow[i],
                                          qout_JL6_7160_7440_weighted$data16.flow[i])))
  
  mean.appo.16[i] <- mean(as.numeric(list(qout_JA5_7480_0001_weighted$data16.flow[i], qout_JA2_7570_7480_weighted$data16.flow[i], qout_JA1_7600_7570_weighted$data16.flow[i],
                                          qout_JA4_7470_7480_weighted$data16.flow[i], qout_JA2_7410_7470_weighted$data16.flow[i], qout_JA4_7340_7470_weighted$data16.flow[i],
                                          qout_JA4_7280_7340_weighted$data16.flow[i], qout_JA1_7640_7280_weighted$data16.flow[i], qout_JA2_7550_7280_weighted$data16.flow[i])))
}

cn11 <- '1: Base' #labels for the plot
cn15 <- '2: ccP10T10'
cn14 <- '3: ccP50T50'
cn16 <- '4: ccP90T90'

# Determining the "rank" (0-1) of the flow value
num_observations <- as.numeric(length(temp$data11.date))
rank_vec <- as.numeric(c(1:num_observations))

# Calculating exceedance probability
prob_exceedance <- 100*((rank_vec) / (num_observations + 1))

shen.exceed_scenario11 <- sort(mean.shen.11, decreasing = TRUE, na.last = TRUE)
shen.exceed_scenario15 <- sort(mean.shen.15, decreasing = TRUE, na.last = TRUE)
shen.exceed_scenario14 <- sort(mean.shen.14, decreasing = TRUE, na.last = TRUE)
shen.exceed_scenario16 <- sort(mean.shen.16, decreasing = TRUE, na.last = TRUE)

shen.scenario11_exceedance <- quantile(shen.exceed_scenario11, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
shen.scenario15_exceedance <- quantile(shen.exceed_scenario15, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
shen.scenario14_exceedance <- quantile(shen.exceed_scenario14, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
shen.scenario16_exceedance <- quantile(shen.exceed_scenario16, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)

# Determining max flow value for exceedance plot scale
max <- max(c(max(shen.scenario11_exceedance), max(shen.scenario15_exceedance), 
             max(shen.scenario14_exceedance), max(shen.scenario16_exceedance)), na.rm = TRUE)

min <- min(c(min(shen.scenario11_exceedance), min(shen.scenario15_exceedance), 
             min(shen.scenario14_exceedance), min(shen.scenario16_exceedance)),  na.rm = TRUE)

if (max > 10000){
  max <- 100000
}else if (max > 1000){
  max <- 10000
}else if (max > 100){
  max <- 1000
}else if (max > 10){
  max <- 100
}else {
  max <- 10
}

if (min>100){
  min<-100
}else if (min>10){ 
  min<-10
}else{
  min<-0.01
}

if (min==100){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(100, 1000, 10000, 100000), 
                                    limits=c(min,max))
}else if (min==10){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else if (min==0.01){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(0.01, 0.1, 1, 10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else{
  fixtheyscale<- scale_y_continuous(trans = log_trans(), breaks = base_breaks(), 
                                    labels=scaleFUN, limits=c(min,max))
}

df <- data.frame(prob_exceedance, shen.exceed_scenario11,
                 shen.exceed_scenario15, shen.exceed_scenario14, shen.exceed_scenario16); 
colnames(df) <- c('Date', 'Scenario11', 'Scenario15', 'Scenario14', 'Scenario16')

options(scipen=5, width = 1400, height = 950)
myplot <- ggplot(df, aes(x=Date)) + 
  geom_line(aes(y=Scenario11, color=cn11), size=0.8) +
  geom_line(aes(y=Scenario15, color=cn15), size=0.8)+
  geom_line(aes(y=Scenario14, color=cn14), size=0.8)+
  geom_line(aes(y=Scenario16, color=cn16), size=0.8)+
  fixtheyscale+ 
  theme_bw()+ 
  theme(legend.position="top", 
        legend.title=element_blank(),
        legend.box = "horizontal", 
        legend.background = element_rect(fill="white",
                                         size=0.5, linetype="solid", 
                                         colour ="white"),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12, colour="black"),
        axis.title=element_text(size=14, colour="black"),
        axis.line = element_line(colour = "black", 
                                 size = 0.5, linetype = "solid"),
        axis.ticks = element_line(colour="black"),
        panel.grid.major=element_line(colour = "light grey"), 
        panel.grid.minor=element_blank())+
  scale_colour_manual(values=c("black", 'chocolate2', 'green3', 'blueviolet'))+
  guides(colour = guide_legend(override.aes = list(size=5)))+
  labs(x= "Probability of Exceedance (%)", y = "Flow (cfs/sq mi)")
ggsave("shen_flow_exceedance_comp.png", plot = myplot, device = 'png', width = 8, height = 5.5, units = 'in')

matt.exceed_scenario11 <- sort(mean.matt.11, decreasing = TRUE, na.last = TRUE)
matt.exceed_scenario15 <- sort(mean.matt.15, decreasing = TRUE, na.last = TRUE)
matt.exceed_scenario14 <- sort(mean.matt.14, decreasing = TRUE, na.last = TRUE)
matt.exceed_scenario16 <- sort(mean.matt.16, decreasing = TRUE, na.last = TRUE)

matt.scenario11_exceedance <- quantile(matt.exceed_scenario11, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
matt.scenario15_exceedance <- quantile(matt.exceed_scenario15, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
matt.scenario14_exceedance <- quantile(matt.exceed_scenario14, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
matt.scenario16_exceedance <- quantile(matt.exceed_scenario16, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)

# Determining max flow value for exceedance plot scale
max <- max(c(max(matt.scenario11_exceedance), max(matt.scenario15_exceedance), 
             max(matt.scenario14_exceedance), max(matt.scenario16_exceedance)), na.rm = TRUE)

min <- min(c(min(matt.scenario11_exceedance), min(matt.scenario15_exceedance), 
             min(matt.scenario14_exceedance), min(matt.scenario16_exceedance)),  na.rm = TRUE)

if (max > 10000){
  max <- 100000
}else if (max > 1000){
  max <- 10000
}else if (max > 100){
  max <- 1000
}else if (max > 10){
  max <- 100
}else {
  max <- 10
}

if (min>100){
  min<-100
}else if (min>10){ 
  min<-10
}else{
  min<-0.01
}

if (min==100){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(100, 1000, 10000, 100000), 
                                    limits=c(min,max))
}else if (min==10){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else if (min==0.01){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(0.01, 0.1, 1, 10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else{
  fixtheyscale<- scale_y_continuous(trans = log_trans(), breaks = base_breaks(), 
                                    labels=scaleFUN, limits=c(min,max))
}

df <- data.frame(prob_exceedance, matt.exceed_scenario11,
                 matt.exceed_scenario15, matt.exceed_scenario14, matt.exceed_scenario16); 
colnames(df) <- c('Date', 'Scenario11', 'Scenario15', 'Scenario14', 'Scenario16')

options(scipen=5, width = 1400, height = 950)
myplot <- ggplot(df, aes(x=Date)) + 
  geom_line(aes(y=Scenario11, color=cn11), size=0.8) +
  geom_line(aes(y=Scenario15, color=cn15), size=0.8)+
  geom_line(aes(y=Scenario14, color=cn14), size=0.8)+
  geom_line(aes(y=Scenario16, color=cn16), size=0.8)+
  fixtheyscale+ 
  theme_bw()+ 
  theme(legend.position="top", 
        legend.title=element_blank(),
        legend.box = "horizontal", 
        legend.background = element_rect(fill="white",
                                         size=0.5, linetype="solid", 
                                         colour ="white"),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12, colour="black"),
        axis.title=element_text(size=14, colour="black"),
        axis.line = element_line(colour = "black", 
                                 size = 0.5, linetype = "solid"),
        axis.ticks = element_line(colour="black"),
        panel.grid.major=element_line(colour = "light grey"), 
        panel.grid.minor=element_blank())+
  scale_colour_manual(values=c("black", 'chocolate2', 'green3', 'blueviolet'))+
  guides(colour = guide_legend(override.aes = list(size=5)))+
  labs(x= "Probability of Exceedance (%)", y = "Flow (cfs/sq mi)")
ggsave("matt_flow_exceedance_comp.png", plot = myplot, device = 'png', width = 8, height = 5.5, units = 'in')

pamu.exceed_scenario11 <- sort(mean.pamu.11, decreasing = TRUE, na.last = TRUE)
pamu.exceed_scenario15 <- sort(mean.pamu.15, decreasing = TRUE, na.last = TRUE)
pamu.exceed_scenario14 <- sort(mean.pamu.14, decreasing = TRUE, na.last = TRUE)
pamu.exceed_scenario16 <- sort(mean.pamu.16, decreasing = TRUE, na.last = TRUE)

pamu.scenario11_exceedance <- quantile(pamu.exceed_scenario11, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
pamu.scenario15_exceedance <- quantile(pamu.exceed_scenario15, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
pamu.scenario14_exceedance <- quantile(pamu.exceed_scenario14, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
pamu.scenario16_exceedance <- quantile(pamu.exceed_scenario16, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)

# Determining max flow value for exceedance plot scale
max <- max(c(max(pamu.scenario11_exceedance), max(pamu.scenario15_exceedance), 
             max(pamu.scenario14_exceedance), max(pamu.scenario16_exceedance)), na.rm = TRUE)

min <- min(c(min(pamu.scenario11_exceedance), min(pamu.scenario15_exceedance), 
             min(pamu.scenario14_exceedance), min(pamu.scenario16_exceedance)),  na.rm = TRUE)

if (max > 10000){
  max <- 100000
}else if (max > 1000){
  max <- 10000
}else if (max > 100){
  max <- 1000
}else if (max > 10){
  max <- 100
}else {
  max <- 10
}

if (min>100){
  min<-100
}else if (min>10){ 
  min<-10
}else{
  min<-0.01
}

if (min==100){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(100, 1000, 10000, 100000), 
                                    limits=c(min,max))
}else if (min==10){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else if (min==0.01){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(0.01, 0.1, 1, 10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else{
  fixtheyscale<- scale_y_continuous(trans = log_trans(), breaks = base_breaks(), 
                                    labels=scaleFUN, limits=c(min,max))
}

df <- data.frame(prob_exceedance, pamu.exceed_scenario11,
                 pamu.exceed_scenario15, pamu.exceed_scenario14, pamu.exceed_scenario16); 
colnames(df) <- c('Date', 'Scenario11', 'Scenario15', 'Scenario14', 'Scenario16')

options(scipen=5, width = 1400, height = 950)
myplot <- ggplot(df, aes(x=Date)) + 
  geom_line(aes(y=Scenario11, color=cn11), size=0.8) +
  geom_line(aes(y=Scenario15, color=cn15), size=0.8)+
  geom_line(aes(y=Scenario14, color=cn14), size=0.8)+
  geom_line(aes(y=Scenario16, color=cn16), size=0.8)+
  fixtheyscale+ 
  theme_bw()+ 
  theme(legend.position="top", 
        legend.title=element_blank(),
        legend.box = "horizontal", 
        legend.background = element_rect(fill="white",
                                         size=0.5, linetype="solid", 
                                         colour ="white"),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12, colour="black"),
        axis.title=element_text(size=14, colour="black"),
        axis.line = element_line(colour = "black", 
                                 size = 0.5, linetype = "solid"),
        axis.ticks = element_line(colour="black"),
        panel.grid.major=element_line(colour = "light grey"), 
        panel.grid.minor=element_blank())+
  scale_colour_manual(values=c("black", 'chocolate2', 'green3', 'blueviolet'))+
  guides(colour = guide_legend(override.aes = list(size=5)))+
  labs(x= "Probability of Exceedance (%)", y = "Flow (cfs/sq mi)")
ggsave("pamu_flow_exceedance_comp.png", plot = myplot, device = 'png', width = 8, height = 5.5, units = 'in')

rapp.exceed_scenario11 <- sort(mean.rapp.11, decreasing = TRUE, na.last = TRUE)
rapp.exceed_scenario15 <- sort(mean.rapp.15, decreasing = TRUE, na.last = TRUE)
rapp.exceed_scenario14 <- sort(mean.rapp.14, decreasing = TRUE, na.last = TRUE)
rapp.exceed_scenario16 <- sort(mean.rapp.16, decreasing = TRUE, na.last = TRUE)

rapp.scenario11_exceedance <- quantile(rapp.exceed_scenario11, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
rapp.scenario15_exceedance <- quantile(rapp.exceed_scenario15, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
rapp.scenario14_exceedance <- quantile(rapp.exceed_scenario14, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
rapp.scenario16_exceedance <- quantile(rapp.exceed_scenario16, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)

# Determining max flow value for exceedance plot scale
max <- max(c(max(rapp.scenario11_exceedance), max(rapp.scenario15_exceedance), 
             max(rapp.scenario14_exceedance), max(rapp.scenario16_exceedance)), na.rm = TRUE)

min <- min(c(min(rapp.scenario11_exceedance), min(rapp.scenario15_exceedance), 
             min(rapp.scenario14_exceedance), min(rapp.scenario16_exceedance)),  na.rm = TRUE)

if (max > 10000){
  max <- 100000
}else if (max > 1000){
  max <- 10000
}else if (max > 100){
  max <- 1000
}else if (max > 10){
  max <- 100
}else {
  max <- 10
}

if (min>100){
  min<-100
}else if (min>10){ 
  min<-10
}else{
  min<-0.01
}

if (min==100){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(100, 1000, 10000, 100000), 
                                    limits=c(min,max))
}else if (min==10){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else if (min==0.01){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(0.01, 0.1, 1, 10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else{
  fixtheyscale<- scale_y_continuous(trans = log_trans(), breaks = base_breaks(), 
                                    labels=scaleFUN, limits=c(min,max))
}

df <- data.frame(prob_exceedance, rapp.exceed_scenario11,
                 rapp.exceed_scenario15, rapp.exceed_scenario14, rapp.exceed_scenario16); 
colnames(df) <- c('Date', 'Scenario11', 'Scenario15', 'Scenario14', 'Scenario16')

options(scipen=5, width = 1400, height = 950)
myplot <- ggplot(df, aes(x=Date)) + 
  geom_line(aes(y=Scenario11, color=cn11), size=0.8) +
  geom_line(aes(y=Scenario15, color=cn15), size=0.8)+
  geom_line(aes(y=Scenario14, color=cn14), size=0.8)+
  geom_line(aes(y=Scenario16, color=cn16), size=0.8)+
  fixtheyscale+ 
  theme_bw()+ 
  theme(legend.position="top", 
        legend.title=element_blank(),
        legend.box = "horizontal", 
        legend.background = element_rect(fill="white",
                                         size=0.5, linetype="solid", 
                                         colour ="white"),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12, colour="black"),
        axis.title=element_text(size=14, colour="black"),
        axis.line = element_line(colour = "black", 
                                 size = 0.5, linetype = "solid"),
        axis.ticks = element_line(colour="black"),
        panel.grid.major=element_line(colour = "light grey"), 
        panel.grid.minor=element_blank())+
  scale_colour_manual(values=c("black", 'chocolate2', 'green3', 'blueviolet'))+
  guides(colour = guide_legend(override.aes = list(size=5)))+
  labs(x= "Probability of Exceedance (%)", y = "Flow (cfs/sq mi)")
ggsave("rapp_flow_exceedance_comp.png", plot = myplot, device = 'png', width = 8, height = 5.5, units = 'in')

jaup.exceed_scenario11 <- sort(mean.jaup.11, decreasing = TRUE, na.last = TRUE)
jaup.exceed_scenario15 <- sort(mean.jaup.15, decreasing = TRUE, na.last = TRUE)
jaup.exceed_scenario14 <- sort(mean.jaup.14, decreasing = TRUE, na.last = TRUE)
jaup.exceed_scenario16 <- sort(mean.jaup.16, decreasing = TRUE, na.last = TRUE)

jaup.scenario11_exceedance <- quantile(jaup.exceed_scenario11, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
jaup.scenario15_exceedance <- quantile(jaup.exceed_scenario15, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
jaup.scenario14_exceedance <- quantile(jaup.exceed_scenario14, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
jaup.scenario16_exceedance <- quantile(jaup.exceed_scenario16, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)

# Determining max flow value for exceedance plot scale
max <- max(c(max(jaup.scenario11_exceedance), max(jaup.scenario15_exceedance), 
             max(jaup.scenario14_exceedance), max(jaup.scenario16_exceedance)), na.rm = TRUE)

min <- min(c(min(jaup.scenario11_exceedance), min(jaup.scenario15_exceedance), 
             min(jaup.scenario14_exceedance), min(jaup.scenario16_exceedance)),  na.rm = TRUE)

if (max > 10000){
  max <- 100000
}else if (max > 1000){
  max <- 10000
}else if (max > 100){
  max <- 1000
}else if (max > 10){
  max <- 100
}else {
  max <- 10
}

if (min>100){
  min<-100
}else if (min>10){ 
  min<-10
}else{
  min<-0.01
}

if (min==100){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(100, 1000, 10000, 100000), 
                                    limits=c(min,max))
}else if (min==10){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else if (min==0.01){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(0.01, 0.1, 1, 10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else{
  fixtheyscale<- scale_y_continuous(trans = log_trans(), breaks = base_breaks(), 
                                    labels=scaleFUN, limits=c(min,max))
}

df <- data.frame(prob_exceedance, jaup.exceed_scenario11,
                 jaup.exceed_scenario15, jaup.exceed_scenario14, jaup.exceed_scenario16); 
colnames(df) <- c('Date', 'Scenario11', 'Scenario15', 'Scenario14', 'Scenario16')

options(scipen=5, width = 1400, height = 950)
myplot <- ggplot(df, aes(x=Date)) + 
  geom_line(aes(y=Scenario11, color=cn11), size=0.8) +
  geom_line(aes(y=Scenario15, color=cn15), size=0.8)+
  geom_line(aes(y=Scenario14, color=cn14), size=0.8)+
  geom_line(aes(y=Scenario16, color=cn16), size=0.8)+
  fixtheyscale+ 
  theme_bw()+ 
  theme(legend.position="top", 
        legend.title=element_blank(),
        legend.box = "horizontal", 
        legend.background = element_rect(fill="white",
                                         size=0.5, linetype="solid", 
                                         colour ="white"),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12, colour="black"),
        axis.title=element_text(size=14, colour="black"),
        axis.line = element_line(colour = "black", 
                                 size = 0.5, linetype = "solid"),
        axis.ticks = element_line(colour="black"),
        panel.grid.major=element_line(colour = "light grey"), 
        panel.grid.minor=element_blank())+
  scale_colour_manual(values=c("black", 'chocolate2', 'green3', 'blueviolet'))+
  guides(colour = guide_legend(override.aes = list(size=5)))+
  labs(x= "Probability of Exceedance (%)", y = "Flow (cfs/sq mi)")
ggsave("jaup_flow_exceedance_comp.png", plot = myplot, device = 'png', width = 8, height = 5.5, units = 'in')

jami.exceed_scenario11 <- sort(mean.jami.11, decreasing = TRUE, na.last = TRUE)
jami.exceed_scenario15 <- sort(mean.jami.15, decreasing = TRUE, na.last = TRUE)
jami.exceed_scenario14 <- sort(mean.jami.14, decreasing = TRUE, na.last = TRUE)
jami.exceed_scenario16 <- sort(mean.jami.16, decreasing = TRUE, na.last = TRUE)

jami.scenario11_exceedance <- quantile(jami.exceed_scenario11, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
jami.scenario15_exceedance <- quantile(jami.exceed_scenario15, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
jami.scenario14_exceedance <- quantile(jami.exceed_scenario14, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
jami.scenario16_exceedance <- quantile(jami.exceed_scenario16, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)

# Determining max flow value for exceedance plot scale
max <- max(c(max(jami.scenario11_exceedance), max(jami.scenario15_exceedance), 
             max(jami.scenario14_exceedance), max(jami.scenario16_exceedance)), na.rm = TRUE)

min <- min(c(min(jami.scenario11_exceedance), min(jami.scenario15_exceedance), 
             min(jami.scenario14_exceedance), min(jami.scenario16_exceedance)),  na.rm = TRUE)

if (max > 10000){
  max <- 100000
}else if (max > 1000){
  max <- 10000
}else if (max > 100){
  max <- 1000
}else if (max > 10){
  max <- 100
}else {
  max <- 10
}

if (min>100){
  min<-100
}else if (min>10){ 
  min<-10
}else{
  min<-0.01
}

if (min==100){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(100, 1000, 10000, 100000), 
                                    limits=c(min,max))
}else if (min==10){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else if (min==0.01){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(0.01, 0.1, 1, 10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else{
  fixtheyscale<- scale_y_continuous(trans = log_trans(), breaks = base_breaks(), 
                                    labels=scaleFUN, limits=c(min,max))
}

df <- data.frame(prob_exceedance, jami.exceed_scenario11,
                 jami.exceed_scenario15, jami.exceed_scenario14, jami.exceed_scenario16); 
colnames(df) <- c('Date', 'Scenario11', 'Scenario15', 'Scenario14', 'Scenario16')

options(scipen=5, width = 1400, height = 950)
myplot <- ggplot(df, aes(x=Date)) + 
  geom_line(aes(y=Scenario11, color=cn11), size=0.8) +
  geom_line(aes(y=Scenario15, color=cn15), size=0.8)+
  geom_line(aes(y=Scenario14, color=cn14), size=0.8)+
  geom_line(aes(y=Scenario16, color=cn16), size=0.8)+
  fixtheyscale+ 
  theme_bw()+ 
  theme(legend.position="top", 
        legend.title=element_blank(),
        legend.box = "horizontal", 
        legend.background = element_rect(fill="white",
                                         size=0.5, linetype="solid", 
                                         colour ="white"),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12, colour="black"),
        axis.title=element_text(size=14, colour="black"),
        axis.line = element_line(colour = "black", 
                                 size = 0.5, linetype = "solid"),
        axis.ticks = element_line(colour="black"),
        panel.grid.major=element_line(colour = "light grey"), 
        panel.grid.minor=element_blank())+
  scale_colour_manual(values=c("black", 'chocolate2', 'green3', 'blueviolet'))+
  guides(colour = guide_legend(override.aes = list(size=5)))+
  labs(x= "Probability of Exceedance (%)", y = "Flow (cfs/sq mi)")
ggsave("jami_flow_exceedance_comp.png", plot = myplot, device = 'png', width = 8, height = 5.5, units = 'in')

appo.exceed_scenario11 <- sort(mean.appo.11, decreasing = TRUE, na.last = TRUE)
appo.exceed_scenario15 <- sort(mean.appo.15, decreasing = TRUE, na.last = TRUE)
appo.exceed_scenario14 <- sort(mean.appo.14, decreasing = TRUE, na.last = TRUE)
appo.exceed_scenario16 <- sort(mean.appo.16, decreasing = TRUE, na.last = TRUE)

appo.scenario11_exceedance <- quantile(appo.exceed_scenario11, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
appo.scenario15_exceedance <- quantile(appo.exceed_scenario15, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
appo.scenario14_exceedance <- quantile(appo.exceed_scenario14, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
appo.scenario16_exceedance <- quantile(appo.exceed_scenario16, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)

# Determining max flow value for exceedance plot scale
max <- max(c(max(appo.scenario11_exceedance), max(appo.scenario15_exceedance), 
             max(appo.scenario14_exceedance), max(appo.scenario16_exceedance)), na.rm = TRUE)

min <- min(c(min(appo.scenario11_exceedance), min(appo.scenario15_exceedance), 
             min(appo.scenario14_exceedance), min(appo.scenario16_exceedance)),  na.rm = TRUE)

if (max > 10000){
  max <- 100000
}else if (max > 1000){
  max <- 10000
}else if (max > 100){
  max <- 1000
}else if (max > 10){
  max <- 100
}else {
  max <- 10
}

if (min>100){
  min<-100
}else if (min>10){ 
  min<-10
}else{
  min<-0.01
}

if (min==100){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(100, 1000, 10000, 100000), 
                                    limits=c(min,max))
}else if (min==10){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else if (min==0.01){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(0.01, 0.1, 1, 10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else{
  fixtheyscale<- scale_y_continuous(trans = log_trans(), breaks = base_breaks(), 
                                    labels=scaleFUN, limits=c(min,max))
}

df <- data.frame(prob_exceedance, appo.exceed_scenario11,
                 appo.exceed_scenario15, appo.exceed_scenario14, appo.exceed_scenario16); 
colnames(df) <- c('Date', 'Scenario11', 'Scenario15', 'Scenario14', 'Scenario16')

options(scipen=5, width = 1400, height = 950)
myplot <- ggplot(df, aes(x=Date)) + 
  geom_line(aes(y=Scenario11, color=cn11), size=0.8) +
  geom_line(aes(y=Scenario15, color=cn15), size=0.8)+
  geom_line(aes(y=Scenario14, color=cn14), size=0.8)+
  geom_line(aes(y=Scenario16, color=cn16), size=0.8)+
  fixtheyscale+ 
  theme_bw()+ 
  theme(legend.position="top", 
        legend.title=element_blank(),
        legend.box = "horizontal", 
        legend.background = element_rect(fill="white",
                                         size=0.5, linetype="solid", 
                                         colour ="white"),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12, colour="black"),
        axis.title=element_text(size=14, colour="black"),
        axis.line = element_line(colour = "black", 
                                 size = 0.5, linetype = "solid"),
        axis.ticks = element_line(colour="black"),
        panel.grid.major=element_line(colour = "light grey"), 
        panel.grid.minor=element_blank())+
  scale_colour_manual(values=c("black", 'chocolate2', 'green3', 'blueviolet'))+
  guides(colour = guide_legend(override.aes = list(size=5)))+
  labs(x= "Probability of Exceedance (%)", y = "Flow (cfs/sq mi)")
ggsave("appo_flow_exceedance_comp.png", plot = myplot, device = 'png', width = 8, height = 5.5, units = 'in')


# flow exceedance of a few specific segments (the ones discussed in unit runoff section)?
#amherst
amhe.exceed_scenario11 <- sort(qout_JL2_7240_7350$data11.flow, decreasing = TRUE, na.last = TRUE)
amhe.exceed_scenario15 <- sort(qout_JL2_7240_7350$data15.flow, decreasing = TRUE, na.last = TRUE)
amhe.exceed_scenario14 <- sort(qout_JL2_7240_7350$data14.flow, decreasing = TRUE, na.last = TRUE)
amhe.exceed_scenario16 <- sort(qout_JL2_7240_7350$data16.flow, decreasing = TRUE, na.last = TRUE)

amhe.scenario11_exceedance <- quantile(amhe.exceed_scenario11, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
amhe.scenario15_exceedance <- quantile(amhe.exceed_scenario15, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
amhe.scenario14_exceedance <- quantile(amhe.exceed_scenario14, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
amhe.scenario16_exceedance <- quantile(amhe.exceed_scenario16, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)

# Determining max flow value for exceedance plot scale
max <- max(c(max(amhe.scenario11_exceedance), max(amhe.scenario15_exceedance), 
             max(amhe.scenario14_exceedance), max(amhe.scenario16_exceedance)), na.rm = TRUE)

min <- min(c(min(amhe.scenario11_exceedance), min(amhe.scenario15_exceedance), 
             min(amhe.scenario14_exceedance), min(amhe.scenario16_exceedance)),  na.rm = TRUE)

if (max > 10000){
  max <- 100000
}else if (max > 1000){
  max <- 10000
}else if (max > 100){
  max <- 1000
}else if (max > 10){
  max <- 100
}else {
  max <- 10
}

if (min>100){
  min<-100
}else if (min>10){ 
  min<-10
}else{
  min<-1
}

if (min==100){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(100, 1000, 10000, 100000), 
                                    limits=c(min,max))
}else if (min==10){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else if (min==1){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(1, 10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else{
  fixtheyscale<- scale_y_continuous(trans = log_trans(), breaks = base_breaks(), 
                                    labels=scaleFUN, limits=c(min,max))
}

df <- data.frame(prob_exceedance, amhe.exceed_scenario11,
                 amhe.exceed_scenario15, amhe.exceed_scenario14, amhe.exceed_scenario16); 
colnames(df) <- c('Date', 'Scenario11', 'Scenario15', 'Scenario14', 'Scenario16')

options(scipen=5, width = 1400, height = 950)
amhe.myplot <- ggplot(df, aes(x=Date)) + 
  geom_line(aes(y=Scenario11, color=cn11), size=0.8) +
  geom_line(aes(y=Scenario15, color=cn15), size=0.8)+
  fixtheyscale+ 
  theme_bw()+ 
  theme(legend.position="top", 
        legend.title=element_blank(),
        legend.box = "horizontal", 
        legend.background = element_rect(fill="white",
                                         size=0.5, linetype="solid", 
                                         colour ="white"),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12, colour="black"),
        axis.title=element_text(size=14, colour="black"),
        axis.line = element_line(colour = "black", 
                                 size = 0.5, linetype = "solid"),
        axis.ticks = element_line(colour="black"),
        panel.grid.major=element_line(colour = "light grey"), 
        panel.grid.minor=element_blank(),
        plot.title = element_text(hjust = 0.5))+
  scale_colour_manual(values=c("black", 'chocolate2'))+
  guides(colour = guide_legend(override.aes = list(size=5)))+
  labs(x= "Probability of Exceedance (%)", y = "Flow (cfs)")+
  ggtitle('Amherst')
ggsave("amhe_flow_exceedance_comp.png", plot = amhe.myplot, device = 'png', width = 8, height = 5.5, units = 'in')


# harrisonburg
harr.exceed_scenario11 <- sort(qout_PS0_6150_6160$data11.flow, decreasing = TRUE, na.last = TRUE)
harr.exceed_scenario15 <- sort(qout_PS0_6150_6160$data15.flow, decreasing = TRUE, na.last = TRUE)
harr.exceed_scenario14 <- sort(qout_PS0_6150_6160$data14.flow, decreasing = TRUE, na.last = TRUE)
harr.exceed_scenario16 <- sort(qout_PS0_6150_6160$data16.flow, decreasing = TRUE, na.last = TRUE)

harr.scenario11_exceedance <- quantile(harr.exceed_scenario11, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
harr.scenario15_exceedance <- quantile(harr.exceed_scenario15, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
harr.scenario14_exceedance <- quantile(harr.exceed_scenario14, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
harr.scenario16_exceedance <- quantile(harr.exceed_scenario16, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)

# Determining max flow value for exceedance plot scale
max <- max(c(max(harr.scenario11_exceedance), max(harr.scenario15_exceedance), 
             max(harr.scenario14_exceedance), max(harr.scenario16_exceedance)), na.rm = TRUE)

min <- min(c(min(harr.scenario11_exceedance), min(harr.scenario15_exceedance), 
             min(harr.scenario14_exceedance), min(harr.scenario16_exceedance)),  na.rm = TRUE)

if (max > 10000){
  max <- 100000
}else if (max > 1000){
  max <- 10000
}else if (max > 100){
  max <- 1000
}else if (max > 10){
  max <- 100
}else {
  max <- 10
}

if (min>100){
  min<-100
}else if (min>10){ 
  min<-10
}else{
  min<-1
}

if (min==100){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(100, 1000, 10000, 100000), 
                                    limits=c(min,max))
}else if (min==10){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else if (min==1){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(0.01, 0.1, 1, 10, 100, 1000, 10000), 
                                    limits=c(0.01,max))
}else{
  fixtheyscale<- scale_y_continuous(trans = log_trans(), breaks = base_breaks(), 
                                    labels=scaleFUN, limits=c(min,max))
}

df <- data.frame(prob_exceedance, harr.exceed_scenario11,
                 harr.exceed_scenario15, harr.exceed_scenario14, harr.exceed_scenario16); 
colnames(df) <- c('Date', 'Scenario11', 'Scenario15', 'Scenario14', 'Scenario16')

options(scipen=5, width = 1400, height = 950)
harr.myplot <- ggplot(df, aes(x=Date)) + 
  geom_line(aes(y=Scenario11, color=cn11), size=0.8) +
  geom_line(aes(y=Scenario15, color=cn15), size=0.8)+
  fixtheyscale+ 
  theme_bw()+ 
  theme(legend.position="top", 
        legend.title=element_blank(),
        legend.box = "horizontal", 
        legend.background = element_rect(fill="white",
                                         size=0.5, linetype="solid", 
                                         colour ="white"),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12, colour="black"),
        axis.title=element_text(size=14, colour="black"),
        axis.line = element_line(colour = "black", 
                                 size = 0.5, linetype = "solid"),
        axis.ticks = element_line(colour="black"),
        panel.grid.major=element_line(colour = "light grey"), 
        panel.grid.minor=element_blank(),
        plot.title = element_text(hjust = 0.5))+
  ggtitle('Harrisonburg')+
  scale_colour_manual(values=c("black", 'chocolate2'))+
  guides(colour = guide_legend(override.aes = list(size=5)))+
  labs(x= "Probability of Exceedance (%)", y = "Flow (cfs)")
ggsave("harr_flow_exceedance_comp.png", plot = harr.myplot, device = 'png', width = 8, height = 5.5, units = 'in')

#giles
gile.exceed_scenario11 <- sort(qout_JU1_7630_7490$data11.flow, decreasing = TRUE, na.last = TRUE)
gile.exceed_scenario15 <- sort(qout_JU1_7630_7490$data15.flow, decreasing = TRUE, na.last = TRUE)
gile.exceed_scenario14 <- sort(qout_JU1_7630_7490$data14.flow, decreasing = TRUE, na.last = TRUE)
gile.exceed_scenario16 <- sort(qout_JU1_7630_7490$data16.flow, decreasing = TRUE, na.last = TRUE)

gile.scenario11_exceedance <- quantile(gile.exceed_scenario11, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
gile.scenario15_exceedance <- quantile(gile.exceed_scenario15, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
gile.scenario14_exceedance <- quantile(gile.exceed_scenario14, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
gile.scenario16_exceedance <- quantile(gile.exceed_scenario16, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)

# Determining max flow value for exceedance plot scale
max <- max(c(max(gile.scenario11_exceedance), max(gile.scenario15_exceedance), 
             max(gile.scenario14_exceedance), max(gile.scenario16_exceedance)), na.rm = TRUE)

min <- min(c(min(gile.scenario11_exceedance), min(gile.scenario15_exceedance), 
             min(gile.scenario14_exceedance), min(gile.scenario16_exceedance)),  na.rm = TRUE)

if (max > 10000){
  max <- 100000
}else if (max > 1000){
  max <- 10000
}else if (max > 100){
  max <- 1000
}else if (max > 10){
  max <- 100
}else {
  max <- 10
}

if (min>100){
  min<-100
}else if (min>10){ 
  min<-10
}else{
  min<-1
}

if (min==100){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(100, 1000, 10000, 100000), 
                                    limits=c(min,max))
}else if (min==10){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else if (min==1){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(0.1, 1, 10, 100, 1000, 10000), 
                                    limits=c(0.1,max))
}else{
  fixtheyscale<- scale_y_continuous(trans = log_trans(), breaks = base_breaks(), 
                                    labels=scaleFUN, limits=c(min,max))
}

df <- data.frame(prob_exceedance, gile.exceed_scenario11,
                 gile.exceed_scenario15, gile.exceed_scenario14, gile.exceed_scenario16); 
colnames(df) <- c('Date', 'Scenario11', 'Scenario15', 'Scenario14', 'Scenario16')

options(scipen=5, width = 1400, height = 950)
gile.myplot <- ggplot(df, aes(x=Date)) + 
  geom_line(aes(y=Scenario11, color=cn11), size=0.8) +
  geom_line(aes(y=Scenario14, color=cn14), size=0.8)+
  fixtheyscale+ 
  theme_bw()+ 
  theme(legend.position="top", 
        legend.title=element_blank(),
        legend.box = "horizontal", 
        legend.background = element_rect(fill="white",
                                         size=0.5, linetype="solid", 
                                         colour ="white"),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12, colour="black"),
        axis.title=element_text(size=14, colour="black"),
        axis.line = element_line(colour = "black", 
                                 size = 0.5, linetype = "solid"),
        axis.ticks = element_line(colour="black"),
        panel.grid.major=element_line(colour = "light grey"), 
        panel.grid.minor=element_blank(),
        plot.title = element_text(hjust = 0.5))+
  ggtitle('Giles')+
  scale_colour_manual(values=c("black", 'green3'))+
  guides(colour = guide_legend(override.aes = list(size=5)))+
  labs(x= "Probability of Exceedance (%)", y = "Flow (cfs)")
ggsave("gile_flow_exceedance_comp.png", plot = gile.myplot, device = 'png', width = 8, height = 5.5, units = 'in')

#culpeper
culp.exceed_scenario11 <- sort(qout_RU3_5610_5640$data11.flow, decreasing = TRUE, na.last = TRUE)
culp.exceed_scenario15 <- sort(qout_RU3_5610_5640$data15.flow, decreasing = TRUE, na.last = TRUE)
culp.exceed_scenario14 <- sort(qout_RU3_5610_5640$data14.flow, decreasing = TRUE, na.last = TRUE)
culp.exceed_scenario16 <- sort(qout_RU3_5610_5640$data16.flow, decreasing = TRUE, na.last = TRUE)

culp.scenario11_exceedance <- quantile(culp.exceed_scenario11, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
culp.scenario15_exceedance <- quantile(culp.exceed_scenario15, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
culp.scenario14_exceedance <- quantile(culp.exceed_scenario14, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
culp.scenario16_exceedance <- quantile(culp.exceed_scenario16, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)

# Determining max flow value for exceedance plot scale
max <- max(c(max(culp.scenario11_exceedance), max(culp.scenario15_exceedance), 
             max(culp.scenario14_exceedance), max(culp.scenario16_exceedance)), na.rm = TRUE)

min <- min(c(min(culp.scenario11_exceedance), min(culp.scenario15_exceedance), 
             min(culp.scenario14_exceedance), min(culp.scenario16_exceedance)),  na.rm = TRUE)

if (max > 10000){
  max <- 100000
}else if (max > 1000){
  max <- 10000
}else if (max > 100){
  max <- 1000
}else if (max > 10){
  max <- 100
}else {
  max <- 10
}

if (min>100){
  min<-100
}else if (min>10){ 
  min<-10
}else{
  min<-1
}

if (min==100){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(100, 1000, 10000, 100000), 
                                    limits=c(min,max))
}else if (min==10){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else if (min==1){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(1, 10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else{
  fixtheyscale<- scale_y_continuous(trans = log_trans(), breaks = base_breaks(), 
                                    labels=scaleFUN, limits=c(min,max))
}

df <- data.frame(prob_exceedance, culp.exceed_scenario11,
                 culp.exceed_scenario15, culp.exceed_scenario14, culp.exceed_scenario16); 
colnames(df) <- c('Date', 'Scenario11', 'Scenario15', 'Scenario14', 'Scenario16')

options(scipen=5, width = 1400, height = 950)
culp.myplot <- ggplot(df, aes(x=Date)) + 
  geom_line(aes(y=Scenario11, color=cn11), size=0.8) +
  geom_line(aes(y=Scenario14, color=cn14), size=0.8)+
  fixtheyscale+ 
  theme_bw()+ 
  theme(legend.position="top", 
        legend.title=element_blank(),
        legend.box = "horizontal", 
        legend.background = element_rect(fill="white",
                                         size=0.5, linetype="solid", 
                                         colour ="white"),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12, colour="black"),
        axis.title=element_text(size=14, colour="black"),
        axis.line = element_line(colour = "black", 
                                 size = 0.5, linetype = "solid"),
        axis.ticks = element_line(colour="black"),
        panel.grid.major=element_line(colour = "light grey"), 
        panel.grid.minor=element_blank(),
        plot.title = element_text(hjust = 0.5))+
  ggtitle('Culpeper')+
  scale_colour_manual(values=c("black", 'green3'))+
  guides(colour = guide_legend(override.aes = list(size=5)))+
  labs(x= "Probability of Exceedance (%)", y = "Flow (cfs)")
ggsave("culp_flow_exceedance_comp.png", plot = culp.myplot, device = 'png', width = 8, height = 5.5, units = 'in')

#highland
high.exceed_scenario11 <- sort(qout_JU1_6300_6650$data11.flow, decreasing = TRUE, na.last = TRUE)
high.exceed_scenario15 <- sort(qout_JU1_6300_6650$data15.flow, decreasing = TRUE, na.last = TRUE)
high.exceed_scenario14 <- sort(qout_JU1_6300_6650$data14.flow, decreasing = TRUE, na.last = TRUE)
high.exceed_scenario16 <- sort(qout_JU1_6300_6650$data16.flow, decreasing = TRUE, na.last = TRUE)

high.scenario11_exceedance <- quantile(high.exceed_scenario11, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
high.scenario15_exceedance <- quantile(high.exceed_scenario15, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
high.scenario14_exceedance <- quantile(high.exceed_scenario14, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
high.scenario16_exceedance <- quantile(high.exceed_scenario16, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)

# Determining max flow value for exceedance plot scale
max <- max(c(max(high.scenario11_exceedance), max(high.scenario15_exceedance), 
             max(high.scenario14_exceedance), max(high.scenario16_exceedance)), na.rm = TRUE)

min <- min(c(min(high.scenario11_exceedance), min(high.scenario15_exceedance), 
             min(high.scenario14_exceedance), min(high.scenario16_exceedance)),  na.rm = TRUE)

if (max > 10000){
  max <- 100000
}else if (max > 1000){
  max <- 10000
}else if (max > 100){
  max <- 1000
}else if (max > 10){
  max <- 100
}else {
  max <- 10
}

if (min>100){
  min<-100
}else if (min>10){ 
  min<-10
}else{
  min<-1
}

if (min==100){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(100, 1000, 10000, 100000), 
                                    limits=c(min,max))
}else if (min==10){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else if (min==1){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(1, 10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else{
  fixtheyscale<- scale_y_continuous(trans = log_trans(), breaks = base_breaks(), 
                                    labels=scaleFUN, limits=c(min,max))
}

df <- data.frame(prob_exceedance, high.exceed_scenario11,
                 high.exceed_scenario15, high.exceed_scenario14, high.exceed_scenario16); 
colnames(df) <- c('Date', 'Scenario11', 'Scenario15', 'Scenario14', 'Scenario16')

options(scipen=5, width = 1400, height = 950)
high.myplot <- ggplot(df, aes(x=Date)) + 
  geom_line(aes(y=Scenario11, color=cn11), size=0.8) +
  geom_line(aes(y=Scenario16, color=cn16), size=0.8)+
  fixtheyscale+ 
  theme_bw()+ 
  theme(legend.position="top", 
        legend.title=element_blank(),
        legend.box = "horizontal", 
        legend.background = element_rect(fill="white",
                                         size=0.5, linetype="solid", 
                                         colour ="white"),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12, colour="black"),
        axis.title=element_text(size=14, colour="black"),
        axis.line = element_line(colour = "black", 
                                 size = 0.5, linetype = "solid"),
        axis.ticks = element_line(colour="black"),
        panel.grid.major=element_line(colour = "light grey"), 
        panel.grid.minor=element_blank(),
        plot.title = element_text(hjust = 0.5))+
  ggtitle('Highland')+
  scale_colour_manual(values=c("black", 'blueviolet'))+
  guides(colour = guide_legend(override.aes = list(size=5)))+
  labs(x= "Probability of Exceedance (%)", y = "Flow (cfs)")
ggsave("high_flow_exceedance_comp.png", plot = high.myplot, device = 'png', width = 8, height = 5.5, units = 'in')

#nottoway
nott.exceed_scenario11 <- sort(qout_JA1_7600_7570$data11.flow, decreasing = TRUE, na.last = TRUE)
nott.exceed_scenario15 <- sort(qout_JA1_7600_7570$data15.flow, decreasing = TRUE, na.last = TRUE)
nott.exceed_scenario14 <- sort(qout_JA1_7600_7570$data14.flow, decreasing = TRUE, na.last = TRUE)
nott.exceed_scenario16 <- sort(qout_JA1_7600_7570$data16.flow, decreasing = TRUE, na.last = TRUE)

nott.scenario11_exceedance <- quantile(nott.exceed_scenario11, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
nott.scenario15_exceedance <- quantile(nott.exceed_scenario15, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
nott.scenario14_exceedance <- quantile(nott.exceed_scenario14, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
nott.scenario16_exceedance <- quantile(nott.exceed_scenario16, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)

# Determining max flow value for exceedance plot scale
max <- max(c(max(nott.scenario11_exceedance), max(nott.scenario15_exceedance), 
             max(nott.scenario14_exceedance), max(nott.scenario16_exceedance)), na.rm = TRUE)

min <- min(c(min(nott.scenario11_exceedance), min(nott.scenario15_exceedance), 
             min(nott.scenario14_exceedance), min(nott.scenario16_exceedance)),  na.rm = TRUE)

if (max > 10000){
  max <- 100000
}else if (max > 1000){
  max <- 10000
}else if (max > 100){
  max <- 1000
}else if (max > 10){
  max <- 100
}else {
  max <- 10
}

if (min>100){
  min<-100
}else if (min>10){ 
  min<-10
}else{
  min<-1
}

if (min==100){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(100, 1000, 10000, 100000), 
                                    limits=c(min,max))
}else if (min==10){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else if (min==1){
  fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                    breaks = c(1, 10, 100, 1000, 10000), 
                                    limits=c(min,max))
}else{
  fixtheyscale<- scale_y_continuous(trans = log_trans(), breaks = base_breaks(), 
                                    labels=scaleFUN, limits=c(min,max))
}

df <- data.frame(prob_exceedance, nott.exceed_scenario11,
                 nott.exceed_scenario15, nott.exceed_scenario14, nott.exceed_scenario16); 
colnames(df) <- c('Date', 'Scenario11', 'Scenario15', 'Scenario14', 'Scenario16')

options(scipen=5, width = 1400, height = 950)
nott.myplot <- ggplot(df, aes(x=Date)) + 
  geom_line(aes(y=Scenario11, color=cn11), size=0.8) +
  geom_line(aes(y=Scenario16, color=cn16), size=0.8)+
  fixtheyscale+ 
  theme_bw()+ 
  theme(legend.position="top", 
        legend.title=element_blank(),
        legend.box = "horizontal", 
        legend.background = element_rect(fill="white",
                                         size=0.5, linetype="solid", 
                                         colour ="white"),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12, colour="black"),
        axis.title=element_text(size=14, colour="black"),
        axis.line = element_line(colour = "black", 
                                 size = 0.5, linetype = "solid"),
        axis.ticks = element_line(colour="black"),
        panel.grid.major=element_line(colour = "light grey"), 
        panel.grid.minor=element_blank(),
        plot.title = element_text(hjust = 0.5))+
  ggtitle('Nottoway')+
  scale_colour_manual(values=c("black", 'blueviolet'))+
  guides(colour = guide_legend(override.aes = list(size=5)))+
  labs(x= "Probability of Exceedance (%)", y = "Flow (cfs)")
ggsave("nott_flow_exceedance_comp.png", plot = nott.myplot, device = 'png', width = 8, height = 5.5, units = 'in')


# metrics (ml8, overall mean, l30/l90, s10%,)
library("knitr")
library("kableExtra")

options(knitr.table.format = "latex")
latexoptions <- c("striped","hold_position","scale_down")
file_ext <- ".tex"


shen.mets.11 <- data.frame(matrix(data = NA, nrow = length(shen.up), ncol = 6))
colnames(shen.mets.11) <- c('River Segment', 'Overall Mean (cfs)', '30-Day Low Flow (cfs)', 
                            '90-Day Low Flow (cfs)', 'August Low Flow (cfs)', 
                            'September 10% Flow (cfs)')
shen.mets.14 <- shen.mets.11
shen.mets.15 <- shen.mets.11
shen.mets.16 <- shen.mets.11

for (i in 1:length(shen.up)) {
  riv.seg <- shen.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("qout_", riv.seg)
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$data11.flow)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$data14.flow)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$data15.flow)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$data16.flow)
  colnames(data.16) <- c('date', 'flow')
  
  shen.mets.11$`River Segment`[i] <- riv.seg
  shen.mets.11$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.11), 3)
  shen.mets.11$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 30, min_or_med = "min"), 3)
  shen.mets.11$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 90, min_or_med = "min"), 3)
  shen.mets.11$`August Low Flow (cfs)`[i] <- round(monthly_min(data.11, num.month = 8), 3)
  shen.mets.11$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.11), 3)
  
  shen.mets.14$`River Segment`[i] <- riv.seg
  shen.mets.14$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.14), 3)
  shen.mets.14$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 30, min_or_med = "min"), 3)
  shen.mets.14$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 90, min_or_med = "min"), 3)
  shen.mets.14$`August Low Flow (cfs)`[i] <- round(monthly_min(data.14, num.month = 8), 3)
  shen.mets.14$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.14), 3)
  
  shen.mets.15$`River Segment`[i] <- riv.seg
  shen.mets.15$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.15), 3)
  shen.mets.15$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 30, min_or_med = "min"), 3)
  shen.mets.15$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 90, min_or_med = "min"), 3)
  shen.mets.15$`August Low Flow (cfs)`[i] <- round(monthly_min(data.15, num.month = 8), 3)
  shen.mets.15$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.15), 3)
  
  shen.mets.16$`River Segment`[i] <- riv.seg
  shen.mets.16$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.16), 3)
  shen.mets.16$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 30, min_or_med = "min"), 3)
  shen.mets.16$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 90, min_or_med = "min"), 3)
  shen.mets.16$`August Low Flow (cfs)`[i] <- round(monthly_min(data.16, num.month = 8), 3)
  shen.mets.16$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.16), 3)
}


kable(shen.mets.11,  booktabs = T,
      caption = "Flow Metrics in Shenandoah River Segments (Base Scenario)",
      label = "shenqoutbase",
      col.names = colnames(shen.mets.11)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("shen.mets.11",file_ext,sep=""))

kable(shen.mets.14,  booktabs = T,
      caption = "Flow Metrics in Shenandoah River Segments (ccP50T50 Scenario)",
      label = "shenqout50",
      col.names = colnames(shen.mets.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("shen.mets.14",file_ext,sep=""))

kable(shen.mets.15,  booktabs = T,
      caption = "Flow Metrics in Shenandoah River Segments (ccP10T10 Scenario)",
      label = "shenqout10",
      col.names = colnames(shen.mets.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("shen.mets.15",file_ext,sep=""))

kable(shen.mets.16,  booktabs = T,
      caption = "Flow Metrics in Shenandoah River Segments (ccP90T90 Scenario)",
      label = "shenqout90",
      col.names = colnames(shen.mets.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("shen.mets.16",file_ext,sep=""))


# matt
matt.mets.11 <- data.frame(matrix(data = NA, nrow = length(matt.up), ncol = 6))
colnames(matt.mets.11) <- c('River Segment', 'Overall Mean (cfs)', '30-Day Low Flow (cfs)', 
                            '90-Day Low Flow (cfs)', 'August Low Flow (cfs)', 
                            'September 10% Flow (cfs)')
matt.mets.14 <- matt.mets.11
matt.mets.15 <- matt.mets.11
matt.mets.16 <- matt.mets.11

for (i in 1:length(matt.up)) {
  riv.seg <- matt.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("qout_", riv.seg)
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$data11.flow)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$data14.flow)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$data15.flow)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$data16.flow)
  colnames(data.16) <- c('date', 'flow')
  
  matt.mets.11$`River Segment`[i] <- riv.seg
  matt.mets.11$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.11), 3)
  matt.mets.11$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 30, min_or_med = "min"), 3)
  matt.mets.11$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 90, min_or_med = "min"), 3)
  matt.mets.11$`August Low Flow (cfs)`[i] <- round(monthly_min(data.11, num.month = 8), 3)
  matt.mets.11$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.11), 3)
  
  matt.mets.14$`River Segment`[i] <- riv.seg
  matt.mets.14$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.14), 3)
  matt.mets.14$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 30, min_or_med = "min"), 3)
  matt.mets.14$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 90, min_or_med = "min"), 3)
  matt.mets.14$`August Low Flow (cfs)`[i] <- round(monthly_min(data.14, num.month = 8), 3)
  matt.mets.14$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.14), 3)
  
  matt.mets.15$`River Segment`[i] <- riv.seg
  matt.mets.15$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.15), 3)
  matt.mets.15$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 30, min_or_med = "min"), 3)
  matt.mets.15$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 90, min_or_med = "min"), 3)
  matt.mets.15$`August Low Flow (cfs)`[i] <- round(monthly_min(data.15, num.month = 8), 3)
  matt.mets.15$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.15), 3)
  
  matt.mets.16$`River Segment`[i] <- riv.seg
  matt.mets.16$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.16), 3)
  matt.mets.16$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 30, min_or_med = "min"), 3)
  matt.mets.16$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 90, min_or_med = "min"), 3)
  matt.mets.16$`August Low Flow (cfs)`[i] <- round(monthly_min(data.16, num.month = 8), 3)
  matt.mets.16$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.16), 3)
}


kable(matt.mets.11,  booktabs = T,
      caption = "Flow Metrics in Mattaponi River Segments (Base Scenario)",
      label = "mattqoutbase",
      col.names = colnames(matt.mets.11)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("matt.mets.11",file_ext,sep=""))

kable(matt.mets.14,  booktabs = T,
      caption = "Flow Metrics in Mattaponi River Segments (ccP50T50 Scenario)",
      label = "shenqout50",
      col.names = colnames(matt.mets.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("matt.mets.14",file_ext,sep=""))

kable(matt.mets.15,  booktabs = T,
      caption = "Flow Metrics in Mattaponi River Segments (ccP10T10 Scenario)",
      label = "mattqout10",
      col.names = colnames(matt.mets.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("matt.mets.15",file_ext,sep=""))

kable(matt.mets.16,  booktabs = T,
      caption = "Flow Metrics in Mattaponi River Segments (ccP90T90 Scenario)",
      label = "mattout90",
      col.names = colnames(matt.mets.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("matt.mets.16",file_ext,sep=""))

# pamu
pamu.mets.11 <- data.frame(matrix(data = NA, nrow = length(pamu.up), ncol = 6))
colnames(pamu.mets.11) <- c('River Segment', 'Overall Mean (cfs)', '30-Day Low Flow (cfs)', 
                            '90-Day Low Flow (cfs)', 'August Low Flow (cfs)', 
                            'September 10% Flow (cfs)')
pamu.mets.14 <- pamu.mets.11
pamu.mets.15 <- pamu.mets.11
pamu.mets.16 <- pamu.mets.11

for (i in 1:length(pamu.up)) {
  riv.seg <- pamu.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("qout_", riv.seg)
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$data11.flow)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$data14.flow)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$data15.flow)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$data16.flow)
  colnames(data.16) <- c('date', 'flow')
  
  pamu.mets.11$`River Segment`[i] <- riv.seg
  pamu.mets.11$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.11), 3)
  pamu.mets.11$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 30, min_or_med = "min"), 3)
  pamu.mets.11$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 90, min_or_med = "min"), 3)
  pamu.mets.11$`August Low Flow (cfs)`[i] <- round(monthly_min(data.11, num.month = 8), 3)
  pamu.mets.11$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.11), 3)
  
  pamu.mets.14$`River Segment`[i] <- riv.seg
  pamu.mets.14$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.14), 3)
  pamu.mets.14$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 30, min_or_med = "min"), 3)
  pamu.mets.14$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 90, min_or_med = "min"), 3)
  pamu.mets.14$`August Low Flow (cfs)`[i] <- round(monthly_min(data.14, num.month = 8), 3)
  pamu.mets.14$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.14), 3)
  
  pamu.mets.15$`River Segment`[i] <- riv.seg
  pamu.mets.15$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.15), 3)
  pamu.mets.15$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 30, min_or_med = "min"), 3)
  pamu.mets.15$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 90, min_or_med = "min"), 3)
  pamu.mets.15$`August Low Flow (cfs)`[i] <- round(monthly_min(data.15, num.month = 8), 3)
  pamu.mets.15$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.15), 3)
  
  pamu.mets.16$`River Segment`[i] <- riv.seg
  pamu.mets.16$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.16), 3)
  pamu.mets.16$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 30, min_or_med = "min"), 3)
  pamu.mets.16$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 90, min_or_med = "min"), 3)
  pamu.mets.16$`August Low Flow (cfs)`[i] <- round(monthly_min(data.16, num.month = 8), 3)
  pamu.mets.16$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.16), 3)
}


kable(pamu.mets.11,  booktabs = T,
      caption = "Flow Metrics in Pamunkey River Segments (Base Scenario)",
      label = "pamuoutbase",
      col.names = colnames(pamu.mets.11)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("pamu.mets.11",file_ext,sep=""))

kable(pamu.mets.14,  booktabs = T,
      caption = "Flow Metrics in Pamunkey River Segments (ccP50T50 Scenario)",
      label = "pamuqout50",
      col.names = colnames(pamu.mets.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("pamu.mets.14",file_ext,sep=""))

kable(pamu.mets.15,  booktabs = T,
      caption = "Flow Metrics in Pamunkey River Segments (ccP10T10 Scenario)",
      label = "pamuqout10",
      col.names = colnames(pamu.mets.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("pamu.mets.15",file_ext,sep=""))

kable(pamu.mets.16,  booktabs = T,
      caption = "Flow Metrics in Pamunkey River Segments (ccP90T90 Scenario)",
      label = "pamuqout90",
      col.names = colnames(pamu.mets.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("pamu.mets.16",file_ext,sep=""))

# rapp
rapp.mets.11 <- data.frame(matrix(data = NA, nrow = length(rapp.up), ncol = 6))
colnames(rapp.mets.11) <- c('River Segment', 'Overall Mean (cfs)', '30-Day Low Flow (cfs)', 
                            '90-Day Low Flow (cfs)', 'August Low Flow (cfs)', 
                            'September 10% Flow (cfs)')
rapp.mets.14 <- rapp.mets.11
rapp.mets.15 <- rapp.mets.11
rapp.mets.16 <- rapp.mets.11

for (i in 1:length(rapp.up)) {
  riv.seg <- rapp.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("qout_", riv.seg)
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$data11.flow)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$data14.flow)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$data15.flow)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$data16.flow)
  colnames(data.16) <- c('date', 'flow')
  
  rapp.mets.11$`River Segment`[i] <- riv.seg
  rapp.mets.11$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.11), 3)
  rapp.mets.11$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 30, min_or_med = "min"), 3)
  rapp.mets.11$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 90, min_or_med = "min"), 3)
  rapp.mets.11$`August Low Flow (cfs)`[i] <- round(monthly_min(data.11, num.month = 8), 3)
  rapp.mets.11$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.11), 3)
  
  rapp.mets.14$`River Segment`[i] <- riv.seg
  rapp.mets.14$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.14), 3)
  rapp.mets.14$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 30, min_or_med = "min"), 3)
  rapp.mets.14$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 90, min_or_med = "min"), 3)
  rapp.mets.14$`August Low Flow (cfs)`[i] <- round(monthly_min(data.14, num.month = 8), 3)
  rapp.mets.14$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.14), 3)
  
  rapp.mets.15$`River Segment`[i] <- riv.seg
  rapp.mets.15$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.15), 3)
  rapp.mets.15$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 30, min_or_med = "min"), 3)
  rapp.mets.15$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 90, min_or_med = "min"), 3)
  rapp.mets.15$`August Low Flow (cfs)`[i] <- round(monthly_min(data.15, num.month = 8), 3)
  rapp.mets.15$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.15), 3)
  
  rapp.mets.16$`River Segment`[i] <- riv.seg
  rapp.mets.16$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.16), 3)
  rapp.mets.16$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 30, min_or_med = "min"), 3)
  rapp.mets.16$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 90, min_or_med = "min"), 3)
  rapp.mets.16$`August Low Flow (cfs)`[i] <- round(monthly_min(data.16, num.month = 8), 3)
  rapp.mets.16$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.16), 3)
}


kable(rapp.mets.11,  booktabs = T,
      caption = "Flow Metrics in Rappahannock River Segments (Base Scenario)",
      label = "rappqoutbase",
      col.names = colnames(rapp.mets.11)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("rapp.mets.11",file_ext,sep=""))

kable(rapp.mets.14,  booktabs = T,
      caption = "Flow Metrics in Rappahannock River Segments (ccP50T50 Scenario)",
      label = "rappqout50",
      col.names = colnames(rapp.mets.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("rapp.mets.14",file_ext,sep=""))

kable(rapp.mets.15,  booktabs = T,
      caption = "Flow Metrics in Rappahannock River Segments (ccP10T10 Scenario)",
      label = "rappqout10",
      col.names = colnames(rapp.mets.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("rapp.mets.15",file_ext,sep=""))

kable(rapp.mets.16,  booktabs = T,
      caption = "Flow Metrics in Rappahannock River Segments (ccP90T90 Scenario)",
      label = "rappqout90",
      col.names = colnames(rapp.mets.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("rapp.mets.16",file_ext,sep=""))

# jaup
jaup.mets.11 <- data.frame(matrix(data = NA, nrow = length(jaup.up), ncol = 6))
colnames(jaup.mets.11) <- c('River Segment', 'Overall Mean (cfs)', '30-Day Low Flow (cfs)', 
                            '90-Day Low Flow (cfs)', 'August Low Flow (cfs)', 
                            'September 10% Flow (cfs)')
jaup.mets.14 <- jaup.mets.11
jaup.mets.15 <- jaup.mets.11
jaup.mets.16 <- jaup.mets.11

for (i in 1:length(jaup.up)) {
  riv.seg <- jaup.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("qout_", riv.seg)
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$data11.flow)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$data14.flow)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$data15.flow)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$data16.flow)
  colnames(data.16) <- c('date', 'flow')
  
  jaup.mets.11$`River Segment`[i] <- riv.seg
  jaup.mets.11$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.11), 3)
  jaup.mets.11$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 30, min_or_med = "min"), 3)
  jaup.mets.11$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 90, min_or_med = "min"), 3)
  jaup.mets.11$`August Low Flow (cfs)`[i] <- round(monthly_min(data.11, num.month = 8), 3)
  jaup.mets.11$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.11), 3)
  
  jaup.mets.14$`River Segment`[i] <- riv.seg
  jaup.mets.14$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.14), 3)
  jaup.mets.14$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 30, min_or_med = "min"), 3)
  jaup.mets.14$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 90, min_or_med = "min"), 3)
  jaup.mets.14$`August Low Flow (cfs)`[i] <- round(monthly_min(data.14, num.month = 8), 3)
  jaup.mets.14$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.14), 3)
  
  jaup.mets.15$`River Segment`[i] <- riv.seg
  jaup.mets.15$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.15), 3)
  jaup.mets.15$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 30, min_or_med = "min"), 3)
  jaup.mets.15$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 90, min_or_med = "min"), 3)
  jaup.mets.15$`August Low Flow (cfs)`[i] <- round(monthly_min(data.15, num.month = 8), 3)
  jaup.mets.15$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.15), 3)
  
  jaup.mets.16$`River Segment`[i] <- riv.seg
  jaup.mets.16$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.16), 3)
  jaup.mets.16$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 30, min_or_med = "min"), 3)
  jaup.mets.16$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 90, min_or_med = "min"), 3)
  jaup.mets.16$`August Low Flow (cfs)`[i] <- round(monthly_min(data.16, num.month = 8), 3)
  jaup.mets.16$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.16), 3)
}


kable(jaup.mets.11,  booktabs = T,
      caption = "Flow Metrics in Upper James River Segments (Base Scenario)",
      label = "jaupqoutbase",
      col.names = colnames(jaup.mets.11)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("jaup.mets.11",file_ext,sep=""))

kable(jaup.mets.14,  booktabs = T,
      caption = "Flow Metrics in Upper James River Segments (ccP50T50 Scenario)",
      label = "jaupqout50",
      col.names = colnames(jaup.mets.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("jaup.mets.14",file_ext,sep=""))

kable(jaup.mets.15,  booktabs = T,
      caption = "Flow Metrics in Upper James River Segments (ccP10T10 Scenario)",
      label = "jaupqout10",
      col.names = colnames(jaup.mets.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("jaup.mets.15",file_ext,sep=""))

kable(jaup.mets.16,  booktabs = T,
      caption = "Flow Metrics in Upper James River Segments (ccP90T90 Scenario)",
      label = "jaupqout90",
      col.names = colnames(jaup.mets.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("jaup.mets.16",file_ext,sep=""))

# jami
jami.mets.11 <- data.frame(matrix(data = NA, nrow = length(jami.up), ncol = 6))
colnames(jami.mets.11) <- c('River Segment', 'Overall Mean (cfs)', '30-Day Low Flow (cfs)', 
                            '90-Day Low Flow (cfs)', 'August Low Flow (cfs)', 
                            'September 10% Flow (cfs)')
jami.mets.14 <- jami.mets.11
jami.mets.15 <- jami.mets.11
jami.mets.16 <- jami.mets.11

for (i in 1:length(jami.up)) {
  riv.seg <- jami.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("qout_", riv.seg)
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$data11.flow)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$data14.flow)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$data15.flow)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$data16.flow)
  colnames(data.16) <- c('date', 'flow')
  
  jami.mets.11$`River Segment`[i] <- riv.seg
  jami.mets.11$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.11), 3)
  jami.mets.11$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 30, min_or_med = "min"), 3)
  jami.mets.11$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 90, min_or_med = "min"), 3)
  jami.mets.11$`August Low Flow (cfs)`[i] <- round(monthly_min(data.11, num.month = 8), 3)
  jami.mets.11$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.11), 3)
  
  jami.mets.14$`River Segment`[i] <- riv.seg
  jami.mets.14$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.14), 3)
  jami.mets.14$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 30, min_or_med = "min"), 3)
  jami.mets.14$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 90, min_or_med = "min"), 3)
  jami.mets.14$`August Low Flow (cfs)`[i] <- round(monthly_min(data.14, num.month = 8), 3)
  jami.mets.14$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.14), 3)
  
  jami.mets.15$`River Segment`[i] <- riv.seg
  jami.mets.15$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.15), 3)
  jami.mets.15$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 30, min_or_med = "min"), 3)
  jami.mets.15$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 90, min_or_med = "min"), 3)
  jami.mets.15$`August Low Flow (cfs)`[i] <- round(monthly_min(data.15, num.month = 8), 3)
  jami.mets.15$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.15), 3)
  
  jami.mets.16$`River Segment`[i] <- riv.seg
  jami.mets.16$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.16), 3)
  jami.mets.16$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 30, min_or_med = "min"), 3)
  jami.mets.16$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 90, min_or_med = "min"), 3)
  jami.mets.16$`August Low Flow (cfs)`[i] <- round(monthly_min(data.16, num.month = 8), 3)
  jami.mets.16$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.16), 3)
}


kable(jami.mets.11,  booktabs = T,
      caption = "Flow Metrics in Middle James River Segments (Base Scenario)",
      label = "jamiqoutbase",
      col.names = colnames(jami.mets.11)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("jami.mets.11",file_ext,sep=""))

kable(jami.mets.14,  booktabs = T,
      caption = "Flow Metrics in Middle James River Segments (ccP50T50 Scenario)",
      label = "jamiqout50",
      col.names = colnames(jami.mets.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("jami.mets.14",file_ext,sep=""))

kable(jami.mets.15,  booktabs = T,
      caption = "Flow Metrics in Middle James River Segments (ccP10T10 Scenario)",
      label = "jamiqout10",
      col.names = colnames(jami.mets.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("jami.mets.15",file_ext,sep=""))

kable(jami.mets.16,  booktabs = T,
      caption = "Flow Metrics in Middle James River Segments (ccP90T90 Scenario)",
      label = "jamiqout90",
      col.names = colnames(jami.mets.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("jami.mets.16",file_ext,sep=""))

# appo
appo.mets.11 <- data.frame(matrix(data = NA, nrow = length(appo.up), ncol = 6))
colnames(appo.mets.11) <- c('River Segment', 'Overall Mean (cfs)', '30-Day Low Flow (cfs)', 
                            '90-Day Low Flow (cfs)', 'August Low Flow (cfs)', 
                            'September 10% Flow (cfs)')
appo.mets.14 <- appo.mets.11
appo.mets.15 <- appo.mets.11
appo.mets.16 <- appo.mets.11

for (i in 1:length(appo.up)) {
  riv.seg <- appo.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("qout_", riv.seg)
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$data11.flow)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$data14.flow)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$data15.flow)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$data16.flow)
  colnames(data.16) <- c('date', 'flow')
  
  appo.mets.11$`River Segment`[i] <- riv.seg
  appo.mets.11$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.11), 3)
  appo.mets.11$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 30, min_or_med = "min"), 3)
  appo.mets.11$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 90, min_or_med = "min"), 3)
  appo.mets.11$`August Low Flow (cfs)`[i] <- round(monthly_min(data.11, num.month = 8), 3)
  appo.mets.11$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.11), 3)
  
  appo.mets.14$`River Segment`[i] <- riv.seg
  appo.mets.14$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.14), 3)
  appo.mets.14$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 30, min_or_med = "min"), 3)
  appo.mets.14$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 90, min_or_med = "min"), 3)
  appo.mets.14$`August Low Flow (cfs)`[i] <- round(monthly_min(data.14, num.month = 8), 3)
  appo.mets.14$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.14), 3)
  
  appo.mets.15$`River Segment`[i] <- riv.seg
  appo.mets.15$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.15), 3)
  appo.mets.15$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 30, min_or_med = "min"), 3)
  appo.mets.15$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 90, min_or_med = "min"), 3)
  appo.mets.15$`August Low Flow (cfs)`[i] <- round(monthly_min(data.15, num.month = 8), 3)
  appo.mets.15$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.15), 3)
  
  appo.mets.16$`River Segment`[i] <- riv.seg
  appo.mets.16$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.16), 3)
  appo.mets.16$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 30, min_or_med = "min"), 3)
  appo.mets.16$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 90, min_or_med = "min"), 3)
  appo.mets.16$`August Low Flow (cfs)`[i] <- round(monthly_min(data.16, num.month = 8), 3)
  appo.mets.16$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.16), 3)
}


kable(appo.mets.11,  booktabs = T,
      caption = "Flow Metrics in Appomattox River Segments (Base Scenario)",
      label = "appoqoutbase",
      col.names = colnames(appo.mets.11)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("appo.mets.11",file_ext,sep=""))

kable(appo.mets.14,  booktabs = T,
      caption = "Flow Metrics in Appomattox River Segments (ccP50T50 Scenario)",
      label = "appoqout50",
      col.names = colnames(appo.mets.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("appo.mets.14",file_ext,sep=""))

kable(appo.mets.15,  booktabs = T,
      caption = "Flow Metrics in Appomattox River Segments (ccP10T10 Scenario)",
      label = "appoqout10",
      col.names = colnames(appo.mets.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("appo.mets.15",file_ext,sep=""))

kable(appo.mets.16,  booktabs = T,
      caption = "Flow Metrics in Appomattox River Segments (ccP90T90 Scenario)",
      label = "appoqout90",
      col.names = colnames(appo.mets.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("appo.mets.16",file_ext,sep=""))

# PERCENT DIFFERENCES ----
shen.diff.14 <- shen.mets.14
colnames(shen.diff.14) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
shen.diff.14[,2:6] <- round((shen.mets.14[,2:6]-shen.mets.11[,2:6])/shen.mets.11[,2:6]*100, 2)

kable(shen.diff.14,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Shenandoah River Segments (ccP50T50 Scenario)",
      label = "pctshenqout50",
      col.names = colnames(shen.diff.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("shen.diff.50",file_ext,sep=""))

shen.diff.15 <- shen.mets.15
colnames(shen.diff.15) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
shen.diff.15[,2:6] <- round((shen.mets.15[,2:6]-shen.mets.11[,2:6])/shen.mets.11[,2:6]*100, 2)

kable(shen.diff.15,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Shenandoah River Segments (ccP10T10 Scenario)",
      label = "pctshenqout10",
      col.names = colnames(shen.diff.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("shen.diff.10",file_ext,sep=""))

shen.diff.16 <- shen.mets.16
colnames(shen.diff.16) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
shen.diff.16[,2:6] <- round((shen.mets.16[,2:6]-shen.mets.11[,2:6])/shen.mets.11[,2:6]*100, 2)

kable(shen.diff.16,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Shenandoah River Segments (ccP90T90 Scenario)",
      label = "pctshenqout90",
      col.names = colnames(shen.diff.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("shen.diff.90",file_ext,sep=""))

#
matt.diff.14 <- matt.mets.14
colnames(matt.diff.14) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
matt.diff.14[,2:6] <- round((matt.mets.14[,2:6]-matt.mets.11[,2:6])/matt.mets.11[,2:6]*100, 2)

kable(matt.diff.14,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Mattaponi River Segments (ccP50T50 Scenario)",
      label = "pctmattqout50",
      col.names = colnames(matt.diff.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("matt.diff.50",file_ext,sep=""))

matt.diff.15 <- matt.mets.15
colnames(matt.diff.15) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
matt.diff.15[,2:6] <- round((matt.mets.15[,2:6]-matt.mets.11[,2:6])/matt.mets.11[,2:6]*100, 2)

kable(matt.diff.15,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Mattaponi River Segments (ccP10T10 Scenario)",
      label = "pctmattqout10",
      col.names = colnames(matt.diff.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("matt.diff.10",file_ext,sep=""))

matt.diff.16 <- matt.mets.16
colnames(matt.diff.16) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
matt.diff.16[,2:6] <- round((matt.mets.16[,2:6]-matt.mets.11[,2:6])/matt.mets.11[,2:6]*100, 2)

kable(matt.diff.16,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Mattaponi River Segments (ccP90T90 Scenario)",
      label = "pctmattqout90",
      col.names = colnames(matt.diff.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("matt.diff.90",file_ext,sep=""))

pamu.diff.14 <- pamu.mets.14
colnames(pamu.diff.14) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
pamu.diff.14[,2:6] <- round((pamu.mets.14[,2:6]-pamu.mets.11[,2:6])/pamu.mets.11[,2:6]*100, 2)

kable(pamu.diff.14,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Pamunkey River Segments (ccP50T50 Scenario)",
      label = "pctpamuqout50",
      col.names = colnames(pamu.diff.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("pamu.diff.50",file_ext,sep=""))

pamu.diff.15 <- pamu.mets.15
colnames(pamu.diff.15) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
pamu.diff.15[,2:6] <- round((pamu.mets.15[,2:6]-pamu.mets.11[,2:6])/pamu.mets.11[,2:6]*100, 2)

kable(pamu.diff.15,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Pamunkey River Segments (ccP10T10 Scenario)",
      label = "pctpamuqout10",
      col.names = colnames(pamu.diff.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("pamu.diff.10",file_ext,sep=""))

pamu.diff.16 <- pamu.mets.16
colnames(pamu.diff.16) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
pamu.diff.16[,2:6] <- round((pamu.mets.16[,2:6]-pamu.mets.11[,2:6])/pamu.mets.11[,2:6]*100, 2)

kable(pamu.diff.16,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Pamunkey River Segments (ccP90T90 Scenario)",
      label = "pctpamuqout90",
      col.names = colnames(pamu.diff.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("pamu.diff.90",file_ext,sep=""))

rapp.diff.14 <- rapp.mets.14
colnames(rapp.diff.14) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
rapp.diff.14[,2:6] <- round((rapp.mets.14[,2:6]-rapp.mets.11[,2:6])/rapp.mets.11[,2:6]*100, 2)

kable(rapp.diff.14,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Rappahannock River Segments (ccP50T50 Scenario)",
      label = "pctrappqout50",
      col.names = colnames(rapp.diff.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("rapp.diff.50",file_ext,sep=""))

rapp.diff.15 <- rapp.mets.15
colnames(rapp.diff.15) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
rapp.diff.15[,2:6] <- round((rapp.mets.15[,2:6]-rapp.mets.11[,2:6])/rapp.mets.11[,2:6]*100, 2)

kable(rapp.diff.15,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Rappahannock River Segments (ccP10T10 Scenario)",
      label = "pctrappqout10",
      col.names = colnames(rapp.diff.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("rapp.diff.10",file_ext,sep=""))

rapp.diff.16 <- rapp.mets.16
colnames(rapp.diff.16) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
rapp.diff.16[,2:6] <- round((rapp.mets.16[,2:6]-rapp.mets.11[,2:6])/rapp.mets.11[,2:6]*100, 2)

kable(rapp.diff.16,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Rappahannock River Segments (ccP90T90 Scenario)",
      label = "pctrappqout90",
      col.names = colnames(rapp.diff.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("rapp.diff.90",file_ext,sep=""))

jaup.diff.14 <- jaup.mets.14
colnames(jaup.diff.14) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
jaup.diff.14[,2:6] <- round((jaup.mets.14[,2:6]-jaup.mets.11[,2:6])/jaup.mets.11[,2:6]*100, 2)

kable(jaup.diff.14,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Upper James River Segments (ccP50T50 Scenario)",
      label = "pctjaupqout50",
      col.names = colnames(jaup.diff.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("jaup.diff.50",file_ext,sep=""))

jaup.diff.15 <- jaup.mets.15
colnames(jaup.diff.15) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
jaup.diff.15[,2:6] <- round((jaup.mets.15[,2:6]-jaup.mets.11[,2:6])/jaup.mets.11[,2:6]*100, 2)

kable(jaup.diff.15,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Upper James River Segments (ccP10T10 Scenario)",
      label = "pctjaupqout10",
      col.names = colnames(jaup.diff.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("jaup.diff.10",file_ext,sep=""))

jaup.diff.16 <- jaup.mets.16
colnames(jaup.diff.16) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
jaup.diff.16[,2:6] <- round((jaup.mets.16[,2:6]-jaup.mets.11[,2:6])/jaup.mets.11[,2:6]*100, 2)

kable(jaup.diff.16,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Upper James River Segments (ccP90T90 Scenario)",
      label = "pctjaupqout90",
      col.names = colnames(jaup.diff.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("jaup.diff.90",file_ext,sep=""))

jami.diff.14 <- jami.mets.14
colnames(jami.diff.14) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
jami.diff.14[,2:6] <- round((jami.mets.14[,2:6]-jami.mets.11[,2:6])/jami.mets.11[,2:6]*100, 2)

kable(jami.diff.14,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Middle James River Segments (ccP50T50 Scenario)",
      label = "pctjamiqout50",
      col.names = colnames(jami.diff.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("jami.diff.50",file_ext,sep=""))

jami.diff.15 <- jami.mets.15
colnames(jami.diff.15) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
jami.diff.15[,2:6] <- round((jami.mets.15[,2:6]-jami.mets.11[,2:6])/jami.mets.11[,2:6]*100, 2)

kable(jami.diff.15,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Middle James River Segments (ccP10T10 Scenario)",
      label = "pctjamiqout10",
      col.names = colnames(jami.diff.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("jami.diff.10",file_ext,sep=""))

jami.diff.16 <- jami.mets.16
colnames(jami.diff.16) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
jami.diff.16[,2:6] <- round((jami.mets.16[,2:6]-jami.mets.11[,2:6])/jami.mets.11[,2:6]*100, 2)

kable(jami.diff.16,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Middle James River Segments (ccP90T90 Scenario)",
      label = "pctjamiqout90",
      col.names = colnames(jami.diff.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("jami.diff.90",file_ext,sep=""))

appo.diff.14 <- appo.mets.14
colnames(appo.diff.14) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
appo.diff.14[,2:6] <- round((appo.mets.14[,2:6]-appo.mets.11[,2:6])/appo.mets.11[,2:6]*100, 2)

kable(appo.diff.14,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Appomattox River Segments (ccP50T50 Scenario)",
      label = "pctappoqout50",
      col.names = colnames(appo.diff.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("appo.diff.50",file_ext,sep=""))

appo.diff.15 <- appo.mets.15
colnames(appo.diff.15) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
appo.diff.15[,2:6] <- round((appo.mets.15[,2:6]-appo.mets.11[,2:6])/appo.mets.11[,2:6]*100, 2)

kable(appo.diff.15,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Appomattox River Segments (ccP10T10 Scenario)",
      label = "pctappoqout10",
      col.names = colnames(appo.diff.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("appo.diff.10",file_ext,sep=""))

appo.diff.16 <- appo.mets.16
colnames(appo.diff.16) <- c('River Segment', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
appo.diff.16[,2:6] <- round((appo.mets.16[,2:6]-appo.mets.11[,2:6])/appo.mets.11[,2:6]*100, 2)

kable(appo.diff.16,  booktabs = T,
      caption = "Percent Changes in Flow Metrics in Appomattox River Segments (ccP90T90 Scenario)",
      label = "pctappoqout90",
      col.names = colnames(appo.diff.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("appo.diff.90",file_ext,sep=""))


# WHOLE RIVER BASIN -----
for (i in 1:length(shen.up)) {
  riv.seg <- shen.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("qout_", riv.seg, "_weighted")
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$data11.flow)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$data14.flow)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$data15.flow)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$data16.flow)
  colnames(data.16) <- c('date', 'flow')
  
  shen.mets.11$`River Segment`[i] <- riv.seg
  shen.mets.11$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.11), 3)
  shen.mets.11$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 30, min_or_med = "min"), 3)
  shen.mets.11$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 90, min_or_med = "min"), 3)
  shen.mets.11$`August Low Flow (cfs)`[i] <- round(monthly_min(data.11, num.month = 8), 3)
  shen.mets.11$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.11), 3)
  
  shen.mets.14$`River Segment`[i] <- riv.seg
  shen.mets.14$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.14), 3)
  shen.mets.14$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 30, min_or_med = "min"), 3)
  shen.mets.14$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 90, min_or_med = "min"), 3)
  shen.mets.14$`August Low Flow (cfs)`[i] <- round(monthly_min(data.14, num.month = 8), 3)
  shen.mets.14$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.14), 3)
  
  shen.mets.15$`River Segment`[i] <- riv.seg
  shen.mets.15$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.15), 3)
  shen.mets.15$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 30, min_or_med = "min"), 3)
  shen.mets.15$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 90, min_or_med = "min"), 3)
  shen.mets.15$`August Low Flow (cfs)`[i] <- round(monthly_min(data.15, num.month = 8), 3)
  shen.mets.15$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.15), 3)
  
  shen.mets.16$`River Segment`[i] <- riv.seg
  shen.mets.16$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.16), 3)
  shen.mets.16$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 30, min_or_med = "min"), 3)
  shen.mets.16$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 90, min_or_med = "min"), 3)
  shen.mets.16$`August Low Flow (cfs)`[i] <- round(monthly_min(data.16, num.month = 8), 3)
  shen.mets.16$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.16), 3)
}

for (i in 1:length(matt.up)) {
  riv.seg <- matt.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("qout_", riv.seg, "_weighted")
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$data11.flow)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$data14.flow)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$data15.flow)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$data16.flow)
  colnames(data.16) <- c('date', 'flow')
  
  matt.mets.11$`River Segment`[i] <- riv.seg
  matt.mets.11$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.11), 3)
  matt.mets.11$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 30, min_or_med = "min"), 3)
  matt.mets.11$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 90, min_or_med = "min"), 3)
  matt.mets.11$`August Low Flow (cfs)`[i] <- round(monthly_min(data.11, num.month = 8), 3)
  matt.mets.11$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.11), 3)
  
  matt.mets.14$`River Segment`[i] <- riv.seg
  matt.mets.14$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.14), 3)
  matt.mets.14$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 30, min_or_med = "min"), 3)
  matt.mets.14$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 90, min_or_med = "min"), 3)
  matt.mets.14$`August Low Flow (cfs)`[i] <- round(monthly_min(data.14, num.month = 8), 3)
  matt.mets.14$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.14), 3)
  
  matt.mets.15$`River Segment`[i] <- riv.seg
  matt.mets.15$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.15), 3)
  matt.mets.15$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 30, min_or_med = "min"), 3)
  matt.mets.15$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 90, min_or_med = "min"), 3)
  matt.mets.15$`August Low Flow (cfs)`[i] <- round(monthly_min(data.15, num.month = 8), 3)
  matt.mets.15$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.15), 3)
  
  matt.mets.16$`River Segment`[i] <- riv.seg
  matt.mets.16$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.16), 3)
  matt.mets.16$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 30, min_or_med = "min"), 3)
  matt.mets.16$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 90, min_or_med = "min"), 3)
  matt.mets.16$`August Low Flow (cfs)`[i] <- round(monthly_min(data.16, num.month = 8), 3)
  matt.mets.16$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.16), 3)
}

for (i in 1:length(pamu.up)) {
  riv.seg <- pamu.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("qout_", riv.seg, "_weighted")
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$data11.flow)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$data14.flow)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$data15.flow)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$data16.flow)
  colnames(data.16) <- c('date', 'flow')
  
  pamu.mets.11$`River Segment`[i] <- riv.seg
  pamu.mets.11$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.11), 3)
  pamu.mets.11$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 30, min_or_med = "min"), 3)
  pamu.mets.11$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 90, min_or_med = "min"), 3)
  pamu.mets.11$`August Low Flow (cfs)`[i] <- round(monthly_min(data.11, num.month = 8), 3)
  pamu.mets.11$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.11), 3)
  
  pamu.mets.14$`River Segment`[i] <- riv.seg
  pamu.mets.14$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.14), 3)
  pamu.mets.14$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 30, min_or_med = "min"), 3)
  pamu.mets.14$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 90, min_or_med = "min"), 3)
  pamu.mets.14$`August Low Flow (cfs)`[i] <- round(monthly_min(data.14, num.month = 8), 3)
  pamu.mets.14$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.14), 3)
  
  pamu.mets.15$`River Segment`[i] <- riv.seg
  pamu.mets.15$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.15), 3)
  pamu.mets.15$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 30, min_or_med = "min"), 3)
  pamu.mets.15$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 90, min_or_med = "min"), 3)
  pamu.mets.15$`August Low Flow (cfs)`[i] <- round(monthly_min(data.15, num.month = 8), 3)
  pamu.mets.15$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.15), 3)
  
  pamu.mets.16$`River Segment`[i] <- riv.seg
  pamu.mets.16$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.16), 3)
  pamu.mets.16$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 30, min_or_med = "min"), 3)
  pamu.mets.16$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 90, min_or_med = "min"), 3)
  pamu.mets.16$`August Low Flow (cfs)`[i] <- round(monthly_min(data.16, num.month = 8), 3)
  pamu.mets.16$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.16), 3)
}

for (i in 1:length(rapp.up)) {
  riv.seg <- rapp.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("qout_", riv.seg, "_weighted")
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$data11.flow)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$data14.flow)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$data15.flow)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$data16.flow)
  colnames(data.16) <- c('date', 'flow')
  
  rapp.mets.11$`River Segment`[i] <- riv.seg
  rapp.mets.11$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.11), 3)
  rapp.mets.11$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 30, min_or_med = "min"), 3)
  rapp.mets.11$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 90, min_or_med = "min"), 3)
  rapp.mets.11$`August Low Flow (cfs)`[i] <- round(monthly_min(data.11, num.month = 8), 3)
  rapp.mets.11$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.11), 3)
  
  rapp.mets.14$`River Segment`[i] <- riv.seg
  rapp.mets.14$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.14), 3)
  rapp.mets.14$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 30, min_or_med = "min"), 3)
  rapp.mets.14$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 90, min_or_med = "min"), 3)
  rapp.mets.14$`August Low Flow (cfs)`[i] <- round(monthly_min(data.14, num.month = 8), 3)
  rapp.mets.14$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.14), 3)
  
  rapp.mets.15$`River Segment`[i] <- riv.seg
  rapp.mets.15$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.15), 3)
  rapp.mets.15$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 30, min_or_med = "min"), 3)
  rapp.mets.15$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 90, min_or_med = "min"), 3)
  rapp.mets.15$`August Low Flow (cfs)`[i] <- round(monthly_min(data.15, num.month = 8), 3)
  rapp.mets.15$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.15), 3)
  
  rapp.mets.16$`River Segment`[i] <- riv.seg
  rapp.mets.16$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.16), 3)
  rapp.mets.16$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 30, min_or_med = "min"), 3)
  rapp.mets.16$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 90, min_or_med = "min"), 3)
  rapp.mets.16$`August Low Flow (cfs)`[i] <- round(monthly_min(data.16, num.month = 8), 3)
  rapp.mets.16$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.16), 3)
}

for (i in 1:length(jaup.up)) {
  riv.seg <- jaup.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("qout_", riv.seg, "_weighted")
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$data11.flow)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$data14.flow)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$data15.flow)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$data16.flow)
  colnames(data.16) <- c('date', 'flow')
  
  jaup.mets.11$`River Segment`[i] <- riv.seg
  jaup.mets.11$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.11), 3)
  jaup.mets.11$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 30, min_or_med = "min"), 3)
  jaup.mets.11$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 90, min_or_med = "min"), 3)
  jaup.mets.11$`August Low Flow (cfs)`[i] <- round(monthly_min(data.11, num.month = 8), 3)
  jaup.mets.11$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.11), 3)
  
  jaup.mets.14$`River Segment`[i] <- riv.seg
  jaup.mets.14$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.14), 3)
  jaup.mets.14$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 30, min_or_med = "min"), 3)
  jaup.mets.14$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 90, min_or_med = "min"), 3)
  jaup.mets.14$`August Low Flow (cfs)`[i] <- round(monthly_min(data.14, num.month = 8), 3)
  jaup.mets.14$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.14), 3)
  
  jaup.mets.15$`River Segment`[i] <- riv.seg
  jaup.mets.15$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.15), 3)
  jaup.mets.15$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 30, min_or_med = "min"), 3)
  jaup.mets.15$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 90, min_or_med = "min"), 3)
  jaup.mets.15$`August Low Flow (cfs)`[i] <- round(monthly_min(data.15, num.month = 8), 3)
  jaup.mets.15$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.15), 3)
  
  jaup.mets.16$`River Segment`[i] <- riv.seg
  jaup.mets.16$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.16), 3)
  jaup.mets.16$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 30, min_or_med = "min"), 3)
  jaup.mets.16$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 90, min_or_med = "min"), 3)
  jaup.mets.16$`August Low Flow (cfs)`[i] <- round(monthly_min(data.16, num.month = 8), 3)
  jaup.mets.16$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.16), 3)
}

for (i in 1:length(jami.up)) {
  riv.seg <- jami.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("qout_", riv.seg, "_weighted")
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$data11.flow)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$data14.flow)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$data15.flow)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$data16.flow)
  colnames(data.16) <- c('date', 'flow')
  
  jami.mets.11$`River Segment`[i] <- riv.seg
  jami.mets.11$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.11), 3)
  jami.mets.11$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 30, min_or_med = "min"), 3)
  jami.mets.11$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 90, min_or_med = "min"), 3)
  jami.mets.11$`August Low Flow (cfs)`[i] <- round(monthly_min(data.11, num.month = 8), 3)
  jami.mets.11$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.11), 3)
  
  jami.mets.14$`River Segment`[i] <- riv.seg
  jami.mets.14$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.14), 3)
  jami.mets.14$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 30, min_or_med = "min"), 3)
  jami.mets.14$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 90, min_or_med = "min"), 3)
  jami.mets.14$`August Low Flow (cfs)`[i] <- round(monthly_min(data.14, num.month = 8), 3)
  jami.mets.14$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.14), 3)
  
  jami.mets.15$`River Segment`[i] <- riv.seg
  jami.mets.15$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.15), 3)
  jami.mets.15$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 30, min_or_med = "min"), 3)
  jami.mets.15$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 90, min_or_med = "min"), 3)
  jami.mets.15$`August Low Flow (cfs)`[i] <- round(monthly_min(data.15, num.month = 8), 3)
  jami.mets.15$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.15), 3)
  
  jami.mets.16$`River Segment`[i] <- riv.seg
  jami.mets.16$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.16), 3)
  jami.mets.16$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 30, min_or_med = "min"), 3)
  jami.mets.16$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 90, min_or_med = "min"), 3)
  jami.mets.16$`August Low Flow (cfs)`[i] <- round(monthly_min(data.16, num.month = 8), 3)
  jami.mets.16$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.16), 3)
}

for (i in 1:length(appo.up)) {
  riv.seg <- appo.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("qout_", riv.seg, "_weighted")
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$data11.flow)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$data14.flow)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$data15.flow)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$data16.flow)
  colnames(data.16) <- c('date', 'flow')
  
  appo.mets.11$`River Segment`[i] <- riv.seg
  appo.mets.11$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.11), 3)
  appo.mets.11$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 30, min_or_med = "min"), 3)
  appo.mets.11$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.11, num.day = 90, min_or_med = "min"), 3)
  appo.mets.11$`August Low Flow (cfs)`[i] <- round(monthly_min(data.11, num.month = 8), 3)
  appo.mets.11$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.11), 3)
  
  appo.mets.14$`River Segment`[i] <- riv.seg
  appo.mets.14$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.14), 3)
  appo.mets.14$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 30, min_or_med = "min"), 3)
  appo.mets.14$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.14, num.day = 90, min_or_med = "min"), 3)
  appo.mets.14$`August Low Flow (cfs)`[i] <- round(monthly_min(data.14, num.month = 8), 3)
  appo.mets.14$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.14), 3)
  
  appo.mets.15$`River Segment`[i] <- riv.seg
  appo.mets.15$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.15), 3)
  appo.mets.15$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 30, min_or_med = "min"), 3)
  appo.mets.15$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.15, num.day = 90, min_or_med = "min"), 3)
  appo.mets.15$`August Low Flow (cfs)`[i] <- round(monthly_min(data.15, num.month = 8), 3)
  appo.mets.15$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.15), 3)
  
  appo.mets.16$`River Segment`[i] <- riv.seg
  appo.mets.16$`Overall Mean (cfs)`[i] <- round(overall_mean_flow(data.16), 3)
  appo.mets.16$`30-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 30, min_or_med = "min"), 3)
  appo.mets.16$`90-Day Low Flow (cfs)`[i] <- round(num_day_min(data.16, num.day = 90, min_or_med = "min"), 3)
  appo.mets.16$`August Low Flow (cfs)`[i] <- round(monthly_min(data.16, num.month = 8), 3)
  appo.mets.16$`September 10% Flow (cfs)`[i] <- round(sept_10_flow(data.16), 3)
}

shen.mets <- data.frame(matrix(data = NA, nrow = 4, ncol = 6))
colnames(shen.mets) <- c('Scenario', 'Overall Mean (cfs/sq mi)', '30-Day Low Flow (cfs/sq mi)', '90-Day Low Flow (cfs/sq mi)',
                         'August Low Flow (cfs/sq mi)', 'September 10% Flow (cfs/sq mi)')
shen.mets$Scenario <- c('Base', 'ccP10T10', 'ccP50T50', 'ccP90T90')
shen.mets$`Overall Mean (cfs/sq mi)`[1] <- round(mean(shen.mets.11$`Overall Mean (cfs)`), 2)
shen.mets$`30-Day Low Flow (cfs/sq mi)`[1] <- round(mean(shen.mets.11$`30-Day Low Flow (cfs)`), 2)
shen.mets$`90-Day Low Flow (cfs/sq mi)`[1] <- round(mean(shen.mets.11$`90-Day Low Flow (cfs)`), 2)
shen.mets$`August Low Flow (cfs/sq mi)`[1] <- round(mean(shen.mets.11$`August Low Flow (cfs)`), 2)
shen.mets$`September 10% Flow (cfs/sq mi)`[1] <- round(mean(shen.mets.11$`September 10% Flow (cfs)`), 2)
shen.mets$`Overall Mean (cfs/sq mi)`[2] <- round(mean(shen.mets.15$`Overall Mean (cfs)`), 2)
shen.mets$`30-Day Low Flow (cfs/sq mi)`[2] <- round(mean(shen.mets.15$`30-Day Low Flow (cfs)`), 2)
shen.mets$`90-Day Low Flow (cfs/sq mi)`[2] <- round(mean(shen.mets.15$`90-Day Low Flow (cfs)`), 2)
shen.mets$`August Low Flow (cfs/sq mi)`[2] <- round(mean(shen.mets.15$`August Low Flow (cfs)`), 2)
shen.mets$`September 10% Flow (cfs/sq mi)`[2] <- round(mean(shen.mets.15$`September 10% Flow (cfs)`), 2)
shen.mets$`Overall Mean (cfs/sq mi)`[3] <- round(mean(shen.mets.14$`Overall Mean (cfs)`), 2)
shen.mets$`30-Day Low Flow (cfs/sq mi)`[3] <- round(mean(shen.mets.14$`30-Day Low Flow (cfs)`), 2)
shen.mets$`90-Day Low Flow (cfs/sq mi)`[3] <- round(mean(shen.mets.14$`90-Day Low Flow (cfs)`), 2)
shen.mets$`August Low Flow (cfs/sq mi)`[3] <- round(mean(shen.mets.14$`August Low Flow (cfs)`), 2)
shen.mets$`September 10% Flow (cfs/sq mi)`[3] <- round(mean(shen.mets.14$`September 10% Flow (cfs)`), 2)
shen.mets$`Overall Mean (cfs/sq mi)`[4] <- round(mean(shen.mets.16$`Overall Mean (cfs)`), 2)
shen.mets$`30-Day Low Flow (cfs/sq mi)`[4] <- round(mean(shen.mets.16$`30-Day Low Flow (cfs)`), 2)
shen.mets$`90-Day Low Flow (cfs/sq mi)`[4] <- round(mean(shen.mets.16$`90-Day Low Flow (cfs)`), 2)
shen.mets$`August Low Flow (cfs/sq mi)`[4] <- round(mean(shen.mets.16$`August Low Flow (cfs)`), 2)
shen.mets$`September 10% Flow (cfs/sq mi)`[4] <- round(mean(shen.mets.16$`September 10% Flow (cfs)`), 2)

matt.mets <- data.frame(matrix(data = NA, nrow = 4, ncol = 6))
colnames(matt.mets) <- c('Scenario', 'Overall Mean (cfs/sq mi)', '30-Day Low Flow (cfs/sq mi)', '90-Day Low Flow (cfs/sq mi)',
                         'August Low Flow (cfs/sq mi)', 'September 10% Flow (cfs/sq mi)')
matt.mets$Scenario <- c('Base', 'ccP10T10', 'ccP50T50', 'ccP90T90')
matt.mets$`Overall Mean (cfs/sq mi)`[1] <- round(mean(matt.mets.11$`Overall Mean (cfs)`), 2)
matt.mets$`30-Day Low Flow (cfs/sq mi)`[1] <- round(mean(matt.mets.11$`30-Day Low Flow (cfs)`), 2)
matt.mets$`90-Day Low Flow (cfs/sq mi)`[1] <- round(mean(matt.mets.11$`90-Day Low Flow (cfs)`), 2)
matt.mets$`August Low Flow (cfs/sq mi)`[1] <- round(mean(matt.mets.11$`August Low Flow (cfs)`), 2)
matt.mets$`September 10% Flow (cfs/sq mi)`[1] <- round(mean(matt.mets.11$`September 10% Flow (cfs)`), 2)
matt.mets$`Overall Mean (cfs/sq mi)`[2] <- round(mean(matt.mets.15$`Overall Mean (cfs)`), 2)
matt.mets$`30-Day Low Flow (cfs/sq mi)`[2] <- round(mean(matt.mets.15$`30-Day Low Flow (cfs)`), 2)
matt.mets$`90-Day Low Flow (cfs/sq mi)`[2] <- round(mean(matt.mets.15$`90-Day Low Flow (cfs)`), 2)
matt.mets$`August Low Flow (cfs/sq mi)`[2] <- round(mean(matt.mets.15$`August Low Flow (cfs)`), 2)
matt.mets$`September 10% Flow (cfs/sq mi)`[2] <- round(mean(matt.mets.15$`September 10% Flow (cfs)`), 2)
matt.mets$`Overall Mean (cfs/sq mi)`[3] <- round(mean(matt.mets.14$`Overall Mean (cfs)`), 2)
matt.mets$`30-Day Low Flow (cfs/sq mi)`[3] <- round(mean(matt.mets.14$`30-Day Low Flow (cfs)`), 2)
matt.mets$`90-Day Low Flow (cfs/sq mi)`[3] <- round(mean(matt.mets.14$`90-Day Low Flow (cfs)`), 2)
matt.mets$`August Low Flow (cfs/sq mi)`[3] <- round(mean(matt.mets.14$`August Low Flow (cfs)`), 2)
matt.mets$`September 10% Flow (cfs/sq mi)`[3] <- round(mean(matt.mets.14$`September 10% Flow (cfs)`), 2)
matt.mets$`Overall Mean (cfs/sq mi)`[4] <- round(mean(matt.mets.16$`Overall Mean (cfs)`), 2)
matt.mets$`30-Day Low Flow (cfs/sq mi)`[4] <- round(mean(matt.mets.16$`30-Day Low Flow (cfs)`), 2)
matt.mets$`90-Day Low Flow (cfs/sq mi)`[4] <- round(mean(matt.mets.16$`90-Day Low Flow (cfs)`), 2)
matt.mets$`August Low Flow (cfs/sq mi)`[4] <- round(mean(matt.mets.16$`August Low Flow (cfs)`), 2)
matt.mets$`September 10% Flow (cfs/sq mi)`[4] <- round(mean(matt.mets.16$`September 10% Flow (cfs)`), 2)

pamu.mets <- data.frame(matrix(data = NA, nrow = 4, ncol = 6))
colnames(pamu.mets) <- c('Scenario', 'Overall Mean (cfs/sq mi)', '30-Day Low Flow (cfs/sq mi)', '90-Day Low Flow (cfs/sq mi)',
                         'August Low Flow (cfs/sq mi)', 'September 10% Flow (cfs/sq mi)')
pamu.mets$Scenario <- c('Base', 'ccP10T10', 'ccP50T50', 'ccP90T90')
pamu.mets$`Overall Mean (cfs/sq mi)`[1] <- round(mean(pamu.mets.11$`Overall Mean (cfs)`), 2)
pamu.mets$`30-Day Low Flow (cfs/sq mi)`[1] <- round(mean(pamu.mets.11$`30-Day Low Flow (cfs)`), 2)
pamu.mets$`90-Day Low Flow (cfs/sq mi)`[1] <- round(mean(pamu.mets.11$`90-Day Low Flow (cfs)`), 2)
pamu.mets$`August Low Flow (cfs/sq mi)`[1] <- round(mean(pamu.mets.11$`August Low Flow (cfs)`), 2)
pamu.mets$`September 10% Flow (cfs/sq mi)`[1] <- round(mean(pamu.mets.11$`September 10% Flow (cfs)`), 2)
pamu.mets$`Overall Mean (cfs/sq mi)`[2] <- round(mean(pamu.mets.15$`Overall Mean (cfs)`), 2)
pamu.mets$`30-Day Low Flow (cfs/sq mi)`[2] <- round(mean(pamu.mets.15$`30-Day Low Flow (cfs)`), 2)
pamu.mets$`90-Day Low Flow (cfs/sq mi)`[2] <- round(mean(pamu.mets.15$`90-Day Low Flow (cfs)`), 2)
pamu.mets$`August Low Flow (cfs/sq mi)`[2] <- round(mean(pamu.mets.15$`August Low Flow (cfs)`), 2)
pamu.mets$`September 10% Flow (cfs/sq mi)`[2] <- round(mean(pamu.mets.15$`September 10% Flow (cfs)`), 2)
pamu.mets$`Overall Mean (cfs/sq mi)`[3] <- round(mean(pamu.mets.14$`Overall Mean (cfs)`), 2)
pamu.mets$`30-Day Low Flow (cfs/sq mi)`[3] <- round(mean(pamu.mets.14$`30-Day Low Flow (cfs)`), 2)
pamu.mets$`90-Day Low Flow (cfs/sq mi)`[3] <- round(mean(pamu.mets.14$`90-Day Low Flow (cfs)`), 2)
pamu.mets$`August Low Flow (cfs/sq mi)`[3] <- round(mean(pamu.mets.14$`August Low Flow (cfs)`), 2)
pamu.mets$`September 10% Flow (cfs/sq mi)`[3] <- round(mean(pamu.mets.14$`September 10% Flow (cfs)`), 2)
pamu.mets$`Overall Mean (cfs/sq mi)`[4] <- round(mean(pamu.mets.16$`Overall Mean (cfs)`), 2)
pamu.mets$`30-Day Low Flow (cfs/sq mi)`[4] <- round(mean(pamu.mets.16$`30-Day Low Flow (cfs)`), 2)
pamu.mets$`90-Day Low Flow (cfs/sq mi)`[4] <- round(mean(pamu.mets.16$`90-Day Low Flow (cfs)`), 2)
pamu.mets$`August Low Flow (cfs/sq mi)`[4] <- round(mean(pamu.mets.16$`August Low Flow (cfs)`), 2)
pamu.mets$`September 10% Flow (cfs/sq mi)`[4] <- round(mean(pamu.mets.16$`September 10% Flow (cfs)`), 2)

rapp.mets <- data.frame(matrix(data = NA, nrow = 4, ncol = 6))
colnames(rapp.mets) <- c('Scenario', 'Overall Mean (cfs/sq mi)', '30-Day Low Flow (cfs/sq mi)', '90-Day Low Flow (cfs/sq mi)',
                         'August Low Flow (cfs/sq mi)', 'September 10% Flow (cfs/sq mi)')
rapp.mets$Scenario <- c('Base', 'ccP10T10', 'ccP50T50', 'ccP90T90')
rapp.mets$`Overall Mean (cfs/sq mi)`[1] <- round(mean(rapp.mets.11$`Overall Mean (cfs)`), 2)
rapp.mets$`30-Day Low Flow (cfs/sq mi)`[1] <- round(mean(rapp.mets.11$`30-Day Low Flow (cfs)`), 2)
rapp.mets$`90-Day Low Flow (cfs/sq mi)`[1] <- round(mean(rapp.mets.11$`90-Day Low Flow (cfs)`), 2)
rapp.mets$`August Low Flow (cfs/sq mi)`[1] <- round(mean(rapp.mets.11$`August Low Flow (cfs)`), 2)
rapp.mets$`September 10% Flow (cfs/sq mi)`[1] <- round(mean(rapp.mets.11$`September 10% Flow (cfs)`), 2)
rapp.mets$`Overall Mean (cfs/sq mi)`[2] <- round(mean(rapp.mets.15$`Overall Mean (cfs)`), 2)
rapp.mets$`30-Day Low Flow (cfs/sq mi)`[2] <- round(mean(rapp.mets.15$`30-Day Low Flow (cfs)`), 2)
rapp.mets$`90-Day Low Flow (cfs/sq mi)`[2] <- round(mean(rapp.mets.15$`90-Day Low Flow (cfs)`), 2)
rapp.mets$`August Low Flow (cfs/sq mi)`[2] <- round(mean(rapp.mets.15$`August Low Flow (cfs)`), 2)
rapp.mets$`September 10% Flow (cfs/sq mi)`[2] <- round(mean(rapp.mets.15$`September 10% Flow (cfs)`), 2)
rapp.mets$`Overall Mean (cfs/sq mi)`[3] <- round(mean(rapp.mets.14$`Overall Mean (cfs)`), 2)
rapp.mets$`30-Day Low Flow (cfs/sq mi)`[3] <- round(mean(rapp.mets.14$`30-Day Low Flow (cfs)`), 2)
rapp.mets$`90-Day Low Flow (cfs/sq mi)`[3] <- round(mean(rapp.mets.14$`90-Day Low Flow (cfs)`), 2)
rapp.mets$`August Low Flow (cfs/sq mi)`[3] <- round(mean(rapp.mets.14$`August Low Flow (cfs)`), 2)
rapp.mets$`September 10% Flow (cfs/sq mi)`[3] <- round(mean(rapp.mets.14$`September 10% Flow (cfs)`), 2)
rapp.mets$`Overall Mean (cfs/sq mi)`[4] <- round(mean(rapp.mets.16$`Overall Mean (cfs)`), 2)
rapp.mets$`30-Day Low Flow (cfs/sq mi)`[4] <- round(mean(rapp.mets.16$`30-Day Low Flow (cfs)`), 2)
rapp.mets$`90-Day Low Flow (cfs/sq mi)`[4] <- round(mean(rapp.mets.16$`90-Day Low Flow (cfs)`), 2)
rapp.mets$`August Low Flow (cfs/sq mi)`[4] <- round(mean(rapp.mets.16$`August Low Flow (cfs)`), 2)
rapp.mets$`September 10% Flow (cfs/sq mi)`[4] <- round(mean(rapp.mets.16$`September 10% Flow (cfs)`), 2)

jaup.mets <- data.frame(matrix(data = NA, nrow = 4, ncol = 6))
colnames(jaup.mets) <- c('Scenario', 'Overall Mean (cfs/sq mi)', '30-Day Low Flow (cfs/sq mi)', '90-Day Low Flow (cfs/sq mi)',
                         'August Low Flow (cfs/sq mi)', 'September 10% Flow (cfs/sq mi)')
jaup.mets$Scenario <- c('Base', 'ccP10T10', 'ccP50T50', 'ccP90T90')
jaup.mets$`Overall Mean (cfs/sq mi)`[1] <- round(mean(jaup.mets.11$`Overall Mean (cfs)`), 2)
jaup.mets$`30-Day Low Flow (cfs/sq mi)`[1] <- round(mean(jaup.mets.11$`30-Day Low Flow (cfs)`), 2)
jaup.mets$`90-Day Low Flow (cfs/sq mi)`[1] <- round(mean(jaup.mets.11$`90-Day Low Flow (cfs)`), 2)
jaup.mets$`August Low Flow (cfs/sq mi)`[1] <- round(mean(jaup.mets.11$`August Low Flow (cfs)`), 2)
jaup.mets$`September 10% Flow (cfs/sq mi)`[1] <- round(mean(jaup.mets.11$`September 10% Flow (cfs)`), 2)
jaup.mets$`Overall Mean (cfs/sq mi)`[2] <- round(mean(jaup.mets.15$`Overall Mean (cfs)`), 2)
jaup.mets$`30-Day Low Flow (cfs/sq mi)`[2] <- round(mean(jaup.mets.15$`30-Day Low Flow (cfs)`), 2)
jaup.mets$`90-Day Low Flow (cfs/sq mi)`[2] <- round(mean(jaup.mets.15$`90-Day Low Flow (cfs)`), 2)
jaup.mets$`August Low Flow (cfs/sq mi)`[2] <- round(mean(jaup.mets.15$`August Low Flow (cfs)`), 2)
jaup.mets$`September 10% Flow (cfs/sq mi)`[2] <- round(mean(jaup.mets.15$`September 10% Flow (cfs)`), 2)
jaup.mets$`Overall Mean (cfs/sq mi)`[3] <- round(mean(jaup.mets.14$`Overall Mean (cfs)`), 2)
jaup.mets$`30-Day Low Flow (cfs/sq mi)`[3] <- round(mean(jaup.mets.14$`30-Day Low Flow (cfs)`), 2)
jaup.mets$`90-Day Low Flow (cfs/sq mi)`[3] <- round(mean(jaup.mets.14$`90-Day Low Flow (cfs)`), 2)
jaup.mets$`August Low Flow (cfs/sq mi)`[3] <- round(mean(jaup.mets.14$`August Low Flow (cfs)`), 2)
jaup.mets$`September 10% Flow (cfs/sq mi)`[3] <- round(mean(jaup.mets.14$`September 10% Flow (cfs)`), 2)
jaup.mets$`Overall Mean (cfs/sq mi)`[4] <- round(mean(jaup.mets.16$`Overall Mean (cfs)`), 2)
jaup.mets$`30-Day Low Flow (cfs/sq mi)`[4] <- round(mean(jaup.mets.16$`30-Day Low Flow (cfs)`), 2)
jaup.mets$`90-Day Low Flow (cfs/sq mi)`[4] <- round(mean(jaup.mets.16$`90-Day Low Flow (cfs)`), 2)
jaup.mets$`August Low Flow (cfs/sq mi)`[4] <- round(mean(jaup.mets.16$`August Low Flow (cfs)`), 2)
jaup.mets$`September 10% Flow (cfs/sq mi)`[4] <- round(mean(jaup.mets.16$`September 10% Flow (cfs)`), 2)

jami.mets <- data.frame(matrix(data = NA, nrow = 4, ncol = 6))
colnames(jami.mets) <- c('Scenario', 'Overall Mean (cfs/sq mi)', '30-Day Low Flow (cfs/sq mi)', '90-Day Low Flow (cfs/sq mi)',
                         'August Low Flow (cfs/sq mi)', 'September 10% Flow (cfs/sq mi)')
jami.mets$Scenario <- c('Base', 'ccP10T10', 'ccP50T50', 'ccP90T90')
jami.mets$`Overall Mean (cfs/sq mi)`[1] <- round(mean(jami.mets.11$`Overall Mean (cfs)`), 2)
jami.mets$`30-Day Low Flow (cfs/sq mi)`[1] <- round(mean(jami.mets.11$`30-Day Low Flow (cfs)`), 2)
jami.mets$`90-Day Low Flow (cfs/sq mi)`[1] <- round(mean(jami.mets.11$`90-Day Low Flow (cfs)`), 2)
jami.mets$`August Low Flow (cfs/sq mi)`[1] <- round(mean(jami.mets.11$`August Low Flow (cfs)`), 2)
jami.mets$`September 10% Flow (cfs/sq mi)`[1] <- round(mean(jami.mets.11$`September 10% Flow (cfs)`), 2)
jami.mets$`Overall Mean (cfs/sq mi)`[2] <- round(mean(jami.mets.15$`Overall Mean (cfs)`), 2)
jami.mets$`30-Day Low Flow (cfs/sq mi)`[2] <- round(mean(jami.mets.15$`30-Day Low Flow (cfs)`), 2)
jami.mets$`90-Day Low Flow (cfs/sq mi)`[2] <- round(mean(jami.mets.15$`90-Day Low Flow (cfs)`), 2)
jami.mets$`August Low Flow (cfs/sq mi)`[2] <- round(mean(jami.mets.15$`August Low Flow (cfs)`), 2)
jami.mets$`September 10% Flow (cfs/sq mi)`[2] <- round(mean(jami.mets.15$`September 10% Flow (cfs)`), 2)
jami.mets$`Overall Mean (cfs/sq mi)`[3] <- round(mean(jami.mets.14$`Overall Mean (cfs)`), 2)
jami.mets$`30-Day Low Flow (cfs/sq mi)`[3] <- round(mean(jami.mets.14$`30-Day Low Flow (cfs)`), 2)
jami.mets$`90-Day Low Flow (cfs/sq mi)`[3] <- round(mean(jami.mets.14$`90-Day Low Flow (cfs)`), 2)
jami.mets$`August Low Flow (cfs/sq mi)`[3] <- round(mean(jami.mets.14$`August Low Flow (cfs)`), 2)
jami.mets$`September 10% Flow (cfs/sq mi)`[3] <- round(mean(jami.mets.14$`September 10% Flow (cfs)`), 2)
jami.mets$`Overall Mean (cfs/sq mi)`[4] <- round(mean(jami.mets.16$`Overall Mean (cfs)`), 2)
jami.mets$`30-Day Low Flow (cfs/sq mi)`[4] <- round(mean(jami.mets.16$`30-Day Low Flow (cfs)`), 2)
jami.mets$`90-Day Low Flow (cfs/sq mi)`[4] <- round(mean(jami.mets.16$`90-Day Low Flow (cfs)`), 2)
jami.mets$`August Low Flow (cfs/sq mi)`[4] <- round(mean(jami.mets.16$`August Low Flow (cfs)`), 2)
jami.mets$`September 10% Flow (cfs/sq mi)`[4] <- round(mean(jami.mets.16$`September 10% Flow (cfs)`), 2)

appo.mets <- data.frame(matrix(data = NA, nrow = 4, ncol = 6))
colnames(appo.mets) <- c('Scenario', 'Overall Mean (cfs/sq mi)', '30-Day Low Flow (cfs/sq mi)', '90-Day Low Flow (cfs/sq mi)',
                         'August Low Flow (cfs/sq mi)', 'September 10% Flow (cfs/sq mi)')
appo.mets$Scenario <- c('Base', 'ccP10T10', 'ccP50T50', 'ccP90T90')
appo.mets$`Overall Mean (cfs/sq mi)`[1] <- round(mean(appo.mets.11$`Overall Mean (cfs)`), 2)
appo.mets$`30-Day Low Flow (cfs/sq mi)`[1] <- round(mean(appo.mets.11$`30-Day Low Flow (cfs)`), 2)
appo.mets$`90-Day Low Flow (cfs/sq mi)`[1] <- round(mean(appo.mets.11$`90-Day Low Flow (cfs)`), 2)
appo.mets$`August Low Flow (cfs/sq mi)`[1] <- round(mean(appo.mets.11$`August Low Flow (cfs)`), 2)
appo.mets$`September 10% Flow (cfs/sq mi)`[1] <- round(mean(appo.mets.11$`September 10% Flow (cfs)`), 2)
appo.mets$`Overall Mean (cfs/sq mi)`[2] <- round(mean(appo.mets.15$`Overall Mean (cfs)`), 2)
appo.mets$`30-Day Low Flow (cfs/sq mi)`[2] <- round(mean(appo.mets.15$`30-Day Low Flow (cfs)`), 2)
appo.mets$`90-Day Low Flow (cfs/sq mi)`[2] <- round(mean(appo.mets.15$`90-Day Low Flow (cfs)`), 2)
appo.mets$`August Low Flow (cfs/sq mi)`[2] <- round(mean(appo.mets.15$`August Low Flow (cfs)`), 2)
appo.mets$`September 10% Flow (cfs/sq mi)`[2] <- round(mean(appo.mets.15$`September 10% Flow (cfs)`), 2)
appo.mets$`Overall Mean (cfs/sq mi)`[3] <- round(mean(appo.mets.14$`Overall Mean (cfs)`), 2)
appo.mets$`30-Day Low Flow (cfs/sq mi)`[3] <- round(mean(appo.mets.14$`30-Day Low Flow (cfs)`), 2)
appo.mets$`90-Day Low Flow (cfs/sq mi)`[3] <- round(mean(appo.mets.14$`90-Day Low Flow (cfs)`), 2)
appo.mets$`August Low Flow (cfs/sq mi)`[3] <- round(mean(appo.mets.14$`August Low Flow (cfs)`), 2)
appo.mets$`September 10% Flow (cfs/sq mi)`[3] <- round(mean(appo.mets.14$`September 10% Flow (cfs)`), 2)
appo.mets$`Overall Mean (cfs/sq mi)`[4] <- round(mean(appo.mets.16$`Overall Mean (cfs)`), 2)
appo.mets$`30-Day Low Flow (cfs/sq mi)`[4] <- round(mean(appo.mets.16$`30-Day Low Flow (cfs)`), 2)
appo.mets$`90-Day Low Flow (cfs/sq mi)`[4] <- round(mean(appo.mets.16$`90-Day Low Flow (cfs)`), 2)
appo.mets$`August Low Flow (cfs/sq mi)`[4] <- round(mean(appo.mets.16$`August Low Flow (cfs)`), 2)
appo.mets$`September 10% Flow (cfs/sq mi)`[4] <- round(mean(appo.mets.16$`September 10% Flow (cfs)`), 2)

kable(shen.mets,  booktabs = T,
      caption = "Flow Metrics (cfs/sq mi) in Shenandoah River Basin",
      label = "allshenmets",
      col.names = colnames(shen.mets)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("shen.mets",file_ext,sep=""))

kable(matt.mets,  booktabs = T,
      caption = "Flow Metrics (cfs/sq mi) in Mattaponi River Basin",
      label = "allmattmets",
      col.names = colnames(matt.mets)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("matt.mets",file_ext,sep=""))

kable(pamu.mets,  booktabs = T,
      caption = "Flow Metrics (cfs/sq mi) in Pamunkey River Basin",
      label = "allpamumets",
      col.names = colnames(pamu.mets)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("pamu.mets",file_ext,sep=""))

kable(rapp.mets,  booktabs = T,
      caption = "Flow Metrics (cfs/sq mi) in Rappohannock River Basin",
      label = "allrappmets",
      col.names = colnames(rapp.mets)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("rapp.mets",file_ext,sep=""))

kable(jaup.mets,  booktabs = T,
      caption = "Flow Metrics (cfs/sq mi) in Upper James River Basin",
      label = "alljaupmets",
      col.names = colnames(jaup.mets)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("jaup.mets",file_ext,sep=""))

kable(jami.mets,  booktabs = T,
      caption = "Flow Metrics (cfs/sq mi) in Middle James River Basin",
      label = "alljamimets",
      col.names = colnames(jami.mets)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("jami.mets",file_ext,sep=""))

kable(appo.mets,  booktabs = T,
      caption = "Flow Metrics (cfs/sq mi) in Appomattox River Basin",
      label = "allappomets",
      col.names = colnames(appo.mets)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("appo.mets",file_ext,sep=""))

# METRICS FOR SPECIFIC SEGMENTS ----
#amherst
riv.seg <- 'JL2_7240_7350'
dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))

data.namer <- paste0("qout_", riv.seg)
all.data <- get(data.namer)

data.11 <- data.frame(dates, all.data$data11.flow)
colnames(data.11) <- c('date', 'flow')
data.14 <- data.frame(dates, all.data$data14.flow)
colnames(data.14) <- c('date', 'flow')
data.15 <- data.frame(dates, all.data$data15.flow)
colnames(data.15) <- c('date', 'flow')
data.16 <- data.frame(dates, all.data$data16.flow)
colnames(data.16) <- c('date', 'flow')

amhe.mets <- data.frame(matrix(data = NA, nrow = 4, ncol = 6))
colnames(amhe.mets) <- c('Scenario', 'Overall Mean (cfs)', '30-Day Low Flow (cfs)', '90-Day Low Flow (cfs)',
                         'August Low Flow (cfs)', 'September 10% Flow (cfs)')
amhe.mets$Scenario <- c('Base', 'ccP10T10', 'ccP50T50', 'ccP90T90')
amhe.mets$`Overall Mean (cfs)`[1] <- round(overall_mean_flow(data.11), 3)
amhe.mets$`30-Day Low Flow (cfs)`[1] <- round(num_day_min(data.11, num.day = 30, min_or_med = "min"), 3)
amhe.mets$`90-Day Low Flow (cfs)`[1] <- round(num_day_min(data.11, num.day = 90, min_or_med = "min"), 3)
amhe.mets$`August Low Flow (cfs)`[1] <- round(monthly_min(data.11, num.month = 8), 3)
amhe.mets$`September 10% Flow (cfs)`[1] <- round(sept_10_flow(data.11), 3)
amhe.mets$`Overall Mean (cfs)`[2] <- round(overall_mean_flow(data.15), 3)
amhe.mets$`30-Day Low Flow (cfs)`[2] <- round(num_day_min(data.15, num.day = 30, min_or_med = "min"), 3)
amhe.mets$`90-Day Low Flow (cfs)`[2] <- round(num_day_min(data.15, num.day = 90, min_or_med = "min"), 3)
amhe.mets$`August Low Flow (cfs)`[2] <- round(monthly_min(data.15, num.month = 8), 3)
amhe.mets$`September 10% Flow (cfs)`[2] <- round(sept_10_flow(data.15), 3)
amhe.mets$`Overall Mean (cfs)`[3] <- round(overall_mean_flow(data.14), 3)
amhe.mets$`30-Day Low Flow (cfs)`[3] <- round(num_day_min(data.14, num.day = 30, min_or_med = "min"), 3)
amhe.mets$`90-Day Low Flow (cfs)`[3] <- round(num_day_min(data.14, num.day = 90, min_or_med = "min"), 3)
amhe.mets$`August Low Flow (cfs)`[3] <- round(monthly_min(data.14, num.month = 8), 3)
amhe.mets$`September 10% Flow (cfs)`[3] <- round(sept_10_flow(data.14), 3)
amhe.mets$`Overall Mean (cfs)`[4] <- round(overall_mean_flow(data.16), 3)
amhe.mets$`30-Day Low Flow (cfs)`[4] <- round(num_day_min(data.16, num.day = 30, min_or_med = "min"), 3)
amhe.mets$`90-Day Low Flow (cfs)`[4] <- round(num_day_min(data.16, num.day = 90, min_or_med = "min"), 3)
amhe.mets$`August Low Flow (cfs)`[4] <- round(monthly_min(data.16, num.month = 8), 3)
amhe.mets$`September 10% Flow (cfs)`[4] <- round(sept_10_flow(data.16), 3)

#harrisonburg
riv.seg <- 'PS0_6150_6160'
dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))

data.namer <- paste0("qout_", riv.seg)
all.data <- get(data.namer)

data.11 <- data.frame(dates, all.data$data11.flow)
colnames(data.11) <- c('date', 'flow')
data.14 <- data.frame(dates, all.data$data14.flow)
colnames(data.14) <- c('date', 'flow')
data.15 <- data.frame(dates, all.data$data15.flow)
colnames(data.15) <- c('date', 'flow')
data.16 <- data.frame(dates, all.data$data16.flow)
colnames(data.16) <- c('date', 'flow')

harr.mets <- data.frame(matrix(data = NA, nrow = 4, ncol = 6))
colnames(harr.mets) <- c('Scenario', 'Overall Mean (cfs)', '30-Day Low Flow (cfs)', '90-Day Low Flow (cfs)',
                         'August Low Flow (cfs)', 'September 10% Flow (cfs)')
harr.mets$Scenario <- c('Base', 'ccP10T10', 'ccP50T50', 'ccP90T90')
harr.mets$`Overall Mean (cfs)`[1] <- round(overall_mean_flow(data.11), 3)
harr.mets$`30-Day Low Flow (cfs)`[1] <- round(num_day_min(data.11, num.day = 30, min_or_med = "min"), 3)
harr.mets$`90-Day Low Flow (cfs)`[1] <- round(num_day_min(data.11, num.day = 90, min_or_med = "min"), 3)
harr.mets$`August Low Flow (cfs)`[1] <- round(monthly_min(data.11, num.month = 8), 3)
harr.mets$`September 10% Flow (cfs)`[1] <- round(sept_10_flow(data.11), 3)
harr.mets$`Overall Mean (cfs)`[2] <- round(overall_mean_flow(data.15), 3)
harr.mets$`30-Day Low Flow (cfs)`[2] <- round(num_day_min(data.15, num.day = 30, min_or_med = "min"), 3)
harr.mets$`90-Day Low Flow (cfs)`[2] <- round(num_day_min(data.15, num.day = 90, min_or_med = "min"), 3)
harr.mets$`August Low Flow (cfs)`[2] <- round(monthly_min(data.15, num.month = 8), 3)
harr.mets$`September 10% Flow (cfs)`[2] <- round(sept_10_flow(data.15), 3)
harr.mets$`Overall Mean (cfs)`[3] <- round(overall_mean_flow(data.14), 3)
harr.mets$`30-Day Low Flow (cfs)`[3] <- round(num_day_min(data.14, num.day = 30, min_or_med = "min"), 3)
harr.mets$`90-Day Low Flow (cfs)`[3] <- round(num_day_min(data.14, num.day = 90, min_or_med = "min"), 3)
harr.mets$`August Low Flow (cfs)`[3] <- round(monthly_min(data.14, num.month = 8), 3)
harr.mets$`September 10% Flow (cfs)`[3] <- round(sept_10_flow(data.14), 3)
harr.mets$`Overall Mean (cfs)`[4] <- round(overall_mean_flow(data.16), 3)
harr.mets$`30-Day Low Flow (cfs)`[4] <- round(num_day_min(data.16, num.day = 30, min_or_med = "min"), 3)
harr.mets$`90-Day Low Flow (cfs)`[4] <- round(num_day_min(data.16, num.day = 90, min_or_med = "min"), 3)
harr.mets$`August Low Flow (cfs)`[4] <- round(monthly_min(data.16, num.month = 8), 3)
harr.mets$`September 10% Flow (cfs)`[4] <- round(sept_10_flow(data.16), 3)

#giles
riv.seg <- 'JU1_7630_7490'
dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))

data.namer <- paste0("qout_", riv.seg)
all.data <- get(data.namer)

data.11 <- data.frame(dates, all.data$data11.flow)
colnames(data.11) <- c('date', 'flow')
data.14 <- data.frame(dates, all.data$data14.flow)
colnames(data.14) <- c('date', 'flow')
data.15 <- data.frame(dates, all.data$data15.flow)
colnames(data.15) <- c('date', 'flow')
data.16 <- data.frame(dates, all.data$data16.flow)
colnames(data.16) <- c('date', 'flow')

gile.mets <- data.frame(matrix(data = NA, nrow = 4, ncol = 6))
colnames(gile.mets) <- c('Scenario', 'Overall Mean (cfs)', '30-Day Low Flow (cfs)', '90-Day Low Flow (cfs)',
                         'August Low Flow (cfs)', 'September 10% Flow (cfs)')
gile.mets$Scenario <- c('Base', 'ccP10T10', 'ccP50T50', 'ccP90T90')
gile.mets$`Overall Mean (cfs)`[1] <- round(overall_mean_flow(data.11), 3)
gile.mets$`30-Day Low Flow (cfs)`[1] <- round(num_day_min(data.11, num.day = 30, min_or_med = "min"), 3)
gile.mets$`90-Day Low Flow (cfs)`[1] <- round(num_day_min(data.11, num.day = 90, min_or_med = "min"), 3)
gile.mets$`August Low Flow (cfs)`[1] <- round(monthly_min(data.11, num.month = 8), 3)
gile.mets$`September 10% Flow (cfs)`[1] <- round(sept_10_flow(data.11), 3)
gile.mets$`Overall Mean (cfs)`[2] <- round(overall_mean_flow(data.15), 3)
gile.mets$`30-Day Low Flow (cfs)`[2] <- round(num_day_min(data.15, num.day = 30, min_or_med = "min"), 3)
gile.mets$`90-Day Low Flow (cfs)`[2] <- round(num_day_min(data.15, num.day = 90, min_or_med = "min"), 3)
gile.mets$`August Low Flow (cfs)`[2] <- round(monthly_min(data.15, num.month = 8), 3)
gile.mets$`September 10% Flow (cfs)`[2] <- round(sept_10_flow(data.15), 3)
gile.mets$`Overall Mean (cfs)`[3] <- round(overall_mean_flow(data.14), 3)
gile.mets$`30-Day Low Flow (cfs)`[3] <- round(num_day_min(data.14, num.day = 30, min_or_med = "min"), 3)
gile.mets$`90-Day Low Flow (cfs)`[3] <- round(num_day_min(data.14, num.day = 90, min_or_med = "min"), 3)
gile.mets$`August Low Flow (cfs)`[3] <- round(monthly_min(data.14, num.month = 8), 3)
gile.mets$`September 10% Flow (cfs)`[3] <- round(sept_10_flow(data.14), 3)
gile.mets$`Overall Mean (cfs)`[4] <- round(overall_mean_flow(data.16), 3)
gile.mets$`30-Day Low Flow (cfs)`[4] <- round(num_day_min(data.16, num.day = 30, min_or_med = "min"), 3)
gile.mets$`90-Day Low Flow (cfs)`[4] <- round(num_day_min(data.16, num.day = 90, min_or_med = "min"), 3)
gile.mets$`August Low Flow (cfs)`[4] <- round(monthly_min(data.16, num.month = 8), 3)
gile.mets$`September 10% Flow (cfs)`[4] <- round(sept_10_flow(data.16), 3)

#culpeper
riv.seg <- 'RU3_5610_5640'
dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))

data.namer <- paste0("qout_", riv.seg)
all.data <- get(data.namer)

data.11 <- data.frame(dates, all.data$data11.flow)
colnames(data.11) <- c('date', 'flow')
data.14 <- data.frame(dates, all.data$data14.flow)
colnames(data.14) <- c('date', 'flow')
data.15 <- data.frame(dates, all.data$data15.flow)
colnames(data.15) <- c('date', 'flow')
data.16 <- data.frame(dates, all.data$data16.flow)
colnames(data.16) <- c('date', 'flow')

culp.mets <- data.frame(matrix(data = NA, nrow = 4, ncol = 6))
colnames(culp.mets) <- c('Scenario', 'Overall Mean (cfs)', '30-Day Low Flow (cfs)', '90-Day Low Flow (cfs)',
                         'August Low Flow (cfs)', 'September 10% Flow (cfs)')
culp.mets$Scenario <- c('Base', 'ccP10T10', 'ccP50T50', 'ccP90T90')
culp.mets$`Overall Mean (cfs)`[1] <- round(overall_mean_flow(data.11), 3)
culp.mets$`30-Day Low Flow (cfs)`[1] <- round(num_day_min(data.11, num.day = 30, min_or_med = "min"), 3)
culp.mets$`90-Day Low Flow (cfs)`[1] <- round(num_day_min(data.11, num.day = 90, min_or_med = "min"), 3)
culp.mets$`August Low Flow (cfs)`[1] <- round(monthly_min(data.11, num.month = 8), 3)
culp.mets$`September 10% Flow (cfs)`[1] <- round(sept_10_flow(data.11), 3)
culp.mets$`Overall Mean (cfs)`[2] <- round(overall_mean_flow(data.15), 3)
culp.mets$`30-Day Low Flow (cfs)`[2] <- round(num_day_min(data.15, num.day = 30, min_or_med = "min"), 3)
culp.mets$`90-Day Low Flow (cfs)`[2] <- round(num_day_min(data.15, num.day = 90, min_or_med = "min"), 3)
culp.mets$`August Low Flow (cfs)`[2] <- round(monthly_min(data.15, num.month = 8), 3)
culp.mets$`September 10% Flow (cfs)`[2] <- round(sept_10_flow(data.15), 3)
culp.mets$`Overall Mean (cfs)`[3] <- round(overall_mean_flow(data.14), 3)
culp.mets$`30-Day Low Flow (cfs)`[3] <- round(num_day_min(data.14, num.day = 30, min_or_med = "min"), 3)
culp.mets$`90-Day Low Flow (cfs)`[3] <- round(num_day_min(data.14, num.day = 90, min_or_med = "min"), 3)
culp.mets$`August Low Flow (cfs)`[3] <- round(monthly_min(data.14, num.month = 8), 3)
culp.mets$`September 10% Flow (cfs)`[3] <- round(sept_10_flow(data.14), 3)
culp.mets$`Overall Mean (cfs)`[4] <- round(overall_mean_flow(data.16), 3)
culp.mets$`30-Day Low Flow (cfs)`[4] <- round(num_day_min(data.16, num.day = 30, min_or_med = "min"), 3)
culp.mets$`90-Day Low Flow (cfs)`[4] <- round(num_day_min(data.16, num.day = 90, min_or_med = "min"), 3)
culp.mets$`August Low Flow (cfs)`[4] <- round(monthly_min(data.16, num.month = 8), 3)
culp.mets$`September 10% Flow (cfs)`[4] <- round(sept_10_flow(data.16), 3)

#highland
riv.seg <- 'JU1_6300_6650'
dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))

data.namer <- paste0("qout_", riv.seg)
all.data <- get(data.namer)

data.11 <- data.frame(dates, all.data$data11.flow)
colnames(data.11) <- c('date', 'flow')
data.14 <- data.frame(dates, all.data$data14.flow)
colnames(data.14) <- c('date', 'flow')
data.15 <- data.frame(dates, all.data$data15.flow)
colnames(data.15) <- c('date', 'flow')
data.16 <- data.frame(dates, all.data$data16.flow)
colnames(data.16) <- c('date', 'flow')

high.mets <- data.frame(matrix(data = NA, nrow = 4, ncol = 6))
colnames(high.mets) <- c('Scenario', 'Overall Mean (cfs)', '30-Day Low Flow (cfs)', '90-Day Low Flow (cfs)',
                         'August Low Flow (cfs)', 'September 10% Flow (cfs)')
high.mets$Scenario <- c('Base', 'ccP10T10', 'ccP50T50', 'ccP90T90')
high.mets$`Overall Mean (cfs)`[1] <- round(overall_mean_flow(data.11), 3)
high.mets$`30-Day Low Flow (cfs)`[1] <- round(num_day_min(data.11, num.day = 30, min_or_med = "min"), 3)
high.mets$`90-Day Low Flow (cfs)`[1] <- round(num_day_min(data.11, num.day = 90, min_or_med = "min"), 3)
high.mets$`August Low Flow (cfs)`[1] <- round(monthly_min(data.11, num.month = 8), 3)
high.mets$`September 10% Flow (cfs)`[1] <- round(sept_10_flow(data.11), 3)
high.mets$`Overall Mean (cfs)`[2] <- round(overall_mean_flow(data.15), 3)
high.mets$`30-Day Low Flow (cfs)`[2] <- round(num_day_min(data.15, num.day = 30, min_or_med = "min"), 3)
high.mets$`90-Day Low Flow (cfs)`[2] <- round(num_day_min(data.15, num.day = 90, min_or_med = "min"), 3)
high.mets$`August Low Flow (cfs)`[2] <- round(monthly_min(data.15, num.month = 8), 3)
high.mets$`September 10% Flow (cfs)`[2] <- round(sept_10_flow(data.15), 3)
high.mets$`Overall Mean (cfs)`[3] <- round(overall_mean_flow(data.14), 3)
high.mets$`30-Day Low Flow (cfs)`[3] <- round(num_day_min(data.14, num.day = 30, min_or_med = "min"), 3)
high.mets$`90-Day Low Flow (cfs)`[3] <- round(num_day_min(data.14, num.day = 90, min_or_med = "min"), 3)
high.mets$`August Low Flow (cfs)`[3] <- round(monthly_min(data.14, num.month = 8), 3)
high.mets$`September 10% Flow (cfs)`[3] <- round(sept_10_flow(data.14), 3)
high.mets$`Overall Mean (cfs)`[4] <- round(overall_mean_flow(data.16), 3)
high.mets$`30-Day Low Flow (cfs)`[4] <- round(num_day_min(data.16, num.day = 30, min_or_med = "min"), 3)
high.mets$`90-Day Low Flow (cfs)`[4] <- round(num_day_min(data.16, num.day = 90, min_or_med = "min"), 3)
high.mets$`August Low Flow (cfs)`[4] <- round(monthly_min(data.16, num.month = 8), 3)
high.mets$`September 10% Flow (cfs)`[4] <- round(sept_10_flow(data.16), 3)

#nottoway
riv.seg <- 'JA1_7600_7570'
dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))

data.namer <- paste0("qout_", riv.seg)
all.data <- get(data.namer)

data.11 <- data.frame(dates, all.data$data11.flow)
colnames(data.11) <- c('date', 'flow')
data.14 <- data.frame(dates, all.data$data14.flow)
colnames(data.14) <- c('date', 'flow')
data.15 <- data.frame(dates, all.data$data15.flow)
colnames(data.15) <- c('date', 'flow')
data.16 <- data.frame(dates, all.data$data16.flow)
colnames(data.16) <- c('date', 'flow')

nott.mets <- data.frame(matrix(data = NA, nrow = 4, ncol = 6))
colnames(nott.mets) <- c('Scenario', 'Overall Mean (cfs)', '30-Day Low Flow (cfs)', '90-Day Low Flow (cfs)',
                         'August Low Flow (cfs)', 'September 10% Flow (cfs)')
nott.mets$Scenario <- c('Base', 'ccP10T10', 'ccP50T50', 'ccP90T90')
nott.mets$`Overall Mean (cfs)`[1] <- round(overall_mean_flow(data.11), 3)
nott.mets$`30-Day Low Flow (cfs)`[1] <- round(num_day_min(data.11, num.day = 30, min_or_med = "min"), 3)
nott.mets$`90-Day Low Flow (cfs)`[1] <- round(num_day_min(data.11, num.day = 90, min_or_med = "min"), 3)
nott.mets$`August Low Flow (cfs)`[1] <- round(monthly_min(data.11, num.month = 8), 3)
nott.mets$`September 10% Flow (cfs)`[1] <- round(sept_10_flow(data.11), 3)
nott.mets$`Overall Mean (cfs)`[2] <- round(overall_mean_flow(data.15), 3)
nott.mets$`30-Day Low Flow (cfs)`[2] <- round(num_day_min(data.15, num.day = 30, min_or_med = "min"), 3)
nott.mets$`90-Day Low Flow (cfs)`[2] <- round(num_day_min(data.15, num.day = 90, min_or_med = "min"), 3)
nott.mets$`August Low Flow (cfs)`[2] <- round(monthly_min(data.15, num.month = 8), 3)
nott.mets$`September 10% Flow (cfs)`[2] <- round(sept_10_flow(data.15), 3)
nott.mets$`Overall Mean (cfs)`[3] <- round(overall_mean_flow(data.14), 3)
nott.mets$`30-Day Low Flow (cfs)`[3] <- round(num_day_min(data.14, num.day = 30, min_or_med = "min"), 3)
nott.mets$`90-Day Low Flow (cfs)`[3] <- round(num_day_min(data.14, num.day = 90, min_or_med = "min"), 3)
nott.mets$`August Low Flow (cfs)`[3] <- round(monthly_min(data.14, num.month = 8), 3)
nott.mets$`September 10% Flow (cfs)`[3] <- round(sept_10_flow(data.14), 3)
nott.mets$`Overall Mean (cfs)`[4] <- round(overall_mean_flow(data.16), 3)
nott.mets$`30-Day Low Flow (cfs)`[4] <- round(num_day_min(data.16, num.day = 30, min_or_med = "min"), 3)
nott.mets$`90-Day Low Flow (cfs)`[4] <- round(num_day_min(data.16, num.day = 90, min_or_med = "min"), 3)
nott.mets$`August Low Flow (cfs)`[4] <- round(monthly_min(data.16, num.month = 8), 3)
nott.mets$`September 10% Flow (cfs)`[4] <- round(sept_10_flow(data.16), 3)

kable(amhe.mets,  booktabs = T,
      caption = "Flow Metrics (cfs) in Buffalo River Basin",
      label = "allamhemets",
      col.names = colnames(amhe.mets)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("amhe.mets",file_ext,sep=""))

kable(harr.mets,  booktabs = T,
      caption = "Flow Metrics (cfs) in Blacks Run Basin",
      label = "allharrmets",
      col.names = colnames(harr.mets)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("harr.mets",file_ext,sep=""))

kable(gile.mets,  booktabs = T,
      caption = "Flow Metrics (cfs) in Johns Creek Basin",
      label = "allgilemets",
      col.names = colnames(gile.mets)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("gile.mets",file_ext,sep=""))

kable(culp.mets,  booktabs = T,
      caption = "Flow Metrics (cfs) in Hazel River Basin",
      label = "allculpmets",
      col.names = colnames(culp.mets)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("culp.mets",file_ext,sep=""))

kable(high.mets,  booktabs = T,
      caption = "Flow Metrics (cfs) in Bullpasture River Basin",
      label = "allhighmets",
      col.names = colnames(high.mets)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("high.mets",file_ext,sep=""))

kable(nott.mets,  booktabs = T,
      caption = "Flow Metrics (cfs) in West Creek Basin",
      label = "allnottmets",
      col.names = colnames(nott.mets)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("nott.mets",file_ext,sep=""))

library(gridExtra)
save <- grid.arrange(amhe.myplot, gile.myplot, high.myplot, harr.myplot, culp.myplot, nott.myplot, nrow = 2)
ggsave('juri_qout.png', plot = save, width = 12, height = 7, units = 'in', dpi = 450)

# percent diffs
amhe.diffs <- data.frame(matrix(data = NA, nrow = 3, ncol = 6))
colnames(amhe.diffs) <- c('Scenario', 'Overall Mean (%)', '30-Day Low Flow (%)',
                            '90-Day Low Flow (%)', 'August Low Flow (%)',
                            'September 10% Flow (%)')
amhe.diffs$Scenario <- c('ccP10T10', 'ccP50T50', 'ccP90T90')
amhe.diffs[1,2:6] <- round((amhe.mets[2,2:6]-amhe.mets[1,2:6])/amhe.mets[1,2:6]*100, 2)
amhe.diffs[2,2:6] <- round((amhe.mets[3,2:6]-amhe.mets[1,2:6])/amhe.mets[1,2:6]*100, 2)
amhe.diffs[3,2:6] <- round((amhe.mets[4,2:6]-amhe.mets[1,2:6])/amhe.mets[1,2:6]*100, 2)

harr.diffs <- data.frame(matrix(data = NA, nrow = 3, ncol = 6))
colnames(harr.diffs) <- c('Scenario', 'Overall Mean (%)', '30-Day Low Flow (%)',
                          '90-Day Low Flow (%)', 'August Low Flow (%)',
                          'September 10% Flow (%)')
harr.diffs$Scenario <- c('ccP10T10', 'ccP50T50', 'ccP90T90')
harr.diffs[1,2:6] <- round((harr.mets[2,2:6]-harr.mets[1,2:6])/harr.mets[1,2:6]*100, 2)
harr.diffs[2,2:6] <- round((harr.mets[3,2:6]-harr.mets[1,2:6])/harr.mets[1,2:6]*100, 2)
harr.diffs[3,2:6] <- round((harr.mets[4,2:6]-harr.mets[1,2:6])/harr.mets[1,2:6]*100, 2)

gile.diffs <- data.frame(matrix(data = NA, nrow = 3, ncol = 6))
colnames(gile.diffs) <- c('Scenario', 'Overall Mean (%)', '30-Day Low Flow (%)',
                          '90-Day Low Flow (%)', 'August Low Flow (%)',
                          'September 10% Flow (%)')
gile.diffs$Scenario <- c('ccP10T10', 'ccP50T50', 'ccP90T90')
gile.diffs[1,2:6] <- round((gile.mets[2,2:6]-gile.mets[1,2:6])/gile.mets[1,2:6]*100, 2)
gile.diffs[2,2:6] <- round((gile.mets[3,2:6]-gile.mets[1,2:6])/gile.mets[1,2:6]*100, 2)
gile.diffs[3,2:6] <- round((gile.mets[4,2:6]-gile.mets[1,2:6])/gile.mets[1,2:6]*100, 2)

culp.diffs <- data.frame(matrix(data = NA, nrow = 3, ncol = 6))
colnames(culp.diffs) <- c('Scenario', 'Overall Mean (%)', '30-Day Low Flow (%)',
                          '90-Day Low Flow (%)', 'August Low Flow (%)',
                          'September 10% Flow (%)')
culp.diffs$Scenario <- c('ccP10T10', 'ccP50T50', 'ccP90T90')
culp.diffs[1,2:6] <- round((culp.mets[2,2:6]-culp.mets[1,2:6])/culp.mets[1,2:6]*100, 2)
culp.diffs[2,2:6] <- round((culp.mets[3,2:6]-culp.mets[1,2:6])/culp.mets[1,2:6]*100, 2)
culp.diffs[3,2:6] <- round((culp.mets[4,2:6]-culp.mets[1,2:6])/culp.mets[1,2:6]*100, 2)

high.diffs <- data.frame(matrix(data = NA, nrow = 3, ncol = 6))
colnames(high.diffs) <- c('Scenario', 'Overall Mean (%)', '30-Day Low Flow (%)',
                          '90-Day Low Flow (%)', 'August Low Flow (%)',
                          'September 10% Flow (%)')
high.diffs$Scenario <- c('ccP10T10', 'ccP50T50', 'ccP90T90')
high.diffs[1,2:6] <- round((high.mets[2,2:6]-high.mets[1,2:6])/high.mets[1,2:6]*100, 2)
high.diffs[2,2:6] <- round((high.mets[3,2:6]-high.mets[1,2:6])/high.mets[1,2:6]*100, 2)
high.diffs[3,2:6] <- round((high.mets[4,2:6]-high.mets[1,2:6])/high.mets[1,2:6]*100, 2)

nott.diffs <- data.frame(matrix(data = NA, nrow = 3, ncol = 6))
colnames(nott.diffs) <- c('Scenario', 'Overall Mean (%)', '30-Day Low Flow (%)',
                          '90-Day Low Flow (%)', 'August Low Flow (%)',
                          'September 10% Flow (%)')
nott.diffs$Scenario <- c('ccP10T10', 'ccP50T50', 'ccP90T90')
nott.diffs[1,2:6] <- round((nott.mets[2,2:6]-nott.mets[1,2:6])/nott.mets[1,2:6]*100, 2)
nott.diffs[2,2:6] <- round((nott.mets[3,2:6]-nott.mets[1,2:6])/nott.mets[1,2:6]*100, 2)
nott.diffs[3,2:6] <- round((nott.mets[4,2:6]-nott.mets[1,2:6])/nott.mets[1,2:6]*100, 2)

# NEW
shen.diffs <- data.frame(matrix(data = NA, nrow = 3, ncol = 6))
colnames(shen.diffs) <- c('Scenario', 'Overall Mean (%)', '30-Day Low Flow (%)',
                          '90-Day Low Flow (%)', 'August Low Flow (%)',
                          'September 10% Flow (%)')
shen.diffs$Scenario <- c('ccP10T10', 'ccP50T50', 'ccP90T90')
shen.diffs[1,2:6] <- round((shen.mets[2,2:6]-shen.mets[1,2:6])/shen.mets[1,2:6]*100, 2)
shen.diffs[2,2:6] <- round((shen.mets[3,2:6]-shen.mets[1,2:6])/shen.mets[1,2:6]*100, 2)
shen.diffs[3,2:6] <- round((shen.mets[4,2:6]-shen.mets[1,2:6])/shen.mets[1,2:6]*100, 2)

matt.diffs <- data.frame(matrix(data = NA, nrow = 3, ncol = 6))
colnames(matt.diffs) <- c('Scenario', 'Overall Mean (%)', '30-Day Low Flow (%)',
                          '90-Day Low Flow (%)', 'August Low Flow (%)',
                          'September 10% Flow (%)')
matt.diffs$Scenario <- c('ccP10T10', 'ccP50T50', 'ccP90T90')
matt.diffs[1,2:6] <- round((matt.mets[2,2:6]-matt.mets[1,2:6])/matt.mets[1,2:6]*100, 2)
matt.diffs[2,2:6] <- round((matt.mets[3,2:6]-matt.mets[1,2:6])/matt.mets[1,2:6]*100, 2)
matt.diffs[3,2:6] <- round((matt.mets[4,2:6]-matt.mets[1,2:6])/matt.mets[1,2:6]*100, 2)

pamu.diffs <- data.frame(matrix(data = NA, nrow = 3, ncol = 6))
colnames(pamu.diffs) <- c('Scenario', 'Overall Mean (%)', '30-Day Low Flow (%)',
                          '90-Day Low Flow (%)', 'August Low Flow (%)',
                          'September 10% Flow (%)')
pamu.diffs$Scenario <- c('ccP10T10', 'ccP50T50', 'ccP90T90')
pamu.diffs[1,2:6] <- round((pamu.mets[2,2:6]-pamu.mets[1,2:6])/pamu.mets[1,2:6]*100, 2)
pamu.diffs[2,2:6] <- round((pamu.mets[3,2:6]-pamu.mets[1,2:6])/pamu.mets[1,2:6]*100, 2)
pamu.diffs[3,2:6] <- round((pamu.mets[4,2:6]-pamu.mets[1,2:6])/pamu.mets[1,2:6]*100, 2)

rapp.diffs <- data.frame(matrix(data = NA, nrow = 3, ncol = 6))
colnames(rapp.diffs) <- c('Scenario', 'Overall Mean (%)', '30-Day Low Flow (%)',
                          '90-Day Low Flow (%)', 'August Low Flow (%)',
                          'September 10% Flow (%)')
rapp.diffs$Scenario <- c('ccP10T10', 'ccP50T50', 'ccP90T90')
rapp.diffs[1,2:6] <- round((rapp.mets[2,2:6]-rapp.mets[1,2:6])/rapp.mets[1,2:6]*100, 2)
rapp.diffs[2,2:6] <- round((rapp.mets[3,2:6]-rapp.mets[1,2:6])/rapp.mets[1,2:6]*100, 2)
rapp.diffs[3,2:6] <- round((rapp.mets[4,2:6]-rapp.mets[1,2:6])/rapp.mets[1,2:6]*100, 2)

jaup.diffs <- data.frame(matrix(data = NA, nrow = 3, ncol = 6))
colnames(jaup.diffs) <- c('Scenario', 'Overall Mean (%)', '30-Day Low Flow (%)',
                          '90-Day Low Flow (%)', 'August Low Flow (%)',
                          'September 10% Flow (%)')
jaup.diffs$Scenario <- c('ccP10T10', 'ccP50T50', 'ccP90T90')
jaup.diffs[1,2:6] <- round((jaup.mets[2,2:6]-jaup.mets[1,2:6])/jaup.mets[1,2:6]*100, 2)
jaup.diffs[2,2:6] <- round((jaup.mets[3,2:6]-jaup.mets[1,2:6])/jaup.mets[1,2:6]*100, 2)
jaup.diffs[3,2:6] <- round((jaup.mets[4,2:6]-jaup.mets[1,2:6])/jaup.mets[1,2:6]*100, 2)

jami.diffs <- data.frame(matrix(data = NA, nrow = 3, ncol = 6))
colnames(jami.diffs) <- c('Scenario', 'Overall Mean (%)', '30-Day Low Flow (%)',
                          '90-Day Low Flow (%)', 'August Low Flow (%)',
                          'September 10% Flow (%)')
jami.diffs$Scenario <- c('ccP10T10', 'ccP50T50', 'ccP90T90')
jami.diffs[1,2:6] <- round((jami.mets[2,2:6]-jami.mets[1,2:6])/jami.mets[1,2:6]*100, 2)
jami.diffs[2,2:6] <- round((jami.mets[3,2:6]-jami.mets[1,2:6])/jami.mets[1,2:6]*100, 2)
jami.diffs[3,2:6] <- round((jami.mets[4,2:6]-jami.mets[1,2:6])/jami.mets[1,2:6]*100, 2)

appo.diffs <- data.frame(matrix(data = NA, nrow = 3, ncol = 6))
colnames(appo.diffs) <- c('Scenario', 'Overall Mean (%)', '30-Day Low Flow (%)',
                          '90-Day Low Flow (%)', 'August Low Flow (%)',
                          'September 10% Flow (%)')
appo.diffs$Scenario <- c('ccP10T10', 'ccP50T50', 'ccP90T90')
appo.diffs[1,2:6] <- round((appo.mets[2,2:6]-appo.mets[1,2:6])/appo.mets[1,2:6]*100, 2)
appo.diffs[2,2:6] <- round((appo.mets[3,2:6]-appo.mets[1,2:6])/appo.mets[1,2:6]*100, 2)
appo.diffs[3,2:6] <- round((appo.mets[4,2:6]-appo.mets[1,2:6])/appo.mets[1,2:6]*100, 2)

(median(mean.shen.15)-median(mean.shen.11))/median(mean.shen.11)*100
(median(mean.pamu.15)-median(mean.pamu.11))/median(mean.pamu.11)*100
(median(mean.matt.15)-median(mean.matt.11))/median(mean.matt.11)*100
(median(mean.rapp.15)-median(mean.rapp.11))/median(mean.rapp.11)*100
(median(mean.jaup.15)-median(mean.jaup.11))/median(mean.jaup.11)*100
(median(mean.jami.15)-median(mean.jami.11))/median(mean.jami.11)*100
(median(mean.appo.15)-median(mean.appo.11))/median(mean.appo.11)*100

(mean(mean.shen.15)-mean(mean.shen.11))/mean(mean.shen.11)*100
(mean(mean.pamu.15)-mean(mean.pamu.11))/mean(mean.pamu.11)*100
(mean(mean.matt.15)-mean(mean.matt.11))/mean(mean.matt.11)*100
(mean(mean.rapp.15)-mean(mean.rapp.11))/mean(mean.rapp.11)*100
(mean(mean.jaup.15)-mean(mean.jaup.11))/mean(mean.jaup.11)*100
(mean(mean.jami.15)-mean(mean.jami.11))/mean(mean.jami.11)*100
(mean(mean.appo.15)-mean(mean.appo.11))/mean(mean.appo.11)*100

(median(mean.shen.16)-median(mean.shen.11))/median(mean.shen.11)*100
(median(mean.pamu.16)-median(mean.pamu.11))/median(mean.pamu.11)*100
(median(mean.matt.16)-median(mean.matt.11))/median(mean.matt.11)*100
(median(mean.rapp.16)-median(mean.rapp.11))/median(mean.rapp.11)*100
(median(mean.jaup.16)-median(mean.jaup.11))/median(mean.jaup.11)*100
(median(mean.jami.16)-median(mean.jami.11))/median(mean.jami.11)*100
(median(mean.appo.16)-median(mean.appo.11))/median(mean.appo.11)*100

(mean(mean.shen.16)-mean(mean.shen.11))/mean(mean.shen.11)*100
(mean(mean.pamu.16)-mean(mean.pamu.11))/mean(mean.pamu.11)*100
(mean(mean.matt.16)-mean(mean.matt.11))/mean(mean.matt.11)*100
(mean(mean.rapp.16)-mean(mean.rapp.11))/mean(mean.rapp.11)*100
(mean(mean.jaup.16)-mean(mean.jaup.11))/mean(mean.jaup.11)*100
(mean(mean.jami.16)-mean(mean.jami.11))/mean(mean.jami.11)*100
(mean(mean.appo.16)-mean(mean.appo.11))/mean(mean.appo.11)*100

(median(mean.shen.14)-median(mean.shen.11))/median(mean.shen.11)*100
(median(mean.pamu.14)-median(mean.pamu.11))/median(mean.pamu.11)*100
(median(mean.matt.14)-median(mean.matt.11))/median(mean.matt.11)*100
(median(mean.rapp.14)-median(mean.rapp.11))/median(mean.rapp.11)*100
(median(mean.jaup.14)-median(mean.jaup.11))/median(mean.jaup.11)*100
(median(mean.jami.14)-median(mean.jami.11))/median(mean.jami.11)*100
(median(mean.appo.14)-median(mean.appo.11))/median(mean.appo.11)*100

(mean(mean.shen.14)-mean(mean.shen.11))/mean(mean.shen.11)*100
(mean(mean.pamu.14)-mean(mean.pamu.11))/mean(mean.pamu.11)*100
(mean(mean.matt.14)-mean(mean.matt.11))/mean(mean.matt.11)*100
(mean(mean.rapp.14)-mean(mean.rapp.11))/mean(mean.rapp.11)*100
(mean(mean.jaup.14)-mean(mean.jaup.11))/mean(mean.jaup.11)*100
(mean(mean.jami.14)-mean(mean.jami.11))/mean(mean.jami.11)*100
(mean(mean.appo.14)-mean(mean.appo.11))/mean(mean.appo.11)*100

r.shen.11 <- as.numeric(Reduce(c, list(qout_PS5_4370_4150_weighted$data11.flow, qout_PS5_4380_4370_weighted$data11.flow, qout_PS4_5080_4380_weighted$data11.flow,
                                     qout_PS1_4830_5080_weighted$data11.flow, qout_PS1_4790_4830_weighted$data11.flow, qout_PS5_5200_4380_weighted$data11.flow,
                                     qout_PS5_5240_5200_weighted$data11.flow, qout_PS4_5840_5240_weighted$data11.flow, qout_PS4_6360_5840_weighted$data11.flow,
                                     qout_PS2_6420_6360_weighted$data11.flow, qout_PS2_6490_6420_weighted$data11.flow, qout_PS2_6660_6490_weighted$data11.flow,
                                     qout_PS2_6730_6660_weighted$data11.flow, qout_PS3_5100_5080_weighted$data11.flow, qout_PS2_5560_5100_weighted$data11.flow,
                                     qout_PS2_5550_5560_weighted$data11.flow, qout_PS4_6230_6360_weighted$data11.flow, qout_PS3_6280_6230_weighted$data11.flow,
                                     qout_PS3_6161_6280_weighted$data11.flow, qout_PS0_6160_6161_weighted$data11.flow, qout_PS0_6150_6160_weighted$data11.flow,
                                     qout_PS3_6460_6230_weighted$data11.flow, qout_PS3_5990_6161_weighted$data11.flow)))
r.matt.11 <- as.numeric(Reduce(c, list(qout_YM4_6620_0001_weighted$data11.flow, qout_YM1_6370_6620_weighted$data11.flow, qout_YM3_6430_6620_weighted$data11.flow,
                                     qout_YM2_6120_6430_weighted$data11.flow)))
r.pamu.11 <- as.numeric(Reduce(c, list(qout_YP4_6750_0001_weighted$data11.flow, qout_YP4_6720_6750_weighted$data11.flow, qout_YP3_6670_6720_weighted$data11.flow,
                                     qout_YP1_6680_6670_weighted$data11.flow, qout_YP1_6570_6680_weighted$data11.flow, qout_YP3_6690_6720_weighted$data11.flow,
                                     qout_YP3_6470_6690_weighted$data11.flow, qout_YP3_6700_6670_weighted$data11.flow, qout_YP3_6330_6700_weighted$data11.flow,
                                     qout_YP2_6390_6330_weighted$data11.flow)))
r.rapp.11 <- as.numeric(Reduce(c, list(qout_RU5_6030_0001_weighted$data11.flow, qout_RU4_5640_6030_weighted$data11.flow, qout_RU2_5220_5640_weighted$data11.flow,
                                     qout_RU4_6040_6030_weighted$data11.flow, qout_RU3_6170_6040_weighted$data11.flow, qout_RU2_6200_6170_weighted$data11.flow,
                                     qout_RU2_5940_6200_weighted$data11.flow, qout_RU3_5610_5640_weighted$data11.flow, qout_RU2_5500_5610_weighted$data11.flow,
                                     qout_RU2_6220_6170_weighted$data11.flow, qout_RU2_6090_6220_weighted$data11.flow, qout_RU2_5810_5610_weighted$data11.flow)))
r.jame.up.11 <- as.numeric(Reduce(c, list(qout_JU5_7420_7160_weighted$data11.flow, qout_JU5_7500_7420_weighted$data11.flow, qout_JU1_7560_7500_weighted$data11.flow,
                                        qout_JU1_7750_7560_weighted$data11.flow, qout_JU5_7510_7500_weighted$data11.flow, qout_JU3_7400_7510_weighted$data11.flow,
                                        qout_JU3_7490_7400_weighted$data11.flow, qout_JU1_7630_7490_weighted$data11.flow, qout_JU5_7300_7510_weighted$data11.flow,
                                        qout_JU3_6650_7300_weighted$data11.flow, qout_JU1_6300_6650_weighted$data11.flow, qout_JU1_7690_7490_weighted$data11.flow,
                                        qout_JU4_7000_7300_weighted$data11.flow, qout_JU2_7360_7000_weighted$data11.flow, qout_JU2_7450_7360_weighted$data11.flow,
                                        qout_JU1_6340_6650_weighted$data11.flow, qout_JU4_7330_7000_weighted$data11.flow, qout_JU2_7140_7330_weighted$data11.flow,
                                        qout_JU3_6950_7330_weighted$data11.flow, qout_JU3_6900_6950_weighted$data11.flow, qout_JU2_6810_6900_weighted$data11.flow,
                                        qout_JU2_6600_6810_weighted$data11.flow, qout_JU1_6590_6600_weighted$data11.flow, qout_JU1_6290_6590_weighted$data11.flow,
                                        qout_JU3_6380_6900_weighted$data11.flow, qout_JU4_7380_7160_weighted$data11.flow, qout_JU2_7180_7380_weighted$data11.flow,
                                        qout_JU4_7260_7380_weighted$data11.flow, qout_JU1_6880_7260_weighted$data11.flow, qout_JU3_6790_7260_weighted$data11.flow,
                                        qout_JU3_6640_6790_weighted$data11.flow, qout_JU2_6410_6640_weighted$data11.flow)))
r.jame.mid.11 <- as.numeric(Reduce(c, list(qout_JL7_7070_0001_weighted$data11.flow, qout_JL7_6800_7070_weighted$data11.flow, qout_JL1_7170_6800_weighted$data11.flow,
                                         qout_JL7_7030_6800_weighted$data11.flow, qout_JL7_7100_7030_weighted$data11.flow, qout_JL3_7020_7100_weighted$data11.flow,
                                         qout_JL6_6740_7100_weighted$data11.flow, qout_JL4_6710_6740_weighted$data11.flow, qout_JL4_6520_6710_weighted$data11.flow,
                                         qout_JL2_6240_6520_weighted$data11.flow, qout_JL6_6970_6740_weighted$data11.flow, qout_JL2_7120_6970_weighted$data11.flow,
                                         qout_JL2_7110_7120_weighted$data11.flow, qout_JL2_6441_6520_weighted$data11.flow, qout_JL2_6440_6441_weighted$data11.flow,
                                         qout_JL1_6560_6440_weighted$data11.flow, qout_JL6_6960_6970_weighted$data11.flow, qout_JL1_6910_6960_weighted$data11.flow,
                                         qout_JL1_6760_6910_weighted$data11.flow, qout_JL6_6990_6960_weighted$data11.flow, qout_JL6_6890_6990_weighted$data11.flow,
                                         qout_JL2_6850_6890_weighted$data11.flow, qout_JL1_6770_6850_weighted$data11.flow, qout_JL6_7150_6890_weighted$data11.flow,
                                         qout_JL3_7090_7150_weighted$data11.flow, qout_JL2_7250_7090_weighted$data11.flow, qout_JL1_7190_7250_weighted$data11.flow,
                                         qout_JL1_7080_7190_weighted$data11.flow, qout_JL6_7320_7150_weighted$data11.flow, qout_JL6_7430_7320_weighted$data11.flow,
                                         qout_JL1_7530_7430_weighted$data11.flow, qout_JL2_7350_7090_weighted$data11.flow, qout_JL2_7240_7350_weighted$data11.flow,
                                         qout_JL1_7200_7250_weighted$data11.flow, qout_JL1_6940_7200_weighted$data11.flow, qout_JL6_7440_7430_weighted$data11.flow,
                                         qout_JL6_7160_7440_weighted$data11.flow)))
r.appo.11 <- as.numeric(Reduce(c, list(qout_JA5_7480_0001_weighted$data11.flow, qout_JA2_7570_7480_weighted$data11.flow, qout_JA1_7600_7570_weighted$data11.flow,
                                     qout_JA4_7470_7480_weighted$data11.flow, qout_JA2_7410_7470_weighted$data11.flow, qout_JA4_7340_7470_weighted$data11.flow,
                                     qout_JA4_7280_7340_weighted$data11.flow, qout_JA1_7640_7280_weighted$data11.flow, qout_JA2_7550_7280_weighted$data11.flow)))

r.shen.14 <- as.numeric(Reduce(c, list(qout_PS5_4370_4150_weighted$data14.flow, qout_PS5_4380_4370_weighted$data14.flow, qout_PS4_5080_4380_weighted$data14.flow,
                                     qout_PS1_4830_5080_weighted$data14.flow, qout_PS1_4790_4830_weighted$data14.flow, qout_PS5_5200_4380_weighted$data14.flow,
                                     qout_PS5_5240_5200_weighted$data14.flow, qout_PS4_5840_5240_weighted$data14.flow, qout_PS4_6360_5840_weighted$data14.flow,
                                     qout_PS2_6420_6360_weighted$data14.flow, qout_PS2_6490_6420_weighted$data14.flow, qout_PS2_6660_6490_weighted$data14.flow,
                                     qout_PS2_6730_6660_weighted$data14.flow, qout_PS3_5100_5080_weighted$data14.flow, qout_PS2_5560_5100_weighted$data14.flow,
                                     qout_PS2_5550_5560_weighted$data14.flow, qout_PS4_6230_6360_weighted$data14.flow, qout_PS3_6280_6230_weighted$data14.flow,
                                     qout_PS3_6161_6280_weighted$data14.flow, qout_PS0_6160_6161_weighted$data14.flow, qout_PS0_6150_6160_weighted$data14.flow,
                                     qout_PS3_6460_6230_weighted$data14.flow, qout_PS3_5990_6161_weighted$data14.flow)))
r.matt.14 <- as.numeric(Reduce(c, list(qout_YM4_6620_0001_weighted$data14.flow, qout_YM1_6370_6620_weighted$data14.flow, qout_YM3_6430_6620_weighted$data14.flow,
                                     qout_YM2_6120_6430_weighted$data14.flow)))
r.pamu.14 <- as.numeric(Reduce(c, list(qout_YP4_6750_0001_weighted$data14.flow, qout_YP4_6720_6750_weighted$data14.flow, qout_YP3_6670_6720_weighted$data14.flow,
                                     qout_YP1_6680_6670_weighted$data14.flow, qout_YP1_6570_6680_weighted$data14.flow, qout_YP3_6690_6720_weighted$data14.flow,
                                     qout_YP3_6470_6690_weighted$data14.flow, qout_YP3_6700_6670_weighted$data14.flow, qout_YP3_6330_6700_weighted$data14.flow,
                                     qout_YP2_6390_6330_weighted$data14.flow)))
r.rapp.14 <- as.numeric(Reduce(c, list(qout_RU5_6030_0001_weighted$data14.flow, qout_RU4_5640_6030_weighted$data14.flow, qout_RU2_5220_5640_weighted$data14.flow,
                                     qout_RU4_6040_6030_weighted$data14.flow, qout_RU3_6170_6040_weighted$data14.flow, qout_RU2_6200_6170_weighted$data14.flow,
                                     qout_RU2_5940_6200_weighted$data14.flow, qout_RU3_5610_5640_weighted$data14.flow, qout_RU2_5500_5610_weighted$data14.flow,
                                     qout_RU2_6220_6170_weighted$data14.flow, qout_RU2_6090_6220_weighted$data14.flow, qout_RU2_5810_5610_weighted$data14.flow)))
r.jame.up.14 <- as.numeric(Reduce(c, list(qout_JU5_7420_7160_weighted$data14.flow, qout_JU5_7500_7420_weighted$data14.flow, qout_JU1_7560_7500_weighted$data14.flow,
                                        qout_JU1_7750_7560_weighted$data14.flow, qout_JU5_7510_7500_weighted$data14.flow, qout_JU3_7400_7510_weighted$data14.flow,
                                        qout_JU3_7490_7400_weighted$data14.flow, qout_JU1_7630_7490_weighted$data14.flow, qout_JU5_7300_7510_weighted$data14.flow,
                                        qout_JU3_6650_7300_weighted$data14.flow, qout_JU1_6300_6650_weighted$data14.flow, qout_JU1_7690_7490_weighted$data14.flow,
                                        qout_JU4_7000_7300_weighted$data14.flow, qout_JU2_7360_7000_weighted$data14.flow, qout_JU2_7450_7360_weighted$data14.flow,
                                        qout_JU1_6340_6650_weighted$data14.flow, qout_JU4_7330_7000_weighted$data14.flow, qout_JU2_7140_7330_weighted$data14.flow,
                                        qout_JU3_6950_7330_weighted$data14.flow, qout_JU3_6900_6950_weighted$data14.flow, qout_JU2_6810_6900_weighted$data14.flow,
                                        qout_JU2_6600_6810_weighted$data14.flow, qout_JU1_6590_6600_weighted$data14.flow, qout_JU1_6290_6590_weighted$data14.flow,
                                        qout_JU3_6380_6900_weighted$data14.flow, qout_JU4_7380_7160_weighted$data14.flow, qout_JU2_7180_7380_weighted$data14.flow,
                                        qout_JU4_7260_7380_weighted$data14.flow, qout_JU1_6880_7260_weighted$data14.flow, qout_JU3_6790_7260_weighted$data14.flow,
                                        qout_JU3_6640_6790_weighted$data14.flow, qout_JU2_6410_6640_weighted$data14.flow)))
r.jame.mid.14 <- as.numeric(Reduce(c, list(qout_JL7_7070_0001_weighted$data14.flow, qout_JL7_6800_7070_weighted$data14.flow, qout_JL1_7170_6800_weighted$data14.flow,
                                         qout_JL7_7030_6800_weighted$data14.flow, qout_JL7_7100_7030_weighted$data14.flow, qout_JL3_7020_7100_weighted$data14.flow,
                                         qout_JL6_6740_7100_weighted$data14.flow, qout_JL4_6710_6740_weighted$data14.flow, qout_JL4_6520_6710_weighted$data14.flow,
                                         qout_JL2_6240_6520_weighted$data14.flow, qout_JL6_6970_6740_weighted$data14.flow, qout_JL2_7120_6970_weighted$data14.flow,
                                         qout_JL2_7110_7120_weighted$data14.flow, qout_JL2_6441_6520_weighted$data14.flow, qout_JL2_6440_6441_weighted$data14.flow,
                                         qout_JL1_6560_6440_weighted$data14.flow, qout_JL6_6960_6970_weighted$data14.flow, qout_JL1_6910_6960_weighted$data14.flow,
                                         qout_JL1_6760_6910_weighted$data14.flow, qout_JL6_6990_6960_weighted$data14.flow, qout_JL6_6890_6990_weighted$data14.flow,
                                         qout_JL2_6850_6890_weighted$data14.flow, qout_JL1_6770_6850_weighted$data14.flow, qout_JL6_7150_6890_weighted$data14.flow,
                                         qout_JL3_7090_7150_weighted$data14.flow, qout_JL2_7250_7090_weighted$data14.flow, qout_JL1_7190_7250_weighted$data14.flow,
                                         qout_JL1_7080_7190_weighted$data14.flow, qout_JL6_7320_7150_weighted$data14.flow, qout_JL6_7430_7320_weighted$data14.flow,
                                         qout_JL1_7530_7430_weighted$data14.flow, qout_JL2_7350_7090_weighted$data14.flow, qout_JL2_7240_7350_weighted$data14.flow,
                                         qout_JL1_7200_7250_weighted$data14.flow, qout_JL1_6940_7200_weighted$data14.flow, qout_JL6_7440_7430_weighted$data14.flow,
                                         qout_JL6_7160_7440_weighted$data14.flow)))
r.appo.14 <- as.numeric(Reduce(c, list(qout_JA5_7480_0001_weighted$data14.flow, qout_JA2_7570_7480_weighted$data14.flow, qout_JA1_7600_7570_weighted$data14.flow,
                                     qout_JA4_7470_7480_weighted$data14.flow, qout_JA2_7410_7470_weighted$data14.flow, qout_JA4_7340_7470_weighted$data14.flow,
                                     qout_JA4_7280_7340_weighted$data14.flow, qout_JA1_7640_7280_weighted$data14.flow, qout_JA2_7550_7280_weighted$data14.flow)))

r.shen.15 <- as.numeric(Reduce(c, list(qout_PS5_4370_4150_weighted$data15.flow, qout_PS5_4380_4370_weighted$data15.flow, qout_PS4_5080_4380_weighted$data15.flow,
                                     qout_PS1_4830_5080_weighted$data15.flow, qout_PS1_4790_4830_weighted$data15.flow, qout_PS5_5200_4380_weighted$data15.flow,
                                     qout_PS5_5240_5200_weighted$data15.flow, qout_PS4_5840_5240_weighted$data15.flow, qout_PS4_6360_5840_weighted$data15.flow,
                                     qout_PS2_6420_6360_weighted$data15.flow, qout_PS2_6490_6420_weighted$data15.flow, qout_PS2_6660_6490_weighted$data15.flow,
                                     qout_PS2_6730_6660_weighted$data15.flow, qout_PS3_5100_5080_weighted$data15.flow, qout_PS2_5560_5100_weighted$data15.flow,
                                     qout_PS2_5550_5560_weighted$data15.flow, qout_PS4_6230_6360_weighted$data15.flow, qout_PS3_6280_6230_weighted$data15.flow,
                                     qout_PS3_6161_6280_weighted$data15.flow, qout_PS0_6160_6161_weighted$data15.flow, qout_PS0_6150_6160_weighted$data15.flow,
                                     qout_PS3_6460_6230_weighted$data15.flow, qout_PS3_5990_6161_weighted$data15.flow)))
r.matt.15 <- as.numeric(Reduce(c, list(qout_YM4_6620_0001_weighted$data15.flow, qout_YM1_6370_6620_weighted$data15.flow, qout_YM3_6430_6620_weighted$data15.flow,
                                     qout_YM2_6120_6430_weighted$data15.flow)))
r.pamu.15 <- as.numeric(Reduce(c, list(qout_YP4_6750_0001_weighted$data15.flow, qout_YP4_6720_6750_weighted$data15.flow, qout_YP3_6670_6720_weighted$data15.flow,
                                     qout_YP1_6680_6670_weighted$data15.flow, qout_YP1_6570_6680_weighted$data15.flow, qout_YP3_6690_6720_weighted$data15.flow,
                                     qout_YP3_6470_6690_weighted$data15.flow, qout_YP3_6700_6670_weighted$data15.flow, qout_YP3_6330_6700_weighted$data15.flow,
                                     qout_YP2_6390_6330_weighted$data15.flow)))
r.rapp.15 <- as.numeric(Reduce(c, list(qout_RU5_6030_0001_weighted$data15.flow, qout_RU4_5640_6030_weighted$data15.flow, qout_RU2_5220_5640_weighted$data15.flow,
                                     qout_RU4_6040_6030_weighted$data15.flow, qout_RU3_6170_6040_weighted$data15.flow, qout_RU2_6200_6170_weighted$data15.flow,
                                     qout_RU2_5940_6200_weighted$data15.flow, qout_RU3_5610_5640_weighted$data15.flow, qout_RU2_5500_5610_weighted$data15.flow,
                                     qout_RU2_6220_6170_weighted$data15.flow, qout_RU2_6090_6220_weighted$data15.flow, qout_RU2_5810_5610_weighted$data15.flow)))
r.jame.up.15 <- as.numeric(Reduce(c, list(qout_JU5_7420_7160_weighted$data15.flow, qout_JU5_7500_7420_weighted$data15.flow, qout_JU1_7560_7500_weighted$data15.flow,
                                        qout_JU1_7750_7560_weighted$data15.flow, qout_JU5_7510_7500_weighted$data15.flow, qout_JU3_7400_7510_weighted$data15.flow,
                                        qout_JU3_7490_7400_weighted$data15.flow, qout_JU1_7630_7490_weighted$data15.flow, qout_JU5_7300_7510_weighted$data15.flow,
                                        qout_JU3_6650_7300_weighted$data15.flow, qout_JU1_6300_6650_weighted$data15.flow, qout_JU1_7690_7490_weighted$data15.flow,
                                        qout_JU4_7000_7300_weighted$data15.flow, qout_JU2_7360_7000_weighted$data15.flow, qout_JU2_7450_7360_weighted$data15.flow,
                                        qout_JU1_6340_6650_weighted$data15.flow, qout_JU4_7330_7000_weighted$data15.flow, qout_JU2_7140_7330_weighted$data15.flow,
                                        qout_JU3_6950_7330_weighted$data15.flow, qout_JU3_6900_6950_weighted$data15.flow, qout_JU2_6810_6900_weighted$data15.flow,
                                        qout_JU2_6600_6810_weighted$data15.flow, qout_JU1_6590_6600_weighted$data15.flow, qout_JU1_6290_6590_weighted$data15.flow,
                                        qout_JU3_6380_6900_weighted$data15.flow, qout_JU4_7380_7160_weighted$data15.flow, qout_JU2_7180_7380_weighted$data15.flow,
                                        qout_JU4_7260_7380_weighted$data15.flow, qout_JU1_6880_7260_weighted$data15.flow, qout_JU3_6790_7260_weighted$data15.flow,
                                        qout_JU3_6640_6790_weighted$data15.flow, qout_JU2_6410_6640_weighted$data15.flow)))
r.jame.mid.15 <- as.numeric(Reduce(c, list(qout_JL7_7070_0001_weighted$data15.flow, qout_JL7_6800_7070_weighted$data15.flow, qout_JL1_7170_6800_weighted$data15.flow,
                                         qout_JL7_7030_6800_weighted$data15.flow, qout_JL7_7100_7030_weighted$data15.flow, qout_JL3_7020_7100_weighted$data15.flow,
                                         qout_JL6_6740_7100_weighted$data15.flow, qout_JL4_6710_6740_weighted$data15.flow, qout_JL4_6520_6710_weighted$data15.flow,
                                         qout_JL2_6240_6520_weighted$data15.flow, qout_JL6_6970_6740_weighted$data15.flow, qout_JL2_7120_6970_weighted$data15.flow,
                                         qout_JL2_7110_7120_weighted$data15.flow, qout_JL2_6441_6520_weighted$data15.flow, qout_JL2_6440_6441_weighted$data15.flow,
                                         qout_JL1_6560_6440_weighted$data15.flow, qout_JL6_6960_6970_weighted$data15.flow, qout_JL1_6910_6960_weighted$data15.flow,
                                         qout_JL1_6760_6910_weighted$data15.flow, qout_JL6_6990_6960_weighted$data15.flow, qout_JL6_6890_6990_weighted$data15.flow,
                                         qout_JL2_6850_6890_weighted$data15.flow, qout_JL1_6770_6850_weighted$data15.flow, qout_JL6_7150_6890_weighted$data15.flow,
                                         qout_JL3_7090_7150_weighted$data15.flow, qout_JL2_7250_7090_weighted$data15.flow, qout_JL1_7190_7250_weighted$data15.flow,
                                         qout_JL1_7080_7190_weighted$data15.flow, qout_JL6_7320_7150_weighted$data15.flow, qout_JL6_7430_7320_weighted$data15.flow,
                                         qout_JL1_7530_7430_weighted$data15.flow, qout_JL2_7350_7090_weighted$data15.flow, qout_JL2_7240_7350_weighted$data15.flow,
                                         qout_JL1_7200_7250_weighted$data15.flow, qout_JL1_6940_7200_weighted$data15.flow, qout_JL6_7440_7430_weighted$data15.flow,
                                         qout_JL6_7160_7440_weighted$data15.flow)))
r.appo.15 <- as.numeric(Reduce(c, list(qout_JA5_7480_0001_weighted$data15.flow, qout_JA2_7570_7480_weighted$data15.flow, qout_JA1_7600_7570_weighted$data15.flow,
                                     qout_JA4_7470_7480_weighted$data15.flow, qout_JA2_7410_7470_weighted$data15.flow, qout_JA4_7340_7470_weighted$data15.flow,
                                     qout_JA4_7280_7340_weighted$data15.flow, qout_JA1_7640_7280_weighted$data15.flow, qout_JA2_7550_7280_weighted$data15.flow)))

r.shen.16 <- as.numeric(Reduce(c, list(qout_PS5_4370_4150_weighted$data16.flow, qout_PS5_4380_4370_weighted$data16.flow, qout_PS4_5080_4380_weighted$data16.flow,
                                     qout_PS1_4830_5080_weighted$data16.flow, qout_PS1_4790_4830_weighted$data16.flow, qout_PS5_5200_4380_weighted$data16.flow,
                                     qout_PS5_5240_5200_weighted$data16.flow, qout_PS4_5840_5240_weighted$data16.flow, qout_PS4_6360_5840_weighted$data16.flow,
                                     qout_PS2_6420_6360_weighted$data16.flow, qout_PS2_6490_6420_weighted$data16.flow, qout_PS2_6660_6490_weighted$data16.flow,
                                     qout_PS2_6730_6660_weighted$data16.flow, qout_PS3_5100_5080_weighted$data16.flow, qout_PS2_5560_5100_weighted$data16.flow,
                                     qout_PS2_5550_5560_weighted$data16.flow, qout_PS4_6230_6360_weighted$data16.flow, qout_PS3_6280_6230_weighted$data16.flow,
                                     qout_PS3_6161_6280_weighted$data16.flow, qout_PS0_6160_6161_weighted$data16.flow, qout_PS0_6150_6160_weighted$data16.flow,
                                     qout_PS3_6460_6230_weighted$data16.flow, qout_PS3_5990_6161_weighted$data16.flow)))
r.matt.16 <- as.numeric(Reduce(c, list(qout_YM4_6620_0001_weighted$data16.flow, qout_YM1_6370_6620_weighted$data16.flow, qout_YM3_6430_6620_weighted$data16.flow,
                                     qout_YM2_6120_6430_weighted$data16.flow)))
r.pamu.16 <- as.numeric(Reduce(c, list(qout_YP4_6750_0001_weighted$data16.flow, qout_YP4_6720_6750_weighted$data16.flow, qout_YP3_6670_6720_weighted$data16.flow,
                                     qout_YP1_6680_6670_weighted$data16.flow, qout_YP1_6570_6680_weighted$data16.flow, qout_YP3_6690_6720_weighted$data16.flow,
                                     qout_YP3_6470_6690_weighted$data16.flow, qout_YP3_6700_6670_weighted$data16.flow, qout_YP3_6330_6700_weighted$data16.flow,
                                     qout_YP2_6390_6330_weighted$data16.flow)))
r.rapp.16 <- as.numeric(Reduce(c, list(qout_RU5_6030_0001_weighted$data16.flow, qout_RU4_5640_6030_weighted$data16.flow, qout_RU2_5220_5640_weighted$data16.flow,
                                     qout_RU4_6040_6030_weighted$data16.flow, qout_RU3_6170_6040_weighted$data16.flow, qout_RU2_6200_6170_weighted$data16.flow,
                                     qout_RU2_5940_6200_weighted$data16.flow, qout_RU3_5610_5640_weighted$data16.flow, qout_RU2_5500_5610_weighted$data16.flow,
                                     qout_RU2_6220_6170_weighted$data16.flow, qout_RU2_6090_6220_weighted$data16.flow, qout_RU2_5810_5610_weighted$data16.flow)))
r.jame.up.16 <- as.numeric(Reduce(c, list(qout_JU5_7420_7160_weighted$data16.flow, qout_JU5_7500_7420_weighted$data16.flow, qout_JU1_7560_7500_weighted$data16.flow,
                                        qout_JU1_7750_7560_weighted$data16.flow, qout_JU5_7510_7500_weighted$data16.flow, qout_JU3_7400_7510_weighted$data16.flow,
                                        qout_JU3_7490_7400_weighted$data16.flow, qout_JU1_7630_7490_weighted$data16.flow, qout_JU5_7300_7510_weighted$data16.flow,
                                        qout_JU3_6650_7300_weighted$data16.flow, qout_JU1_6300_6650_weighted$data16.flow, qout_JU1_7690_7490_weighted$data16.flow,
                                        qout_JU4_7000_7300_weighted$data16.flow, qout_JU2_7360_7000_weighted$data16.flow, qout_JU2_7450_7360_weighted$data16.flow,
                                        qout_JU1_6340_6650_weighted$data16.flow, qout_JU4_7330_7000_weighted$data16.flow, qout_JU2_7140_7330_weighted$data16.flow,
                                        qout_JU3_6950_7330_weighted$data16.flow, qout_JU3_6900_6950_weighted$data16.flow, qout_JU2_6810_6900_weighted$data16.flow,
                                        qout_JU2_6600_6810_weighted$data16.flow, qout_JU1_6590_6600_weighted$data16.flow, qout_JU1_6290_6590_weighted$data16.flow,
                                        qout_JU3_6380_6900_weighted$data16.flow, qout_JU4_7380_7160_weighted$data16.flow, qout_JU2_7180_7380_weighted$data16.flow,
                                        qout_JU4_7260_7380_weighted$data16.flow, qout_JU1_6880_7260_weighted$data16.flow, qout_JU3_6790_7260_weighted$data16.flow,
                                        qout_JU3_6640_6790_weighted$data16.flow, qout_JU2_6410_6640_weighted$data16.flow)))
r.jame.mid.16 <- as.numeric(Reduce(c, list(qout_JL7_7070_0001_weighted$data16.flow, qout_JL7_6800_7070_weighted$data16.flow, qout_JL1_7170_6800_weighted$data16.flow,
                                         qout_JL7_7030_6800_weighted$data16.flow, qout_JL7_7100_7030_weighted$data16.flow, qout_JL3_7020_7100_weighted$data16.flow,
                                         qout_JL6_6740_7100_weighted$data16.flow, qout_JL4_6710_6740_weighted$data16.flow, qout_JL4_6520_6710_weighted$data16.flow,
                                         qout_JL2_6240_6520_weighted$data16.flow, qout_JL6_6970_6740_weighted$data16.flow, qout_JL2_7120_6970_weighted$data16.flow,
                                         qout_JL2_7110_7120_weighted$data16.flow, qout_JL2_6441_6520_weighted$data16.flow, qout_JL2_6440_6441_weighted$data16.flow,
                                         qout_JL1_6560_6440_weighted$data16.flow, qout_JL6_6960_6970_weighted$data16.flow, qout_JL1_6910_6960_weighted$data16.flow,
                                         qout_JL1_6760_6910_weighted$data16.flow, qout_JL6_6990_6960_weighted$data16.flow, qout_JL6_6890_6990_weighted$data16.flow,
                                         qout_JL2_6850_6890_weighted$data16.flow, qout_JL1_6770_6850_weighted$data16.flow, qout_JL6_7150_6890_weighted$data16.flow,
                                         qout_JL3_7090_7150_weighted$data16.flow, qout_JL2_7250_7090_weighted$data16.flow, qout_JL1_7190_7250_weighted$data16.flow,
                                         qout_JL1_7080_7190_weighted$data16.flow, qout_JL6_7320_7150_weighted$data16.flow, qout_JL6_7430_7320_weighted$data16.flow,
                                         qout_JL1_7530_7430_weighted$data16.flow, qout_JL2_7350_7090_weighted$data16.flow, qout_JL2_7240_7350_weighted$data16.flow,
                                         qout_JL1_7200_7250_weighted$data16.flow, qout_JL1_6940_7200_weighted$data16.flow, qout_JL6_7440_7430_weighted$data16.flow,
                                         qout_JL6_7160_7440_weighted$data16.flow)))
r.appo.16 <- as.numeric(Reduce(c, list(qout_JA5_7480_0001_weighted$data16.flow, qout_JA2_7570_7480_weighted$data16.flow, qout_JA1_7600_7570_weighted$data16.flow,
                                     qout_JA4_7470_7480_weighted$data16.flow, qout_JA2_7410_7470_weighted$data16.flow, qout_JA4_7340_7470_weighted$data16.flow,
                                     qout_JA4_7280_7340_weighted$data16.flow, qout_JA1_7640_7280_weighted$data16.flow, qout_JA2_7550_7280_weighted$data16.flow)))

rsq <- function (x, y) cor(x, y) ^ 2

rsq(shen.16, r.shen.16)
rsq(matt.16, r.matt.16)
rsq(pamu.16, r.pamu.16)
rsq(rapp.16, r.rapp.16)
rsq(jame.up.16, r.jame.up.16)
rsq(jame.mid.16, r.jame.mid.16)
rsq(appo.16, r.appo.16)

rsq(shen.11, r.shen.11)
rsq(matt.11, r.matt.11)
rsq(pamu.11, r.pamu.11)
rsq(rapp.11, r.rapp.11)
rsq(jame.up.11, r.jame.up.11)
rsq(jame.mid.11, r.jame.mid.11)
rsq(appo.11, r.appo.11)

median(shen.diff.15$`Overall Mean (%)`)
median(shen.diff.15$`30-Day Low Flow (%)`)
median(shen.diff.15$`90-Day Low Flow (%)`)
median(shen.diff.15$`August Low Flow (%)`)
median(shen.diff.15$`September 10% Flow (%)`)

median(matt.diff.15$`Overall Mean (%)`)
median(matt.diff.15$`30-Day Low Flow (%)`)
median(matt.diff.15$`90-Day Low Flow (%)`)
median(matt.diff.15$`August Low Flow (%)`)
median(matt.diff.15$`September 10% Flow (%)`)

median(pamu.diff.15$`Overall Mean (%)`)
median(pamu.diff.15$`30-Day Low Flow (%)`)
median(pamu.diff.15$`90-Day Low Flow (%)`)
median(pamu.diff.15$`August Low Flow (%)`)
median(pamu.diff.15$`September 10% Flow (%)`)

median(rapp.diff.14$`Overall Mean (%)`)
median(rapp.diff.14$`30-Day Low Flow (%)`)
median(rapp.diff.14$`90-Day Low Flow (%)`)
median(rapp.diff.14$`August Low Flow (%)`)
median(rapp.diff.14$`September 10% Flow (%)`)

median(jaup.diff.16$`Overall Mean (%)`)
median(jaup.diff.16$`30-Day Low Flow (%)`)
median(jaup.diff.16$`90-Day Low Flow (%)`)
median(jaup.diff.16$`August Low Flow (%)`)
median(jaup.diff.16$`September 10% Flow (%)`)

median(jami.diff.15$`Overall Mean (%)`)
median(jami.diff.15$`30-Day Low Flow (%)`)
median(jami.diff.15$`90-Day Low Flow (%)`)
median(jami.diff.15$`August Low Flow (%)`)
median(jami.diff.15$`September 10% Flow (%)`)

median(appo.diff.16$`Overall Mean (%)`)
median(appo.diff.16$`30-Day Low Flow (%)`)
median(appo.diff.16$`90-Day Low Flow (%)`)
median(appo.diff.16$`August Low Flow (%)`)
median(appo.diff.16$`September 10% Flow (%)`)

all.diffs.10 <- rbind(shen.diff.15, matt.diff.15, pamu.diff.15, rapp.diff.15, appo.diff.15, jami.diff.15, jaup.diff.15)
all.diffs.50 <- rbind(shen.diff.14, matt.diff.14, pamu.diff.14, rapp.diff.14, appo.diff.14, jami.diff.14, jaup.diff.14)
all.diffs.90 <- rbind(shen.diff.16, matt.diff.16, pamu.diff.16, rapp.diff.16, appo.diff.16, jami.diff.16, jaup.diff.16)

mean(all.diffs.10$`Overall Mean (%)`)
mean(all.diffs.10$`30-Day Low Flow (%)`)
mean(all.diffs.10$`90-Day Low Flow (%)`)
mean(all.diffs.10$`August Low Flow (%)`)
mean(all.diffs.10$`September 10% Flow (%)`)

mean(all.diffs.50$`Overall Mean (%)`)
mean(all.diffs.50$`30-Day Low Flow (%)`)
mean(all.diffs.50$`90-Day Low Flow (%)`)
mean(all.diffs.50$`August Low Flow (%)`)
mean(all.diffs.50$`September 10% Flow (%)`)

mean(all.diffs.90$`Overall Mean (%)`)
mean(all.diffs.90$`30-Day Low Flow (%)`)
mean(all.diffs.90$`90-Day Low Flow (%)`)
mean(all.diffs.90$`August Low Flow (%)`)
mean(all.diffs.90$`September 10% Flow (%)`)