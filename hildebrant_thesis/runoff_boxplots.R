# Creates boxplots of unit runoff (Runit) values, previously downloaded using the 
# "Download_Runit_and_Qout_Data" script.  Additionally, calculates median and mean percent 
# changes and calculates quantiles of percent runoff changes.

setwd('~/Precip_and_Temp_Mapper/Runit_Qout_data')

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
jame.up.mid = jame.up.mid
jaup.up <- jame.up.up
jami.up <- jame.up.mid

for (i in 1:length(shen.up)) {
  namer <- paste0('runit_', shen.up[i])
  temp <- read.csv(paste0('~/Precip_and_Temp_Mapper/Runit_Qout_data/', namer, '.csv'))
  assign(namer, temp)
}

for (i in 1:length(matt.up)) {
  namer <- paste0('runit_', matt.up[i])
  temp <- read.csv(paste0('~/Precip_and_Temp_Mapper/Runit_Qout_data/', namer, '.csv'))
  assign(namer, temp)
}

for (i in 1:length(pamu.up)) {
  namer <- paste0('runit_', pamu.up[i])
  temp <- read.csv(paste0('~/Precip_and_Temp_Mapper/Runit_Qout_data/', namer, '.csv'))
  assign(namer, temp)
}

for (i in 1:length(rapp.up)) {
  namer <- paste0('runit_', rapp.up[i])
  temp <- read.csv(paste0('~/Precip_and_Temp_Mapper/Runit_Qout_data/', namer, '.csv'))
  assign(namer, temp)
}

for (i in 1:length(appo.up)) {
  namer <- paste0('runit_', appo.up[i])
  temp <- read.csv(paste0('~/Precip_and_Temp_Mapper/Runit_Qout_data/', namer, '.csv'))
  assign(namer, temp)
}

for (i in 1:length(jame.up.up)) {
  namer <- paste0('runit_', jame.up.up[i])
  temp <- read.csv(paste0('~/Precip_and_Temp_Mapper/Runit_Qout_data/', namer, '.csv'))
  assign(namer, temp)
}

for (i in 1:length(jame.up.mid)) {
  namer <- paste0('runit_', jame.up.mid[i])
  temp <- read.csv(paste0('~/Precip_and_Temp_Mapper/Runit_Qout_data/', namer, '.csv'))
  assign(namer, temp)
}

png(filename = 'shen.png', width = 800, height = 600)
par(mar = c(10.1, 3.1, 1.1, 1.1))
boxplot(runit_PS5_4370_4150$lri.dat11.flow.unit, runit_PS5_4380_4370$lri.dat11.flow.unit, runit_PS4_5080_4380$lri.dat11.flow.unit,
        runit_PS1_4830_5080$lri.dat11.flow.unit, runit_PS1_4790_4830$lri.dat11.flow.unit, runit_PS5_5200_4380$lri.dat11.flow.unit,
        runit_PS5_5240_5200$lri.dat11.flow.unit, runit_PS4_5840_5240$lri.dat11.flow.unit, runit_PS4_6360_5840$lri.dat11.flow.unit,
        runit_PS2_6420_6360$lri.dat11.flow.unit, runit_PS2_6490_6420$lri.dat11.flow.unit, runit_PS2_6660_6490$lri.dat11.flow.unit,
        runit_PS2_6730_6660$lri.dat11.flow.unit, runit_PS3_5100_5080$lri.dat11.flow.unit, runit_PS2_5560_5100$lri.dat11.flow.unit,
        runit_PS2_5550_5560$lri.dat11.flow.unit, runit_PS4_6230_6360$lri.dat11.flow.unit, runit_PS3_6280_6230$lri.dat11.flow.unit,
        runit_PS3_6161_6280$lri.dat11.flow.unit, runit_PS0_6160_6161$lri.dat11.flow.unit, runit_PS0_6150_6160$lri.dat11.flow.unit,
        runit_PS3_6460_6230$lri.dat11.flow.unit, runit_PS3_5990_6161$lri.dat11.flow.unit, ylim = c(0,3.5),
        names = shen.up, las = 2, cex.axis = 1.4)
dev.off()

png(filename = 'matt.png', width = 800, height = 600)
par(mar = c(10.1, 3.1, 1.1, 1.1))
boxplot(runit_YM4_6620_0001$lri.dat11.flow.unit, runit_YM1_6370_6620$lri.dat11.flow.unit, runit_YM3_6430_6620$lri.dat11.flow.unit,
        runit_YM2_6120_6430$lri.dat11.flow.unit, ylim = c(0,3.5),
        names = matt.up, las = 2, cex.axis = 1.4)
dev.off()

png(filename = 'pamu.png', width = 800, height = 600)
par(mar = c(10.1, 3.1, 1.1, 1.1))
boxplot(runit_YP4_6750_0001$lri.dat11.flow.unit, runit_YP4_6720_6750$lri.dat11.flow.unit, runit_YP3_6670_6720$lri.dat11.flow.unit,
        runit_YP1_6680_6670$lri.dat11.flow.unit, runit_YP1_6570_6680$lri.dat11.flow.unit, runit_YP3_6690_6720$lri.dat11.flow.unit,
        runit_YP3_6470_6690$lri.dat11.flow.unit, runit_YP3_6700_6670$lri.dat11.flow.unit, runit_YP3_6330_6700$lri.dat11.flow.unit,
        runit_YP2_6390_6330$lri.dat11.flow.unit, ylim = c(0,3.5),
        names = pamu.up, las = 2, cex.axis = 1.4)
dev.off()

png(filename = 'rapp.png', width = 800, height = 600)
par(mar = c(10.1, 3.1, 1.1, 1.1))
boxplot(runit_RU5_6030_0001$lri.dat11.flow.unit, runit_RU4_5640_6030$lri.dat11.flow.unit, runit_RU2_5220_5640$lri.dat11.flow.unit,
        runit_RU4_6040_6030$lri.dat11.flow.unit, runit_RU3_6170_6040$lri.dat11.flow.unit, runit_RU2_6200_6170$lri.dat11.flow.unit,
        runit_RU2_5940_6200$lri.dat11.flow.unit, runit_RU3_5610_5640$lri.dat11.flow.unit, runit_RU2_5500_5610$lri.dat11.flow.unit,
        runit_RU2_6220_6170$lri.dat11.flow.unit, runit_RU2_6090_6220$lri.dat11.flow.unit, runit_RU2_5810_5610$lri.dat11.flow.unit, 
        ylim = c(0,3.5),
        names = rapp.up, las = 2, cex.axis = 1.4)
dev.off()

png(filename = 'appo.png', width = 800, height = 600)
par(mar = c(10.1, 3.1, 1.1, 1.1))
boxplot(runit_JA5_7480_0001$lri.dat11.flow.unit, runit_JA2_7570_7480$lri.dat11.flow.unit, runit_JA1_7600_7570$lri.dat11.flow.unit,
        runit_JA4_7470_7480$lri.dat11.flow.unit, runit_JA2_7410_7470$lri.dat11.flow.unit, runit_JA4_7340_7470$lri.dat11.flow.unit,
        runit_JA4_7280_7340$lri.dat11.flow.unit, runit_JA1_7640_7280$lri.dat11.flow.unit, runit_JA2_7550_7280$lri.dat11.flow.unit,
        ylim = c(0,3.5),
        names = appo.up, las = 2, cex.axis = 1.4)
dev.off()

png(filename = 'jame.up.png', width = 800, height = 600)
par(mar = c(10.1, 3.1, 1.1, 1.1))
boxplot(runit_JU5_7420_7160$lri.dat11.flow.unit, runit_JU5_7500_7420$lri.dat11.flow.unit, runit_JU1_7560_7500$lri.dat11.flow.unit,
        runit_JU1_7750_7560$lri.dat11.flow.unit, runit_JU5_7510_7500$lri.dat11.flow.unit, runit_JU3_7400_7510$lri.dat11.flow.unit,
        runit_JU3_7490_7400$lri.dat11.flow.unit, runit_JU1_7630_7490$lri.dat11.flow.unit, runit_JU5_7300_7510$lri.dat11.flow.unit,
        runit_JU3_6650_7300$lri.dat11.flow.unit, runit_JU1_6300_6650$lri.dat11.flow.unit, runit_JU1_7690_7490$lri.dat11.flow.unit,
        runit_JU4_7000_7300$lri.dat11.flow.unit, runit_JU2_7360_7000$lri.dat11.flow.unit, runit_JU2_7450_7360$lri.dat11.flow.unit,
        runit_JU1_6340_6650$lri.dat11.flow.unit, runit_JU4_7330_7000$lri.dat11.flow.unit, runit_JU2_7140_7330$lri.dat11.flow.unit,
        runit_JU3_6950_7330$lri.dat11.flow.unit, runit_JU3_6900_6950$lri.dat11.flow.unit, runit_JU2_6810_6900$lri.dat11.flow.unit,
        runit_JU2_6600_6810$lri.dat11.flow.unit, runit_JU1_6590_6600$lri.dat11.flow.unit, runit_JU1_6290_6590$lri.dat11.flow.unit,
        runit_JU3_6380_6900$lri.dat11.flow.unit, runit_JU4_7380_7160$lri.dat11.flow.unit, runit_JU2_7180_7380$lri.dat11.flow.unit,
        runit_JU4_7260_7380$lri.dat11.flow.unit, runit_JU1_6880_7260$lri.dat11.flow.unit, runit_JU3_6790_7260$lri.dat11.flow.unit,
        runit_JU3_6640_6790$lri.dat11.flow.unit, runit_JU2_6410_6640$lri.dat11.flow.unit, ylim = c(0,3.5),
        names = jame.up.up, las = 2, cex.axis = 1.4)
dev.off()

png(filename = 'jame.mid.png', width = 800, height = 600)
par(mar = c(10.1, 3.1, 1.1, 1.1))
boxplot(runit_JL7_7070_0001$lri.dat11.flow.unit, runit_JL7_6800_7070$lri.dat11.flow.unit, runit_JL1_7170_6800$lri.dat11.flow.unit,
        runit_JL7_7030_6800$lri.dat11.flow.unit, runit_JL7_7100_7030$lri.dat11.flow.unit, runit_JL3_7020_7100$lri.dat11.flow.unit,
        runit_JL6_6740_7100$lri.dat11.flow.unit, runit_JL4_6710_6740$lri.dat11.flow.unit, runit_JL4_6520_6710$lri.dat11.flow.unit,
        runit_JL2_6240_6520$lri.dat11.flow.unit, runit_JL6_6970_6740$lri.dat11.flow.unit, runit_JL2_7120_6970$lri.dat11.flow.unit,
        runit_JL2_7110_7120$lri.dat11.flow.unit, runit_JL2_6441_6520$lri.dat11.flow.unit, runit_JL2_6440_6441$lri.dat11.flow.unit,
        runit_JL1_6560_6440$lri.dat11.flow.unit, runit_JL6_6960_6970$lri.dat11.flow.unit, runit_JL1_6910_6960$lri.dat11.flow.unit,
        runit_JL1_6760_6910$lri.dat11.flow.unit, runit_JL6_6990_6960$lri.dat11.flow.unit, runit_JL6_6890_6990$lri.dat11.flow.unit,
        runit_JL2_6850_6890$lri.dat11.flow.unit, runit_JL1_6770_6850$lri.dat11.flow.unit, runit_JL6_7150_6890$lri.dat11.flow.unit,
        runit_JL3_7090_7150$lri.dat11.flow.unit, runit_JL2_7250_7090$lri.dat11.flow.unit, runit_JL1_7190_7250$lri.dat11.flow.unit,
        runit_JL1_7080_7190$lri.dat11.flow.unit, runit_JL6_7320_7150$lri.dat11.flow.unit, runit_JL6_7430_7320$lri.dat11.flow.unit,
        runit_JL1_7530_7430$lri.dat11.flow.unit, runit_JL2_7350_7090$lri.dat11.flow.unit, runit_JL2_7240_7350$lri.dat11.flow.unit,
        runit_JL1_7200_7250$lri.dat11.flow.unit, runit_JL1_6940_7200$lri.dat11.flow.unit, runit_JL6_7440_7430$lri.dat11.flow.unit,
        runit_JL6_7160_7440$lri.dat11.flow.unit, ylim = c(0,3.5),
        names = jame.up.mid, las = 2, cex.axis = 1.4)
dev.off()

shen.11 <- as.numeric(Reduce(c, list(runit_PS5_4370_4150$lri.dat11.flow.unit, runit_PS5_4380_4370$lri.dat11.flow.unit, runit_PS4_5080_4380$lri.dat11.flow.unit,
                       runit_PS1_4830_5080$lri.dat11.flow.unit, runit_PS1_4790_4830$lri.dat11.flow.unit, runit_PS5_5200_4380$lri.dat11.flow.unit,
                       runit_PS5_5240_5200$lri.dat11.flow.unit, runit_PS4_5840_5240$lri.dat11.flow.unit, runit_PS4_6360_5840$lri.dat11.flow.unit,
                       runit_PS2_6420_6360$lri.dat11.flow.unit, runit_PS2_6490_6420$lri.dat11.flow.unit, runit_PS2_6660_6490$lri.dat11.flow.unit,
                       runit_PS2_6730_6660$lri.dat11.flow.unit, runit_PS3_5100_5080$lri.dat11.flow.unit, runit_PS2_5560_5100$lri.dat11.flow.unit,
                       runit_PS2_5550_5560$lri.dat11.flow.unit, runit_PS4_6230_6360$lri.dat11.flow.unit, runit_PS3_6280_6230$lri.dat11.flow.unit,
                       runit_PS3_6161_6280$lri.dat11.flow.unit, runit_PS0_6160_6161$lri.dat11.flow.unit, runit_PS0_6150_6160$lri.dat11.flow.unit,
                       runit_PS3_6460_6230$lri.dat11.flow.unit, runit_PS3_5990_6161$lri.dat11.flow.unit)))
matt.11 <- as.numeric(Reduce(c, list(runit_YM4_6620_0001$lri.dat11.flow.unit, runit_YM1_6370_6620$lri.dat11.flow.unit, runit_YM3_6430_6620$lri.dat11.flow.unit,
                             runit_YM2_6120_6430$lri.dat11.flow.unit)))
pamu.11 <- as.numeric(Reduce(c, list(runit_YP4_6750_0001$lri.dat11.flow.unit, runit_YP4_6720_6750$lri.dat11.flow.unit, runit_YP3_6670_6720$lri.dat11.flow.unit,
                                     runit_YP1_6680_6670$lri.dat11.flow.unit, runit_YP1_6570_6680$lri.dat11.flow.unit, runit_YP3_6690_6720$lri.dat11.flow.unit,
                                     runit_YP3_6470_6690$lri.dat11.flow.unit, runit_YP3_6700_6670$lri.dat11.flow.unit, runit_YP3_6330_6700$lri.dat11.flow.unit,
                                     runit_YP2_6390_6330$lri.dat11.flow.unit)))
rapp.11 <- as.numeric(Reduce(c, list(runit_RU5_6030_0001$lri.dat11.flow.unit, runit_RU4_5640_6030$lri.dat11.flow.unit, runit_RU2_5220_5640$lri.dat11.flow.unit,
                                     runit_RU4_6040_6030$lri.dat11.flow.unit, runit_RU3_6170_6040$lri.dat11.flow.unit, runit_RU2_6200_6170$lri.dat11.flow.unit,
                                     runit_RU2_5940_6200$lri.dat11.flow.unit, runit_RU3_5610_5640$lri.dat11.flow.unit, runit_RU2_5500_5610$lri.dat11.flow.unit,
                                     runit_RU2_6220_6170$lri.dat11.flow.unit, runit_RU2_6090_6220$lri.dat11.flow.unit, runit_RU2_5810_5610$lri.dat11.flow.unit)))
jame.up.11 <- as.numeric(Reduce(c, list(runit_JU5_7420_7160$lri.dat11.flow.unit, runit_JU5_7500_7420$lri.dat11.flow.unit, runit_JU1_7560_7500$lri.dat11.flow.unit,
                                        runit_JU1_7750_7560$lri.dat11.flow.unit, runit_JU5_7510_7500$lri.dat11.flow.unit, runit_JU3_7400_7510$lri.dat11.flow.unit,
                                        runit_JU3_7490_7400$lri.dat11.flow.unit, runit_JU1_7630_7490$lri.dat11.flow.unit, runit_JU5_7300_7510$lri.dat11.flow.unit,
                                        runit_JU3_6650_7300$lri.dat11.flow.unit, runit_JU1_6300_6650$lri.dat11.flow.unit, runit_JU1_7690_7490$lri.dat11.flow.unit,
                                        runit_JU4_7000_7300$lri.dat11.flow.unit, runit_JU2_7360_7000$lri.dat11.flow.unit, runit_JU2_7450_7360$lri.dat11.flow.unit,
                                        runit_JU1_6340_6650$lri.dat11.flow.unit, runit_JU4_7330_7000$lri.dat11.flow.unit, runit_JU2_7140_7330$lri.dat11.flow.unit,
                                        runit_JU3_6950_7330$lri.dat11.flow.unit, runit_JU3_6900_6950$lri.dat11.flow.unit, runit_JU2_6810_6900$lri.dat11.flow.unit,
                                        runit_JU2_6600_6810$lri.dat11.flow.unit, runit_JU1_6590_6600$lri.dat11.flow.unit, runit_JU1_6290_6590$lri.dat11.flow.unit,
                                        runit_JU3_6380_6900$lri.dat11.flow.unit, runit_JU4_7380_7160$lri.dat11.flow.unit, runit_JU2_7180_7380$lri.dat11.flow.unit,
                                        runit_JU4_7260_7380$lri.dat11.flow.unit, runit_JU1_6880_7260$lri.dat11.flow.unit, runit_JU3_6790_7260$lri.dat11.flow.unit,
                                        runit_JU3_6640_6790$lri.dat11.flow.unit, runit_JU2_6410_6640$lri.dat11.flow.unit)))
jame.mid.11 <- as.numeric(Reduce(c, list(runit_JL7_7070_0001$lri.dat11.flow.unit, runit_JL7_6800_7070$lri.dat11.flow.unit, runit_JL1_7170_6800$lri.dat11.flow.unit,
                                         runit_JL7_7030_6800$lri.dat11.flow.unit, runit_JL7_7100_7030$lri.dat11.flow.unit, runit_JL3_7020_7100$lri.dat11.flow.unit,
                                         runit_JL6_6740_7100$lri.dat11.flow.unit, runit_JL4_6710_6740$lri.dat11.flow.unit, runit_JL4_6520_6710$lri.dat11.flow.unit,
                                         runit_JL2_6240_6520$lri.dat11.flow.unit, runit_JL6_6970_6740$lri.dat11.flow.unit, runit_JL2_7120_6970$lri.dat11.flow.unit,
                                         runit_JL2_7110_7120$lri.dat11.flow.unit, runit_JL2_6441_6520$lri.dat11.flow.unit, runit_JL2_6440_6441$lri.dat11.flow.unit,
                                         runit_JL1_6560_6440$lri.dat11.flow.unit, runit_JL6_6960_6970$lri.dat11.flow.unit, runit_JL1_6910_6960$lri.dat11.flow.unit,
                                         runit_JL1_6760_6910$lri.dat11.flow.unit, runit_JL6_6990_6960$lri.dat11.flow.unit, runit_JL6_6890_6990$lri.dat11.flow.unit,
                                         runit_JL2_6850_6890$lri.dat11.flow.unit, runit_JL1_6770_6850$lri.dat11.flow.unit, runit_JL6_7150_6890$lri.dat11.flow.unit,
                                         runit_JL3_7090_7150$lri.dat11.flow.unit, runit_JL2_7250_7090$lri.dat11.flow.unit, runit_JL1_7190_7250$lri.dat11.flow.unit,
                                         runit_JL1_7080_7190$lri.dat11.flow.unit, runit_JL6_7320_7150$lri.dat11.flow.unit, runit_JL6_7430_7320$lri.dat11.flow.unit,
                                         runit_JL1_7530_7430$lri.dat11.flow.unit, runit_JL2_7350_7090$lri.dat11.flow.unit, runit_JL2_7240_7350$lri.dat11.flow.unit,
                                         runit_JL1_7200_7250$lri.dat11.flow.unit, runit_JL1_6940_7200$lri.dat11.flow.unit, runit_JL6_7440_7430$lri.dat11.flow.unit,
                                         runit_JL6_7160_7440$lri.dat11.flow.unit)))
appo.11 <- as.numeric(Reduce(c, list(runit_JA5_7480_0001$lri.dat11.flow.unit, runit_JA2_7570_7480$lri.dat11.flow.unit, runit_JA1_7600_7570$lri.dat11.flow.unit,
                                     runit_JA4_7470_7480$lri.dat11.flow.unit, runit_JA2_7410_7470$lri.dat11.flow.unit, runit_JA4_7340_7470$lri.dat11.flow.unit,
                                     runit_JA4_7280_7340$lri.dat11.flow.unit, runit_JA1_7640_7280$lri.dat11.flow.unit, runit_JA2_7550_7280$lri.dat11.flow.unit)))

shen.14 <- as.numeric(Reduce(c, list(runit_PS5_4370_4150$lri.dat14.flow.unit, runit_PS5_4380_4370$lri.dat14.flow.unit, runit_PS4_5080_4380$lri.dat14.flow.unit,
                                     runit_PS1_4830_5080$lri.dat14.flow.unit, runit_PS1_4790_4830$lri.dat14.flow.unit, runit_PS5_5200_4380$lri.dat14.flow.unit,
                                     runit_PS5_5240_5200$lri.dat14.flow.unit, runit_PS4_5840_5240$lri.dat14.flow.unit, runit_PS4_6360_5840$lri.dat14.flow.unit,
                                     runit_PS2_6420_6360$lri.dat14.flow.unit, runit_PS2_6490_6420$lri.dat14.flow.unit, runit_PS2_6660_6490$lri.dat14.flow.unit,
                                     runit_PS2_6730_6660$lri.dat14.flow.unit, runit_PS3_5100_5080$lri.dat14.flow.unit, runit_PS2_5560_5100$lri.dat14.flow.unit,
                                     runit_PS2_5550_5560$lri.dat14.flow.unit, runit_PS4_6230_6360$lri.dat14.flow.unit, runit_PS3_6280_6230$lri.dat14.flow.unit,
                                     runit_PS3_6161_6280$lri.dat14.flow.unit, runit_PS0_6160_6161$lri.dat14.flow.unit, runit_PS0_6150_6160$lri.dat14.flow.unit,
                                     runit_PS3_6460_6230$lri.dat14.flow.unit, runit_PS3_5990_6161$lri.dat14.flow.unit)))
matt.14 <- as.numeric(Reduce(c, list(runit_YM4_6620_0001$lri.dat14.flow.unit, runit_YM1_6370_6620$lri.dat14.flow.unit, runit_YM3_6430_6620$lri.dat14.flow.unit,
                                     runit_YM2_6120_6430$lri.dat14.flow.unit)))
pamu.14 <- as.numeric(Reduce(c, list(runit_YP4_6750_0001$lri.dat14.flow.unit, runit_YP4_6720_6750$lri.dat14.flow.unit, runit_YP3_6670_6720$lri.dat14.flow.unit,
                                     runit_YP1_6680_6670$lri.dat14.flow.unit, runit_YP1_6570_6680$lri.dat14.flow.unit, runit_YP3_6690_6720$lri.dat14.flow.unit,
                                     runit_YP3_6470_6690$lri.dat14.flow.unit, runit_YP3_6700_6670$lri.dat14.flow.unit, runit_YP3_6330_6700$lri.dat14.flow.unit,
                                     runit_YP2_6390_6330$lri.dat14.flow.unit)))
rapp.14 <- as.numeric(Reduce(c, list(runit_RU5_6030_0001$lri.dat14.flow.unit, runit_RU4_5640_6030$lri.dat14.flow.unit, runit_RU2_5220_5640$lri.dat14.flow.unit,
                                     runit_RU4_6040_6030$lri.dat14.flow.unit, runit_RU3_6170_6040$lri.dat14.flow.unit, runit_RU2_6200_6170$lri.dat14.flow.unit,
                                     runit_RU2_5940_6200$lri.dat14.flow.unit, runit_RU3_5610_5640$lri.dat14.flow.unit, runit_RU2_5500_5610$lri.dat14.flow.unit,
                                     runit_RU2_6220_6170$lri.dat14.flow.unit, runit_RU2_6090_6220$lri.dat14.flow.unit, runit_RU2_5810_5610$lri.dat14.flow.unit)))
jame.up.14 <- as.numeric(Reduce(c, list(runit_JU5_7420_7160$lri.dat14.flow.unit, runit_JU5_7500_7420$lri.dat14.flow.unit, runit_JU1_7560_7500$lri.dat14.flow.unit,
                                        runit_JU1_7750_7560$lri.dat14.flow.unit, runit_JU5_7510_7500$lri.dat14.flow.unit, runit_JU3_7400_7510$lri.dat14.flow.unit,
                                        runit_JU3_7490_7400$lri.dat14.flow.unit, runit_JU1_7630_7490$lri.dat14.flow.unit, runit_JU5_7300_7510$lri.dat14.flow.unit,
                                        runit_JU3_6650_7300$lri.dat14.flow.unit, runit_JU1_6300_6650$lri.dat14.flow.unit, runit_JU1_7690_7490$lri.dat14.flow.unit,
                                        runit_JU4_7000_7300$lri.dat14.flow.unit, runit_JU2_7360_7000$lri.dat14.flow.unit, runit_JU2_7450_7360$lri.dat14.flow.unit,
                                        runit_JU1_6340_6650$lri.dat14.flow.unit, runit_JU4_7330_7000$lri.dat14.flow.unit, runit_JU2_7140_7330$lri.dat14.flow.unit,
                                        runit_JU3_6950_7330$lri.dat14.flow.unit, runit_JU3_6900_6950$lri.dat14.flow.unit, runit_JU2_6810_6900$lri.dat14.flow.unit,
                                        runit_JU2_6600_6810$lri.dat14.flow.unit, runit_JU1_6590_6600$lri.dat14.flow.unit, runit_JU1_6290_6590$lri.dat14.flow.unit,
                                        runit_JU3_6380_6900$lri.dat14.flow.unit, runit_JU4_7380_7160$lri.dat14.flow.unit, runit_JU2_7180_7380$lri.dat14.flow.unit,
                                        runit_JU4_7260_7380$lri.dat14.flow.unit, runit_JU1_6880_7260$lri.dat14.flow.unit, runit_JU3_6790_7260$lri.dat14.flow.unit,
                                        runit_JU3_6640_6790$lri.dat14.flow.unit, runit_JU2_6410_6640$lri.dat14.flow.unit)))
jame.mid.14 <- as.numeric(Reduce(c, list(runit_JL7_7070_0001$lri.dat14.flow.unit, runit_JL7_6800_7070$lri.dat14.flow.unit, runit_JL1_7170_6800$lri.dat14.flow.unit,
                                         runit_JL7_7030_6800$lri.dat14.flow.unit, runit_JL7_7100_7030$lri.dat14.flow.unit, runit_JL3_7020_7100$lri.dat14.flow.unit,
                                         runit_JL6_6740_7100$lri.dat14.flow.unit, runit_JL4_6710_6740$lri.dat14.flow.unit, runit_JL4_6520_6710$lri.dat14.flow.unit,
                                         runit_JL2_6240_6520$lri.dat14.flow.unit, runit_JL6_6970_6740$lri.dat14.flow.unit, runit_JL2_7120_6970$lri.dat14.flow.unit,
                                         runit_JL2_7110_7120$lri.dat14.flow.unit, runit_JL2_6441_6520$lri.dat14.flow.unit, runit_JL2_6440_6441$lri.dat14.flow.unit,
                                         runit_JL1_6560_6440$lri.dat14.flow.unit, runit_JL6_6960_6970$lri.dat14.flow.unit, runit_JL1_6910_6960$lri.dat14.flow.unit,
                                         runit_JL1_6760_6910$lri.dat14.flow.unit, runit_JL6_6990_6960$lri.dat14.flow.unit, runit_JL6_6890_6990$lri.dat14.flow.unit,
                                         runit_JL2_6850_6890$lri.dat14.flow.unit, runit_JL1_6770_6850$lri.dat14.flow.unit, runit_JL6_7150_6890$lri.dat14.flow.unit,
                                         runit_JL3_7090_7150$lri.dat14.flow.unit, runit_JL2_7250_7090$lri.dat14.flow.unit, runit_JL1_7190_7250$lri.dat14.flow.unit,
                                         runit_JL1_7080_7190$lri.dat14.flow.unit, runit_JL6_7320_7150$lri.dat14.flow.unit, runit_JL6_7430_7320$lri.dat14.flow.unit,
                                         runit_JL1_7530_7430$lri.dat14.flow.unit, runit_JL2_7350_7090$lri.dat14.flow.unit, runit_JL2_7240_7350$lri.dat14.flow.unit,
                                         runit_JL1_7200_7250$lri.dat14.flow.unit, runit_JL1_6940_7200$lri.dat14.flow.unit, runit_JL6_7440_7430$lri.dat14.flow.unit,
                                         runit_JL6_7160_7440$lri.dat14.flow.unit)))
appo.14 <- as.numeric(Reduce(c, list(runit_JA5_7480_0001$lri.dat14.flow.unit, runit_JA2_7570_7480$lri.dat14.flow.unit, runit_JA1_7600_7570$lri.dat14.flow.unit,
                                     runit_JA4_7470_7480$lri.dat14.flow.unit, runit_JA2_7410_7470$lri.dat14.flow.unit, runit_JA4_7340_7470$lri.dat14.flow.unit,
                                     runit_JA4_7280_7340$lri.dat14.flow.unit, runit_JA1_7640_7280$lri.dat14.flow.unit, runit_JA2_7550_7280$lri.dat14.flow.unit)))

shen.15 <- as.numeric(Reduce(c, list(runit_PS5_4370_4150$lri.dat15.flow.unit, runit_PS5_4380_4370$lri.dat15.flow.unit, runit_PS4_5080_4380$lri.dat15.flow.unit,
                                     runit_PS1_4830_5080$lri.dat15.flow.unit, runit_PS1_4790_4830$lri.dat15.flow.unit, runit_PS5_5200_4380$lri.dat15.flow.unit,
                                     runit_PS5_5240_5200$lri.dat15.flow.unit, runit_PS4_5840_5240$lri.dat15.flow.unit, runit_PS4_6360_5840$lri.dat15.flow.unit,
                                     runit_PS2_6420_6360$lri.dat15.flow.unit, runit_PS2_6490_6420$lri.dat15.flow.unit, runit_PS2_6660_6490$lri.dat15.flow.unit,
                                     runit_PS2_6730_6660$lri.dat15.flow.unit, runit_PS3_5100_5080$lri.dat15.flow.unit, runit_PS2_5560_5100$lri.dat15.flow.unit,
                                     runit_PS2_5550_5560$lri.dat15.flow.unit, runit_PS4_6230_6360$lri.dat15.flow.unit, runit_PS3_6280_6230$lri.dat15.flow.unit,
                                     runit_PS3_6161_6280$lri.dat15.flow.unit, runit_PS0_6160_6161$lri.dat15.flow.unit, runit_PS0_6150_6160$lri.dat15.flow.unit,
                                     runit_PS3_6460_6230$lri.dat15.flow.unit, runit_PS3_5990_6161$lri.dat15.flow.unit)))
matt.15 <- as.numeric(Reduce(c, list(runit_YM4_6620_0001$lri.dat15.flow.unit, runit_YM1_6370_6620$lri.dat15.flow.unit, runit_YM3_6430_6620$lri.dat15.flow.unit,
                                     runit_YM2_6120_6430$lri.dat15.flow.unit)))
pamu.15 <- as.numeric(Reduce(c, list(runit_YP4_6750_0001$lri.dat15.flow.unit, runit_YP4_6720_6750$lri.dat15.flow.unit, runit_YP3_6670_6720$lri.dat15.flow.unit,
                                     runit_YP1_6680_6670$lri.dat15.flow.unit, runit_YP1_6570_6680$lri.dat15.flow.unit, runit_YP3_6690_6720$lri.dat15.flow.unit,
                                     runit_YP3_6470_6690$lri.dat15.flow.unit, runit_YP3_6700_6670$lri.dat15.flow.unit, runit_YP3_6330_6700$lri.dat15.flow.unit,
                                     runit_YP2_6390_6330$lri.dat15.flow.unit)))
rapp.15 <- as.numeric(Reduce(c, list(runit_RU5_6030_0001$lri.dat15.flow.unit, runit_RU4_5640_6030$lri.dat15.flow.unit, runit_RU2_5220_5640$lri.dat15.flow.unit,
                                     runit_RU4_6040_6030$lri.dat15.flow.unit, runit_RU3_6170_6040$lri.dat15.flow.unit, runit_RU2_6200_6170$lri.dat15.flow.unit,
                                     runit_RU2_5940_6200$lri.dat15.flow.unit, runit_RU3_5610_5640$lri.dat15.flow.unit, runit_RU2_5500_5610$lri.dat15.flow.unit,
                                     runit_RU2_6220_6170$lri.dat15.flow.unit, runit_RU2_6090_6220$lri.dat15.flow.unit, runit_RU2_5810_5610$lri.dat15.flow.unit)))
jame.up.15 <- as.numeric(Reduce(c, list(runit_JU5_7420_7160$lri.dat15.flow.unit, runit_JU5_7500_7420$lri.dat15.flow.unit, runit_JU1_7560_7500$lri.dat15.flow.unit,
                                        runit_JU1_7750_7560$lri.dat15.flow.unit, runit_JU5_7510_7500$lri.dat15.flow.unit, runit_JU3_7400_7510$lri.dat15.flow.unit,
                                        runit_JU3_7490_7400$lri.dat15.flow.unit, runit_JU1_7630_7490$lri.dat15.flow.unit, runit_JU5_7300_7510$lri.dat15.flow.unit,
                                        runit_JU3_6650_7300$lri.dat15.flow.unit, runit_JU1_6300_6650$lri.dat15.flow.unit, runit_JU1_7690_7490$lri.dat15.flow.unit,
                                        runit_JU4_7000_7300$lri.dat15.flow.unit, runit_JU2_7360_7000$lri.dat15.flow.unit, runit_JU2_7450_7360$lri.dat15.flow.unit,
                                        runit_JU1_6340_6650$lri.dat15.flow.unit, runit_JU4_7330_7000$lri.dat15.flow.unit, runit_JU2_7140_7330$lri.dat15.flow.unit,
                                        runit_JU3_6950_7330$lri.dat15.flow.unit, runit_JU3_6900_6950$lri.dat15.flow.unit, runit_JU2_6810_6900$lri.dat15.flow.unit,
                                        runit_JU2_6600_6810$lri.dat15.flow.unit, runit_JU1_6590_6600$lri.dat15.flow.unit, runit_JU1_6290_6590$lri.dat15.flow.unit,
                                        runit_JU3_6380_6900$lri.dat15.flow.unit, runit_JU4_7380_7160$lri.dat15.flow.unit, runit_JU2_7180_7380$lri.dat15.flow.unit,
                                        runit_JU4_7260_7380$lri.dat15.flow.unit, runit_JU1_6880_7260$lri.dat15.flow.unit, runit_JU3_6790_7260$lri.dat15.flow.unit,
                                        runit_JU3_6640_6790$lri.dat15.flow.unit, runit_JU2_6410_6640$lri.dat15.flow.unit)))
jame.mid.15 <- as.numeric(Reduce(c, list(runit_JL7_7070_0001$lri.dat15.flow.unit, runit_JL7_6800_7070$lri.dat15.flow.unit, runit_JL1_7170_6800$lri.dat15.flow.unit,
                                         runit_JL7_7030_6800$lri.dat15.flow.unit, runit_JL7_7100_7030$lri.dat15.flow.unit, runit_JL3_7020_7100$lri.dat15.flow.unit,
                                         runit_JL6_6740_7100$lri.dat15.flow.unit, runit_JL4_6710_6740$lri.dat15.flow.unit, runit_JL4_6520_6710$lri.dat15.flow.unit,
                                         runit_JL2_6240_6520$lri.dat15.flow.unit, runit_JL6_6970_6740$lri.dat15.flow.unit, runit_JL2_7120_6970$lri.dat15.flow.unit,
                                         runit_JL2_7110_7120$lri.dat15.flow.unit, runit_JL2_6441_6520$lri.dat15.flow.unit, runit_JL2_6440_6441$lri.dat15.flow.unit,
                                         runit_JL1_6560_6440$lri.dat15.flow.unit, runit_JL6_6960_6970$lri.dat15.flow.unit, runit_JL1_6910_6960$lri.dat15.flow.unit,
                                         runit_JL1_6760_6910$lri.dat15.flow.unit, runit_JL6_6990_6960$lri.dat15.flow.unit, runit_JL6_6890_6990$lri.dat15.flow.unit,
                                         runit_JL2_6850_6890$lri.dat15.flow.unit, runit_JL1_6770_6850$lri.dat15.flow.unit, runit_JL6_7150_6890$lri.dat15.flow.unit,
                                         runit_JL3_7090_7150$lri.dat15.flow.unit, runit_JL2_7250_7090$lri.dat15.flow.unit, runit_JL1_7190_7250$lri.dat15.flow.unit,
                                         runit_JL1_7080_7190$lri.dat15.flow.unit, runit_JL6_7320_7150$lri.dat15.flow.unit, runit_JL6_7430_7320$lri.dat15.flow.unit,
                                         runit_JL1_7530_7430$lri.dat15.flow.unit, runit_JL2_7350_7090$lri.dat15.flow.unit, runit_JL2_7240_7350$lri.dat15.flow.unit,
                                         runit_JL1_7200_7250$lri.dat15.flow.unit, runit_JL1_6940_7200$lri.dat15.flow.unit, runit_JL6_7440_7430$lri.dat15.flow.unit,
                                         runit_JL6_7160_7440$lri.dat15.flow.unit)))
appo.15 <- as.numeric(Reduce(c, list(runit_JA5_7480_0001$lri.dat15.flow.unit, runit_JA2_7570_7480$lri.dat15.flow.unit, runit_JA1_7600_7570$lri.dat15.flow.unit,
                                     runit_JA4_7470_7480$lri.dat15.flow.unit, runit_JA2_7410_7470$lri.dat15.flow.unit, runit_JA4_7340_7470$lri.dat15.flow.unit,
                                     runit_JA4_7280_7340$lri.dat15.flow.unit, runit_JA1_7640_7280$lri.dat15.flow.unit, runit_JA2_7550_7280$lri.dat15.flow.unit)))

shen.16 <- as.numeric(Reduce(c, list(runit_PS5_4370_4150$lri.dat16.flow.unit, runit_PS5_4380_4370$lri.dat16.flow.unit, runit_PS4_5080_4380$lri.dat16.flow.unit,
                                     runit_PS1_4830_5080$lri.dat16.flow.unit, runit_PS1_4790_4830$lri.dat16.flow.unit, runit_PS5_5200_4380$lri.dat16.flow.unit,
                                     runit_PS5_5240_5200$lri.dat16.flow.unit, runit_PS4_5840_5240$lri.dat16.flow.unit, runit_PS4_6360_5840$lri.dat16.flow.unit,
                                     runit_PS2_6420_6360$lri.dat16.flow.unit, runit_PS2_6490_6420$lri.dat16.flow.unit, runit_PS2_6660_6490$lri.dat16.flow.unit,
                                     runit_PS2_6730_6660$lri.dat16.flow.unit, runit_PS3_5100_5080$lri.dat16.flow.unit, runit_PS2_5560_5100$lri.dat16.flow.unit,
                                     runit_PS2_5550_5560$lri.dat16.flow.unit, runit_PS4_6230_6360$lri.dat16.flow.unit, runit_PS3_6280_6230$lri.dat16.flow.unit,
                                     runit_PS3_6161_6280$lri.dat16.flow.unit, runit_PS0_6160_6161$lri.dat16.flow.unit, runit_PS0_6150_6160$lri.dat16.flow.unit,
                                     runit_PS3_6460_6230$lri.dat16.flow.unit, runit_PS3_5990_6161$lri.dat16.flow.unit)))
matt.16 <- as.numeric(Reduce(c, list(runit_YM4_6620_0001$lri.dat16.flow.unit, runit_YM1_6370_6620$lri.dat16.flow.unit, runit_YM3_6430_6620$lri.dat16.flow.unit,
                                     runit_YM2_6120_6430$lri.dat16.flow.unit)))
pamu.16 <- as.numeric(Reduce(c, list(runit_YP4_6750_0001$lri.dat16.flow.unit, runit_YP4_6720_6750$lri.dat16.flow.unit, runit_YP3_6670_6720$lri.dat16.flow.unit,
                                     runit_YP1_6680_6670$lri.dat16.flow.unit, runit_YP1_6570_6680$lri.dat16.flow.unit, runit_YP3_6690_6720$lri.dat16.flow.unit,
                                     runit_YP3_6470_6690$lri.dat16.flow.unit, runit_YP3_6700_6670$lri.dat16.flow.unit, runit_YP3_6330_6700$lri.dat16.flow.unit,
                                     runit_YP2_6390_6330$lri.dat16.flow.unit)))
rapp.16 <- as.numeric(Reduce(c, list(runit_RU5_6030_0001$lri.dat16.flow.unit, runit_RU4_5640_6030$lri.dat16.flow.unit, runit_RU2_5220_5640$lri.dat16.flow.unit,
                                     runit_RU4_6040_6030$lri.dat16.flow.unit, runit_RU3_6170_6040$lri.dat16.flow.unit, runit_RU2_6200_6170$lri.dat16.flow.unit,
                                     runit_RU2_5940_6200$lri.dat16.flow.unit, runit_RU3_5610_5640$lri.dat16.flow.unit, runit_RU2_5500_5610$lri.dat16.flow.unit,
                                     runit_RU2_6220_6170$lri.dat16.flow.unit, runit_RU2_6090_6220$lri.dat16.flow.unit, runit_RU2_5810_5610$lri.dat16.flow.unit)))
jame.up.16 <- as.numeric(Reduce(c, list(runit_JU5_7420_7160$lri.dat16.flow.unit, runit_JU5_7500_7420$lri.dat16.flow.unit, runit_JU1_7560_7500$lri.dat16.flow.unit,
                                        runit_JU1_7750_7560$lri.dat16.flow.unit, runit_JU5_7510_7500$lri.dat16.flow.unit, runit_JU3_7400_7510$lri.dat16.flow.unit,
                                        runit_JU3_7490_7400$lri.dat16.flow.unit, runit_JU1_7630_7490$lri.dat16.flow.unit, runit_JU5_7300_7510$lri.dat16.flow.unit,
                                        runit_JU3_6650_7300$lri.dat16.flow.unit, runit_JU1_6300_6650$lri.dat16.flow.unit, runit_JU1_7690_7490$lri.dat16.flow.unit,
                                        runit_JU4_7000_7300$lri.dat16.flow.unit, runit_JU2_7360_7000$lri.dat16.flow.unit, runit_JU2_7450_7360$lri.dat16.flow.unit,
                                        runit_JU1_6340_6650$lri.dat16.flow.unit, runit_JU4_7330_7000$lri.dat16.flow.unit, runit_JU2_7140_7330$lri.dat16.flow.unit,
                                        runit_JU3_6950_7330$lri.dat16.flow.unit, runit_JU3_6900_6950$lri.dat16.flow.unit, runit_JU2_6810_6900$lri.dat16.flow.unit,
                                        runit_JU2_6600_6810$lri.dat16.flow.unit, runit_JU1_6590_6600$lri.dat16.flow.unit, runit_JU1_6290_6590$lri.dat16.flow.unit,
                                        runit_JU3_6380_6900$lri.dat16.flow.unit, runit_JU4_7380_7160$lri.dat16.flow.unit, runit_JU2_7180_7380$lri.dat16.flow.unit,
                                        runit_JU4_7260_7380$lri.dat16.flow.unit, runit_JU1_6880_7260$lri.dat16.flow.unit, runit_JU3_6790_7260$lri.dat16.flow.unit,
                                        runit_JU3_6640_6790$lri.dat16.flow.unit, runit_JU2_6410_6640$lri.dat16.flow.unit)))
jame.mid.16 <- as.numeric(Reduce(c, list(runit_JL7_7070_0001$lri.dat16.flow.unit, runit_JL7_6800_7070$lri.dat16.flow.unit, runit_JL1_7170_6800$lri.dat16.flow.unit,
                                         runit_JL7_7030_6800$lri.dat16.flow.unit, runit_JL7_7100_7030$lri.dat16.flow.unit, runit_JL3_7020_7100$lri.dat16.flow.unit,
                                         runit_JL6_6740_7100$lri.dat16.flow.unit, runit_JL4_6710_6740$lri.dat16.flow.unit, runit_JL4_6520_6710$lri.dat16.flow.unit,
                                         runit_JL2_6240_6520$lri.dat16.flow.unit, runit_JL6_6970_6740$lri.dat16.flow.unit, runit_JL2_7120_6970$lri.dat16.flow.unit,
                                         runit_JL2_7110_7120$lri.dat16.flow.unit, runit_JL2_6441_6520$lri.dat16.flow.unit, runit_JL2_6440_6441$lri.dat16.flow.unit,
                                         runit_JL1_6560_6440$lri.dat16.flow.unit, runit_JL6_6960_6970$lri.dat16.flow.unit, runit_JL1_6910_6960$lri.dat16.flow.unit,
                                         runit_JL1_6760_6910$lri.dat16.flow.unit, runit_JL6_6990_6960$lri.dat16.flow.unit, runit_JL6_6890_6990$lri.dat16.flow.unit,
                                         runit_JL2_6850_6890$lri.dat16.flow.unit, runit_JL1_6770_6850$lri.dat16.flow.unit, runit_JL6_7150_6890$lri.dat16.flow.unit,
                                         runit_JL3_7090_7150$lri.dat16.flow.unit, runit_JL2_7250_7090$lri.dat16.flow.unit, runit_JL1_7190_7250$lri.dat16.flow.unit,
                                         runit_JL1_7080_7190$lri.dat16.flow.unit, runit_JL6_7320_7150$lri.dat16.flow.unit, runit_JL6_7430_7320$lri.dat16.flow.unit,
                                         runit_JL1_7530_7430$lri.dat16.flow.unit, runit_JL2_7350_7090$lri.dat16.flow.unit, runit_JL2_7240_7350$lri.dat16.flow.unit,
                                         runit_JL1_7200_7250$lri.dat16.flow.unit, runit_JL1_6940_7200$lri.dat16.flow.unit, runit_JL6_7440_7430$lri.dat16.flow.unit,
                                         runit_JL6_7160_7440$lri.dat16.flow.unit)))
appo.16 <- as.numeric(Reduce(c, list(runit_JA5_7480_0001$lri.dat16.flow.unit, runit_JA2_7570_7480$lri.dat16.flow.unit, runit_JA1_7600_7570$lri.dat16.flow.unit,
                                     runit_JA4_7470_7480$lri.dat16.flow.unit, runit_JA2_7410_7470$lri.dat16.flow.unit, runit_JA4_7340_7470$lri.dat16.flow.unit,
                                     runit_JA4_7280_7340$lri.dat16.flow.unit, runit_JA1_7640_7280$lri.dat16.flow.unit, runit_JA2_7550_7280$lri.dat16.flow.unit)))

png(filename = 'shen.compare.png', width = 800, height = 600)
par(mar = c(3.1, 3.1, 1.1, 1.1))
boxplot(shen.11, shen.15, shen.14, shen.16, ylim = c(0,4), outline = F,
        names = c('Base', 'ccP10T10', 'ccP50T50', 'ccP90T90'), cex.axis = 1.4)
dev.off()

png(filename = 'matt.compare.png', width = 800, height = 600)
par(mar = c(3.1, 3.1, 1.1, 1.1))
boxplot(matt.11, matt.15, matt.14, matt.16, ylim = c(0,4), outline = F,
        names = c('Base', 'ccP10T10', 'ccP50T50', 'ccP90T90'), cex.axis = 1.4)
dev.off()

png(filename = 'pamu.compare.png', width = 800, height = 600)
par(mar = c(3.1, 3.1, 1.1, 1.1))
boxplot(pamu.11, pamu.15, pamu.14, pamu.16, ylim = c(0,4), outline = F,
        names = c('Base', 'ccP10T10', 'ccP50T50', 'ccP90T90'), cex.axis = 1.4)
dev.off()

png(filename = 'rapp.compare.png', width = 800, height = 600)
par(mar = c(3.1, 3.1, 1.1, 1.1))
boxplot(rapp.11, rapp.15, rapp.14, rapp.16, ylim = c(0,4), outline = F,
        names = c('Base', 'ccP10T10', 'ccP50T50', 'ccP90T90'), cex.axis = 1.4)
dev.off()

png(filename = 'jame.up.compare.png', width = 800, height = 600)
par(mar = c(3.1, 3.1, 1.1, 1.1))
boxplot(jame.up.11, jame.up.15, jame.up.14, jame.up.16, ylim = c(0,4), outline = F,
        names = c('Base', 'ccP10T10', 'ccP50T50', 'ccP90T90'), cex.axis = 1.4)
dev.off()

png(filename = 'jame.mid.compare.png', width = 800, height = 600)
par(mar = c(3.1, 3.1, 1.1, 1.1))
boxplot(jame.mid.11, jame.mid.15, jame.mid.14, jame.mid.16, ylim = c(0,4), outline = F,
        names = c('Base', 'ccP10T10', 'ccP50T50', 'ccP90T90'), cex.axis = 1.4)
dev.off()

png(filename = 'appo.compare.png', width = 800, height = 600)
par(mar = c(3.1, 3.1, 1.1, 1.1))
boxplot(appo.11, appo.15, appo.14, appo.16, ylim = c(0,4), outline = F,
        names = c('Base', 'ccP10T10', 'ccP50T50', 'ccP90T90'), cex.axis = 1.4)
dev.off()

png(filename = 'compare.11.png', width = 1000, height = 600)
par(mar = c(3.1, 3.1, 1.1, 1.1))
boxplot(shen.11, matt.11, pamu.11, rapp.11, jame.up.11, jame.mid.11, appo.11, ylim = c(0,4), outline = F,
        names = c('Shenadoah', 'Mattaponi', 'Pamunkey', 'Rappahannock',
                  'Upper James', 'Lower James', 'Appomattox'), cex.axis = 1.4)
dev.off()

png(filename = 'compare.15.png', width = 1000, height = 600)
par(mar = c(3.1, 3.1, 1.1, 1.1))
boxplot(shen.15, matt.15, pamu.15, rapp.15, jame.up.15, jame.mid.15, appo.15, ylim = c(0,4), outline = F,
        names = c('Shenadoah', 'Mattaponi', 'Pamunkey', 'Rappahannock',
                  'Upper James', 'Lower James', 'Appomattox'), cex.axis = 1.4)
dev.off()

png(filename = 'compare.14.png', width = 1000, height = 600)
par(mar = c(3.1, 3.1, 1.1, 1.1))
boxplot(shen.14, matt.14, pamu.14, rapp.14, jame.up.14, jame.mid.14, appo.14, ylim = c(0,4), outline = F,
        names = c('Shenadoah', 'Mattaponi', 'Pamunkey', 'Rappahannock',
                  'Upper James', 'Lower James', 'Appomattox'), cex.axis = 1.4)
dev.off()

png(filename = 'compare.16.png', width = 1000, height = 600)
par(mar = c(3.1, 3.1, 1.1, 1.1))
boxplot(shen.16, matt.16, pamu.16, rapp.16, jame.up.16, jame.mid.16, appo.16, ylim = c(0,4), outline = F,
        names = c('Shenadoah', 'Mattaponi', 'Pamunkey', 'Rappahannock',
                  'Upper James', 'Lower James', 'Appomattox'), cex.axis = 1.4)
dev.off()

(median(shen.15)-median(shen.11))/median(shen.11)*100
(median(pamu.15)-median(pamu.11))/median(pamu.11)*100
(median(matt.15)-median(matt.11))/median(matt.11)*100
(median(rapp.15)-median(rapp.11))/median(rapp.11)*100
(median(jame.up.15)-median(jame.up.11))/median(jame.up.11)*100
(median(jame.mid.15)-median(jame.mid.11))/median(jame.mid.11)*100
(median(appo.15)-median(appo.11))/median(appo.11)*100

(mean(shen.15)-mean(shen.11))/mean(shen.11)*100
(mean(pamu.15)-mean(pamu.11))/mean(pamu.11)*100
(mean(matt.15)-mean(matt.11))/mean(matt.11)*100
(mean(rapp.15)-mean(rapp.11))/mean(rapp.11)*100
(mean(jame.up.15)-mean(jame.up.11))/mean(jame.up.11)*100
(mean(jame.mid.15)-mean(jame.mid.11))/mean(jame.mid.11)*100
(mean(appo.15)-mean(appo.11))/mean(appo.11)*100

(median(shen.14)-median(shen.11))/median(shen.11)*100
(median(pamu.14)-median(pamu.11))/median(pamu.11)*100
(median(matt.14)-median(matt.11))/median(matt.11)*100
(median(rapp.14)-median(rapp.11))/median(rapp.11)*100
(median(jame.up.14)-median(jame.up.11))/median(jame.up.11)*100
(median(jame.mid.14)-median(jame.mid.11))/median(jame.mid.11)*100
(median(appo.14)-median(appo.11))/median(appo.11)*100

(mean(shen.14)-mean(shen.11))/mean(shen.11)*100
(mean(pamu.14)-mean(pamu.11))/mean(pamu.11)*100
(mean(matt.14)-mean(matt.11))/mean(matt.11)*100
(mean(rapp.14)-mean(rapp.11))/mean(rapp.11)*100
(mean(jame.up.14)-mean(jame.up.11))/mean(jame.up.11)*100
(mean(jame.mid.14)-mean(jame.mid.11))/mean(jame.mid.11)*100
(mean(appo.14)-mean(appo.11))/mean(appo.11)*100

(median(shen.16)-median(shen.11))/median(shen.11)*100
(median(pamu.16)-median(pamu.11))/median(pamu.11)*100
(median(matt.16)-median(matt.11))/median(matt.11)*100
(median(rapp.16)-median(rapp.11))/median(rapp.11)*100
(median(jame.up.16)-median(jame.up.11))/median(jame.up.11)*100
(median(jame.mid.16)-median(jame.mid.11))/median(jame.mid.11)*100
(median(appo.16)-median(appo.11))/median(appo.11)*100

(mean(shen.16)-mean(shen.11))/mean(shen.11)*100
(mean(pamu.16)-mean(pamu.11))/mean(pamu.11)*100
(mean(matt.16)-mean(matt.11))/mean(matt.11)*100
(mean(rapp.16)-mean(rapp.11))/mean(rapp.11)*100
(mean(jame.up.16)-mean(jame.up.11))/mean(jame.up.11)*100
(mean(jame.mid.16)-mean(jame.mid.11))/mean(jame.mid.11)*100
(mean(appo.16)-mean(appo.11))/mean(appo.11)*100

# NEW SECTION
shen.mets.11 <- data.frame(matrix(data = NA, nrow = length(shen.up), ncol = 8))
colnames(shen.mets.11) <- c('River Segment', 'Q5 (cfs/sq mi)', 'Q10 (cfs/sq mi)', 
                            'Q25 (cfs/sq mi)', 'Q50 (cfs/sq mi)', 'Q75 (cfs/sq mi)',
                            'Q90 (cfs/sq mi)', 'Q95 (cfs/sq mi)')
shen.mets.14 <- shen.mets.11
shen.mets.15 <- shen.mets.11
shen.mets.16 <- shen.mets.11

for (i in 1:length(shen.up)) {
  riv.seg <- shen.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("runit_", riv.seg)
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$lri.dat11.flow.unit)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$lri.dat14.flow.unit)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$lri.dat15.flow.unit)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$lri.dat16.flow.unit)
  colnames(data.16) <- c('date', 'flow')
  
  shen.mets.11$`River Segment`[i] <- riv.seg
  shen.mets.11$`Q5 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.05)
  shen.mets.11$`Q10 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.1)
  shen.mets.11$`Q25 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.25)
  shen.mets.11$`Q50 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.50)
  shen.mets.11$`Q75 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.75)
  shen.mets.11$`Q90 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.90)
  shen.mets.11$`Q95 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.95)
  
  shen.mets.14$`River Segment`[i] <- riv.seg
  shen.mets.14$`Q5 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.05)
  shen.mets.14$`Q10 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.1)
  shen.mets.14$`Q25 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.25)
  shen.mets.14$`Q50 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.50)
  shen.mets.14$`Q75 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.75)
  shen.mets.14$`Q90 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.90)
  shen.mets.14$`Q95 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.95)
  
  shen.mets.15$`River Segment`[i] <- riv.seg
  shen.mets.15$`Q5 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.05)
  shen.mets.15$`Q10 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.1)
  shen.mets.15$`Q25 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.25)
  shen.mets.15$`Q50 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.50)
  shen.mets.15$`Q75 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.75)
  shen.mets.15$`Q90 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.90)
  shen.mets.15$`Q95 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.95)
  
  shen.mets.16$`River Segment`[i] <- riv.seg
  shen.mets.16$`Q5 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.05)
  shen.mets.16$`Q10 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.1)
  shen.mets.16$`Q25 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.25)
  shen.mets.16$`Q50 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.50)
  shen.mets.16$`Q75 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.75)
  shen.mets.16$`Q90 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.90)
  shen.mets.16$`Q95 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.95)
}

shen.mets.11.out <- shen.mets.11
shen.mets.11.out[,2:8] <- round(shen.mets.11.out[,2:8], 2)
shen.mets.14.out <- shen.mets.14
shen.mets.14.out[,2:8] <- round(shen.mets.14.out[,2:8], 2)
shen.mets.15.out <- shen.mets.15
shen.mets.15.out[,2:8] <- round(shen.mets.15.out[,2:8], 2)
shen.mets.16.out <- shen.mets.16
shen.mets.16.out[,2:8] <- round(shen.mets.16.out[,2:8], 2)


kable(shen.mets.11.out,  booktabs = T,
      caption = "Runoff Quantiles in Shenandoah River Segments (Base Scenario)",
      label = "runit.shenqoutbase",
      col.names = colnames(shen.mets.11)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.shen.mets.11",file_ext,sep=""))

kable(shen.mets.14.out,  booktabs = T,
      caption = "Runoff Quantiles in Shenandoah River Segments (ccP50T50 Scenario)",
      label = "runit.shenqout50",
      col.names = colnames(shen.mets.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.shen.mets.14",file_ext,sep=""))

kable(shen.mets.15.out,  booktabs = T,
      caption = "Runoff Quantiles in Shenandoah River Segments (ccP10T10 Scenario)",
      label = "runit.shenqout10",
      col.names = colnames(shen.mets.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.shen.mets.15",file_ext,sep=""))

kable(shen.mets.16.out,  booktabs = T,
      caption = "Runoff Quantiles in Shenandoah River Segments (ccP90T90 Scenario)",
      label = "runit.shenqout90",
      col.names = colnames(shen.mets.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.shen.mets.16",file_ext,sep=""))


matt.mets.11 <- data.frame(matrix(data = NA, nrow = length(matt.up), ncol = 8))
colnames(matt.mets.11) <- c('River Segment', 'Q5 (cfs/sq mi)', 'Q10 (cfs/sq mi)', 
                            'Q25 (cfs/sq mi)', 'Q50 (cfs/sq mi)', 'Q75 (cfs/sq mi)',
                            'Q90 (cfs/sq mi)', 'Q95 (cfs/sq mi)')
matt.mets.14 <- matt.mets.11
matt.mets.15 <- matt.mets.11
matt.mets.16 <- matt.mets.11

for (i in 1:length(matt.up)) {
  riv.seg <- matt.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("runit_", riv.seg)
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$lri.dat11.flow.unit)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$lri.dat14.flow.unit)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$lri.dat15.flow.unit)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$lri.dat16.flow.unit)
  colnames(data.16) <- c('date', 'flow')
  
  matt.mets.11$`River Segment`[i] <- riv.seg
  matt.mets.11$`Q5 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.05)
  matt.mets.11$`Q10 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.1)
  matt.mets.11$`Q25 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.25)
  matt.mets.11$`Q50 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.50)
  matt.mets.11$`Q75 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.75)
  matt.mets.11$`Q90 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.90)
  matt.mets.11$`Q95 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.95)
  
  matt.mets.14$`River Segment`[i] <- riv.seg
  matt.mets.14$`Q5 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.05)
  matt.mets.14$`Q10 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.1)
  matt.mets.14$`Q25 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.25)
  matt.mets.14$`Q50 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.50)
  matt.mets.14$`Q75 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.75)
  matt.mets.14$`Q90 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.90)
  matt.mets.14$`Q95 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.95)
  
  matt.mets.15$`River Segment`[i] <- riv.seg
  matt.mets.15$`Q5 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.05)
  matt.mets.15$`Q10 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.1)
  matt.mets.15$`Q25 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.25)
  matt.mets.15$`Q50 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.50)
  matt.mets.15$`Q75 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.75)
  matt.mets.15$`Q90 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.90)
  matt.mets.15$`Q95 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.95)
  
  matt.mets.16$`River Segment`[i] <- riv.seg
  matt.mets.16$`Q5 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.05)
  matt.mets.16$`Q10 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.1)
  matt.mets.16$`Q25 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.25)
  matt.mets.16$`Q50 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.50)
  matt.mets.16$`Q75 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.75)
  matt.mets.16$`Q90 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.90)
  matt.mets.16$`Q95 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.95)
}

matt.mets.11.out <- matt.mets.11
matt.mets.11.out[,2:8] <- round(matt.mets.11.out[,2:8], 2)
matt.mets.14.out <- matt.mets.14
matt.mets.14.out[,2:8] <- round(matt.mets.14.out[,2:8], 2)
matt.mets.15.out <- matt.mets.15
matt.mets.15.out[,2:8] <- round(matt.mets.15.out[,2:8], 2)
matt.mets.16.out <- matt.mets.16
matt.mets.16.out[,2:8] <- round(matt.mets.16.out[,2:8], 2)


kable(matt.mets.11.out,  booktabs = T,
      caption = "Runoff Quantiles in Mattaponi River Segments (Base Scenario)",
      label = "runit.mattqoutbase",
      col.names = colnames(matt.mets.11)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.matt.mets.11",file_ext,sep=""))

kable(matt.mets.14.out,  booktabs = T,
      caption = "Runoff Quantiles in Mattaponi River Segments (ccP50T50 Scenario)",
      label = "runit.mattqout50",
      col.names = colnames(matt.mets.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.matt.mets.14",file_ext,sep=""))

kable(matt.mets.15.out,  booktabs = T,
      caption = "Runoff Quantiles in Mattaponi River Segments (ccP10T10 Scenario)",
      label = "runit.mattqout10",
      col.names = colnames(matt.mets.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.matt.mets.15",file_ext,sep=""))

kable(matt.mets.16.out,  booktabs = T,
      caption = "Runoff Quantiles in Mattaponi River Segments (ccP90T90 Scenario)",
      label = "runit.mattqout90",
      col.names = colnames(matt.mets.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.matt.mets.16",file_ext,sep=""))


pamu.mets.11 <- data.frame(matrix(data = NA, nrow = length(pamu.up), ncol = 8))
colnames(pamu.mets.11) <- c('River Segment', 'Q5 (cfs/sq mi)', 'Q10 (cfs/sq mi)', 
                            'Q25 (cfs/sq mi)', 'Q50 (cfs/sq mi)', 'Q75 (cfs/sq mi)',
                            'Q90 (cfs/sq mi)', 'Q95 (cfs/sq mi)')
pamu.mets.14 <- pamu.mets.11
pamu.mets.15 <- pamu.mets.11
pamu.mets.16 <- pamu.mets.11

for (i in 1:length(pamu.up)) {
  riv.seg <- pamu.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("runit_", riv.seg)
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$lri.dat11.flow.unit)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$lri.dat14.flow.unit)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$lri.dat15.flow.unit)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$lri.dat16.flow.unit)
  colnames(data.16) <- c('date', 'flow')
  
  pamu.mets.11$`River Segment`[i] <- riv.seg
  pamu.mets.11$`Q5 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.05)
  pamu.mets.11$`Q10 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.1)
  pamu.mets.11$`Q25 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.25)
  pamu.mets.11$`Q50 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.50)
  pamu.mets.11$`Q75 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.75)
  pamu.mets.11$`Q90 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.90)
  pamu.mets.11$`Q95 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.95)
  
  pamu.mets.14$`River Segment`[i] <- riv.seg
  pamu.mets.14$`Q5 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.05)
  pamu.mets.14$`Q10 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.1)
  pamu.mets.14$`Q25 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.25)
  pamu.mets.14$`Q50 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.50)
  pamu.mets.14$`Q75 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.75)
  pamu.mets.14$`Q90 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.90)
  pamu.mets.14$`Q95 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.95)
  
  pamu.mets.15$`River Segment`[i] <- riv.seg
  pamu.mets.15$`Q5 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.05)
  pamu.mets.15$`Q10 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.1)
  pamu.mets.15$`Q25 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.25)
  pamu.mets.15$`Q50 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.50)
  pamu.mets.15$`Q75 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.75)
  pamu.mets.15$`Q90 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.90)
  pamu.mets.15$`Q95 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.95)
  
  pamu.mets.16$`River Segment`[i] <- riv.seg
  pamu.mets.16$`Q5 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.05)
  pamu.mets.16$`Q10 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.1)
  pamu.mets.16$`Q25 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.25)
  pamu.mets.16$`Q50 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.50)
  pamu.mets.16$`Q75 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.75)
  pamu.mets.16$`Q90 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.90)
  pamu.mets.16$`Q95 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.95)
}

pamu.mets.11.out <- pamu.mets.11
pamu.mets.11.out[,2:8] <- round(pamu.mets.11.out[,2:8], 2)
pamu.mets.14.out <- pamu.mets.14
pamu.mets.14.out[,2:8] <- round(pamu.mets.14.out[,2:8], 2)
pamu.mets.15.out <- pamu.mets.15
pamu.mets.15.out[,2:8] <- round(pamu.mets.15.out[,2:8], 2)
pamu.mets.16.out <- pamu.mets.16
pamu.mets.16.out[,2:8] <- round(pamu.mets.16.out[,2:8], 2)


kable(pamu.mets.11.out,  booktabs = T,
      caption = "Runoff Quantiles in Pamunkey River Segments (Base Scenario)",
      label = "runit.pamuqoutbase",
      col.names = colnames(pamu.mets.11)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.pamu.mets.11",file_ext,sep=""))

kable(pamu.mets.14.out,  booktabs = T,
      caption = "Runoff Quantiles in Pamunkey River Segments (ccP50T50 Scenario)",
      label = "runit.pamuqout50",
      col.names = colnames(pamu.mets.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.pamu.mets.14",file_ext,sep=""))

kable(pamu.mets.15.out,  booktabs = T,
      caption = "Runoff Quantiles in Pamunkey River Segments (ccP10T10 Scenario)",
      label = "runit.pamuqout10",
      col.names = colnames(pamu.mets.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.pamu.mets.15",file_ext,sep=""))

kable(pamu.mets.16.out,  booktabs = T,
      caption = "Runoff Quantiles in Pamunkey River Segments (ccP90T90 Scenario)",
      label = "runit.pamuqout90",
      col.names = colnames(pamu.mets.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.pamu.mets.16",file_ext,sep=""))


rapp.mets.11 <- data.frame(matrix(data = NA, nrow = length(rapp.up), ncol = 8))
colnames(rapp.mets.11) <- c('River Segment', 'Q5 (cfs/sq mi)', 'Q10 (cfs/sq mi)', 
                            'Q25 (cfs/sq mi)', 'Q50 (cfs/sq mi)', 'Q75 (cfs/sq mi)',
                            'Q90 (cfs/sq mi)', 'Q95 (cfs/sq mi)')
rapp.mets.14 <- rapp.mets.11
rapp.mets.15 <- rapp.mets.11
rapp.mets.16 <- rapp.mets.11

for (i in 1:length(rapp.up)) {
  riv.seg <- rapp.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("runit_", riv.seg)
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$lri.dat11.flow.unit)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$lri.dat14.flow.unit)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$lri.dat15.flow.unit)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$lri.dat16.flow.unit)
  colnames(data.16) <- c('date', 'flow')
  
  rapp.mets.11$`River Segment`[i] <- riv.seg
  rapp.mets.11$`Q5 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.05)
  rapp.mets.11$`Q10 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.1)
  rapp.mets.11$`Q25 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.25)
  rapp.mets.11$`Q50 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.50)
  rapp.mets.11$`Q75 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.75)
  rapp.mets.11$`Q90 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.90)
  rapp.mets.11$`Q95 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.95)
  
  rapp.mets.14$`River Segment`[i] <- riv.seg
  rapp.mets.14$`Q5 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.05)
  rapp.mets.14$`Q10 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.1)
  rapp.mets.14$`Q25 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.25)
  rapp.mets.14$`Q50 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.50)
  rapp.mets.14$`Q75 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.75)
  rapp.mets.14$`Q90 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.90)
  rapp.mets.14$`Q95 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.95)
  
  rapp.mets.15$`River Segment`[i] <- riv.seg
  rapp.mets.15$`Q5 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.05)
  rapp.mets.15$`Q10 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.1)
  rapp.mets.15$`Q25 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.25)
  rapp.mets.15$`Q50 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.50)
  rapp.mets.15$`Q75 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.75)
  rapp.mets.15$`Q90 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.90)
  rapp.mets.15$`Q95 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.95)
  
  rapp.mets.16$`River Segment`[i] <- riv.seg
  rapp.mets.16$`Q5 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.05)
  rapp.mets.16$`Q10 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.1)
  rapp.mets.16$`Q25 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.25)
  rapp.mets.16$`Q50 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.50)
  rapp.mets.16$`Q75 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.75)
  rapp.mets.16$`Q90 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.90)
  rapp.mets.16$`Q95 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.95)
}

rapp.mets.11.out <- rapp.mets.11
rapp.mets.11.out[,2:8] <- round(rapp.mets.11.out[,2:8], 2)
rapp.mets.14.out <- rapp.mets.14
rapp.mets.14.out[,2:8] <- round(rapp.mets.14.out[,2:8], 2)
rapp.mets.15.out <- rapp.mets.15
rapp.mets.15.out[,2:8] <- round(rapp.mets.15.out[,2:8], 2)
rapp.mets.16.out <- rapp.mets.16
rapp.mets.16.out[,2:8] <- round(rapp.mets.16.out[,2:8], 2)


kable(rapp.mets.11.out,  booktabs = T,
      caption = "Runoff Quantiles in Rappahannock River Segments (Base Scenario)",
      label = "runit.rappqoutbase",
      col.names = colnames(rapp.mets.11)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.rapp.mets.11",file_ext,sep=""))

kable(rapp.mets.14.out,  booktabs = T,
      caption = "Runoff Quantiles in Rappahannock River Segments (ccP50T50 Scenario)",
      label = "runit.rappqout50",
      col.names = colnames(rapp.mets.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.rapp.mets.14",file_ext,sep=""))

kable(rapp.mets.15.out,  booktabs = T,
      caption = "Runoff Quantiles in Rappahannock River Segments (ccP10T10 Scenario)",
      label = "runit.rappqout10",
      col.names = colnames(rapp.mets.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.rapp.mets.15",file_ext,sep=""))

kable(rapp.mets.16.out,  booktabs = T,
      caption = "Runoff Quantiles in Rappahannock River Segments (ccP90T90 Scenario)",
      label = "runit.rappqout90",
      col.names = colnames(rapp.mets.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.rapp.mets.16",file_ext,sep=""))


jaup.mets.11 <- data.frame(matrix(data = NA, nrow = length(jaup.up), ncol = 8))
colnames(jaup.mets.11) <- c('River Segment', 'Q5 (cfs/sq mi)', 'Q10 (cfs/sq mi)', 
                            'Q25 (cfs/sq mi)', 'Q50 (cfs/sq mi)', 'Q75 (cfs/sq mi)',
                            'Q90 (cfs/sq mi)', 'Q95 (cfs/sq mi)')
jaup.mets.14 <- jaup.mets.11
jaup.mets.15 <- jaup.mets.11
jaup.mets.16 <- jaup.mets.11

for (i in 1:length(jaup.up)) {
  riv.seg <- jaup.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("runit_", riv.seg)
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$lri.dat11.flow.unit)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$lri.dat14.flow.unit)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$lri.dat15.flow.unit)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$lri.dat16.flow.unit)
  colnames(data.16) <- c('date', 'flow')
  
  jaup.mets.11$`River Segment`[i] <- riv.seg
  jaup.mets.11$`Q5 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.05)
  jaup.mets.11$`Q10 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.1)
  jaup.mets.11$`Q25 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.25)
  jaup.mets.11$`Q50 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.50)
  jaup.mets.11$`Q75 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.75)
  jaup.mets.11$`Q90 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.90)
  jaup.mets.11$`Q95 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.95)
  
  jaup.mets.14$`River Segment`[i] <- riv.seg
  jaup.mets.14$`Q5 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.05)
  jaup.mets.14$`Q10 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.1)
  jaup.mets.14$`Q25 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.25)
  jaup.mets.14$`Q50 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.50)
  jaup.mets.14$`Q75 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.75)
  jaup.mets.14$`Q90 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.90)
  jaup.mets.14$`Q95 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.95)
  
  jaup.mets.15$`River Segment`[i] <- riv.seg
  jaup.mets.15$`Q5 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.05)
  jaup.mets.15$`Q10 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.1)
  jaup.mets.15$`Q25 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.25)
  jaup.mets.15$`Q50 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.50)
  jaup.mets.15$`Q75 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.75)
  jaup.mets.15$`Q90 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.90)
  jaup.mets.15$`Q95 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.95)
  
  jaup.mets.16$`River Segment`[i] <- riv.seg
  jaup.mets.16$`Q5 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.05)
  jaup.mets.16$`Q10 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.1)
  jaup.mets.16$`Q25 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.25)
  jaup.mets.16$`Q50 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.50)
  jaup.mets.16$`Q75 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.75)
  jaup.mets.16$`Q90 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.90)
  jaup.mets.16$`Q95 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.95)
}

jaup.mets.11.out <- jaup.mets.11
jaup.mets.11.out[,2:8] <- round(jaup.mets.11.out[,2:8], 2)
jaup.mets.14.out <- jaup.mets.14
jaup.mets.14.out[,2:8] <- round(jaup.mets.14.out[,2:8], 2)
jaup.mets.15.out <- jaup.mets.15
jaup.mets.15.out[,2:8] <- round(jaup.mets.15.out[,2:8], 2)
jaup.mets.16.out <- jaup.mets.16
jaup.mets.16.out[,2:8] <- round(jaup.mets.16.out[,2:8], 2)


kable(jaup.mets.11.out,  booktabs = T,
      caption = "Runoff Quantiles in Upper James River Segments (Base Scenario)",
      label = "runit.jaupqoutbase",
      col.names = colnames(jaup.mets.11)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.jaup.mets.11",file_ext,sep=""))

kable(jaup.mets.14.out,  booktabs = T,
      caption = "Runoff Quantiles in Upper James River Segments (ccP50T50 Scenario)",
      label = "runit.jaupqout50",
      col.names = colnames(jaup.mets.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.jaup.mets.14",file_ext,sep=""))

kable(jaup.mets.15.out,  booktabs = T,
      caption = "Runoff Quantiles in Upper James River Segments (ccP10T10 Scenario)",
      label = "runit.jaupqout10",
      col.names = colnames(jaup.mets.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.jaup.mets.15",file_ext,sep=""))

kable(jaup.mets.16.out,  booktabs = T,
      caption = "Runoff Quantiles in Upper James River Segments (ccP90T90 Scenario)",
      label = "runit.jaupqout90",
      col.names = colnames(jaup.mets.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.jaup.mets.16",file_ext,sep=""))


jami.mets.11 <- data.frame(matrix(data = NA, nrow = length(jami.up), ncol = 8))
colnames(jami.mets.11) <- c('River Segment', 'Q5 (cfs/sq mi)', 'Q10 (cfs/sq mi)', 
                            'Q25 (cfs/sq mi)', 'Q50 (cfs/sq mi)', 'Q75 (cfs/sq mi)',
                            'Q90 (cfs/sq mi)', 'Q95 (cfs/sq mi)')
jami.mets.14 <- jami.mets.11
jami.mets.15 <- jami.mets.11
jami.mets.16 <- jami.mets.11

for (i in 1:length(jami.up)) {
  riv.seg <- jami.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("runit_", riv.seg)
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$lri.dat11.flow.unit)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$lri.dat14.flow.unit)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$lri.dat15.flow.unit)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$lri.dat16.flow.unit)
  colnames(data.16) <- c('date', 'flow')
  
  jami.mets.11$`River Segment`[i] <- riv.seg
  jami.mets.11$`Q5 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.05)
  jami.mets.11$`Q10 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.1)
  jami.mets.11$`Q25 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.25)
  jami.mets.11$`Q50 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.50)
  jami.mets.11$`Q75 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.75)
  jami.mets.11$`Q90 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.90)
  jami.mets.11$`Q95 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.95)
  
  jami.mets.14$`River Segment`[i] <- riv.seg
  jami.mets.14$`Q5 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.05)
  jami.mets.14$`Q10 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.1)
  jami.mets.14$`Q25 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.25)
  jami.mets.14$`Q50 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.50)
  jami.mets.14$`Q75 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.75)
  jami.mets.14$`Q90 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.90)
  jami.mets.14$`Q95 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.95)
  
  jami.mets.15$`River Segment`[i] <- riv.seg
  jami.mets.15$`Q5 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.05)
  jami.mets.15$`Q10 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.1)
  jami.mets.15$`Q25 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.25)
  jami.mets.15$`Q50 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.50)
  jami.mets.15$`Q75 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.75)
  jami.mets.15$`Q90 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.90)
  jami.mets.15$`Q95 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.95)
  
  jami.mets.16$`River Segment`[i] <- riv.seg
  jami.mets.16$`Q5 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.05)
  jami.mets.16$`Q10 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.1)
  jami.mets.16$`Q25 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.25)
  jami.mets.16$`Q50 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.50)
  jami.mets.16$`Q75 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.75)
  jami.mets.16$`Q90 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.90)
  jami.mets.16$`Q95 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.95)
}

jami.mets.11.out <- jami.mets.11
jami.mets.11.out[,2:8] <- round(jami.mets.11.out[,2:8], 2)
jami.mets.14.out <- jami.mets.14
jami.mets.14.out[,2:8] <- round(jami.mets.14.out[,2:8], 2)
jami.mets.15.out <- jami.mets.15
jami.mets.15.out[,2:8] <- round(jami.mets.15.out[,2:8], 2)
jami.mets.16.out <- jami.mets.16
jami.mets.16.out[,2:8] <- round(jami.mets.16.out[,2:8], 2)


kable(jami.mets.11.out,  booktabs = T,
      caption = "Runoff Quantiles in Middle James River Segments (Base Scenario)",
      label = "runit.jamiqoutbase",
      col.names = colnames(jami.mets.11)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.jami.mets.11",file_ext,sep=""))

kable(jami.mets.14.out,  booktabs = T,
      caption = "Runoff Quantiles in Middle James River Segments (ccP50T50 Scenario)",
      label = "runit.jamiqout50",
      col.names = colnames(jami.mets.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.jami.mets.14",file_ext,sep=""))

kable(jami.mets.15.out,  booktabs = T,
      caption = "Runoff Quantiles in Middle James River Segments (ccP10T10 Scenario)",
      label = "runit.jamiqout10",
      col.names = colnames(jami.mets.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.jami.mets.15",file_ext,sep=""))

kable(jami.mets.16.out,  booktabs = T,
      caption = "Runoff Quantiles in Middle James River Segments (ccP90T90 Scenario)",
      label = "runit.jamiqout90",
      col.names = colnames(jami.mets.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.jami.mets.16",file_ext,sep=""))


appo.mets.11 <- data.frame(matrix(data = NA, nrow = length(appo.up), ncol = 8))
colnames(appo.mets.11) <- c('River Segment', 'Q5 (cfs/sq mi)', 'Q10 (cfs/sq mi)', 
                            'Q25 (cfs/sq mi)', 'Q50 (cfs/sq mi)', 'Q75 (cfs/sq mi)',
                            'Q90 (cfs/sq mi)', 'Q95 (cfs/sq mi)')
appo.mets.14 <- appo.mets.11
appo.mets.15 <- appo.mets.11
appo.mets.16 <- appo.mets.11

for (i in 1:length(appo.up)) {
  riv.seg <- appo.up[i]
  dates <- as.Date(c(as.Date('1991-01-01'):as.Date('2000-12-31')))
  
  data.namer <- paste0("runit_", riv.seg)
  all.data <- get(data.namer)
  
  data.11 <- data.frame(dates, all.data$lri.dat11.flow.unit)
  colnames(data.11) <- c('date', 'flow')
  data.14 <- data.frame(dates, all.data$lri.dat14.flow.unit)
  colnames(data.14) <- c('date', 'flow')
  data.15 <- data.frame(dates, all.data$lri.dat15.flow.unit)
  colnames(data.15) <- c('date', 'flow')
  data.16 <- data.frame(dates, all.data$lri.dat16.flow.unit)
  colnames(data.16) <- c('date', 'flow')
  
  appo.mets.11$`River Segment`[i] <- riv.seg
  appo.mets.11$`Q5 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.05)
  appo.mets.11$`Q10 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.1)
  appo.mets.11$`Q25 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.25)
  appo.mets.11$`Q50 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.50)
  appo.mets.11$`Q75 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.75)
  appo.mets.11$`Q90 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.90)
  appo.mets.11$`Q95 (cfs/sq mi)`[i] <- quantile(data.11$flow, 0.95)
  
  appo.mets.14$`River Segment`[i] <- riv.seg
  appo.mets.14$`Q5 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.05)
  appo.mets.14$`Q10 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.1)
  appo.mets.14$`Q25 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.25)
  appo.mets.14$`Q50 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.50)
  appo.mets.14$`Q75 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.75)
  appo.mets.14$`Q90 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.90)
  appo.mets.14$`Q95 (cfs/sq mi)`[i] <- quantile(data.14$flow, 0.95)
  
  appo.mets.15$`River Segment`[i] <- riv.seg
  appo.mets.15$`Q5 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.05)
  appo.mets.15$`Q10 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.1)
  appo.mets.15$`Q25 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.25)
  appo.mets.15$`Q50 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.50)
  appo.mets.15$`Q75 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.75)
  appo.mets.15$`Q90 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.90)
  appo.mets.15$`Q95 (cfs/sq mi)`[i] <- quantile(data.15$flow, 0.95)
  
  appo.mets.16$`River Segment`[i] <- riv.seg
  appo.mets.16$`Q5 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.05)
  appo.mets.16$`Q10 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.1)
  appo.mets.16$`Q25 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.25)
  appo.mets.16$`Q50 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.50)
  appo.mets.16$`Q75 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.75)
  appo.mets.16$`Q90 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.90)
  appo.mets.16$`Q95 (cfs/sq mi)`[i] <- quantile(data.16$flow, 0.95)
}

appo.mets.11.out <- appo.mets.11
appo.mets.11.out[,2:8] <- round(appo.mets.11.out[,2:8], 2)
appo.mets.14.out <- appo.mets.14
appo.mets.14.out[,2:8] <- round(appo.mets.14.out[,2:8], 2)
appo.mets.15.out <- appo.mets.15
appo.mets.15.out[,2:8] <- round(appo.mets.15.out[,2:8], 2)
appo.mets.16.out <- appo.mets.16
appo.mets.16.out[,2:8] <- round(appo.mets.16.out[,2:8], 2)


kable(appo.mets.11.out,  booktabs = T,
      caption = "Runoff Quantiles in Appomattox River Segments (Base Scenario)",
      label = "runit.appoqoutbase",
      col.names = colnames(appo.mets.11)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.appo.mets.11",file_ext,sep=""))

kable(appo.mets.14.out,  booktabs = T,
      caption = "Runoff Quantiles in Appomattox River Segments (ccP50T50 Scenario)",
      label = "runit.appoqout50",
      col.names = colnames(appo.mets.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.appo.mets.14",file_ext,sep=""))

kable(appo.mets.15.out,  booktabs = T,
      caption = "Runoff Quantiles in Appomattox River Segments (ccP10T10 Scenario)",
      label = "runit.appoqout10",
      col.names = colnames(appo.mets.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.appo.mets.15",file_ext,sep=""))

kable(appo.mets.16.out,  booktabs = T,
      caption = "Runoff Quantiles in Appomattox River Segments (ccP90T90 Scenario)",
      label = "runit.appoqout90",
      col.names = colnames(appo.mets.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.appo.mets.16",file_ext,sep=""))

shen.diff.14 <- shen.mets.14
colnames(shen.diff.14) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
shen.diff.14[,2:8] <- round((shen.mets.14[,2:8]-shen.mets.11[,2:8])/shen.mets.11[,2:8]*100, 2)

matt.diff.14 <- matt.mets.14
colnames(matt.diff.14) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
matt.diff.14[,2:8] <- round((matt.mets.14[,2:8]-matt.mets.11[,2:8])/matt.mets.11[,2:8]*100, 2)

pamu.diff.14 <- pamu.mets.14
colnames(pamu.diff.14) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
pamu.diff.14[,2:8] <- round((pamu.mets.14[,2:8]-pamu.mets.11[,2:8])/pamu.mets.11[,2:8]*100, 2)

rapp.diff.14 <- rapp.mets.14
colnames(rapp.diff.14) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
rapp.diff.14[,2:8] <- round((rapp.mets.14[,2:8]-rapp.mets.11[,2:8])/rapp.mets.11[,2:8]*100, 2)

jaup.diff.14 <- jaup.mets.14
colnames(jaup.diff.14) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
jaup.diff.14[,2:8] <- round((jaup.mets.14[,2:8]-jaup.mets.11[,2:8])/jaup.mets.11[,2:8]*100, 2)

jami.diff.14 <- jami.mets.14
colnames(jami.diff.14) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
jami.diff.14[,2:8] <- round((jami.mets.14[,2:8]-jami.mets.11[,2:8])/jami.mets.11[,2:8]*100, 2)

appo.diff.14 <- appo.mets.14
colnames(appo.diff.14) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
appo.diff.14[,2:8] <- round((appo.mets.14[,2:8]-appo.mets.11[,2:8])/appo.mets.11[,2:8]*100, 2)

kable(shen.diff.14,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Shenandoah River Segments (ccP50T50 Scenario)",
      label = "runit.pctshenqout50",
      col.names = colnames(shen.diff.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.shen.diff.50",file_ext,sep=""))

kable(matt.diff.14,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Mattaponi River Segments (ccP50T50 Scenario)",
      label = "runit.pctmattqout50",
      col.names = colnames(matt.diff.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.matt.diff.50",file_ext,sep=""))

kable(pamu.diff.14,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Pamunkey River Segments (ccP50T50 Scenario)",
      label = "runit.pctpamuqout50",
      col.names = colnames(pamu.diff.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.pamu.diff.50",file_ext,sep=""))

kable(rapp.diff.14,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Rappahannock River Segments (ccP50T50 Scenario)",
      label = "runit.pctrappqout50",
      col.names = colnames(rapp.diff.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.rapp.diff.50",file_ext,sep=""))

kable(jaup.diff.14,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Upper James River Segments (ccP50T50 Scenario)",
      label = "runit.pctjaupqout50",
      col.names = colnames(jaup.diff.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.jaup.diff.50",file_ext,sep=""))

kable(jami.diff.14,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Middle James River Segments (ccP50T50 Scenario)",
      label = "runit.pctjamiqout50",
      col.names = colnames(jami.diff.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.jami.diff.50",file_ext,sep=""))

kable(appo.diff.14,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Appomattox River Segments (ccP50T50 Scenario)",
      label = "runit.pctappoqout50",
      col.names = colnames(appo.diff.14)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.appo.diff.50",file_ext,sep=""))

shen.diff.15 <- shen.mets.15
colnames(shen.diff.15) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
shen.diff.15[,2:8] <- round((shen.mets.15[,2:8]-shen.mets.11[,2:8])/shen.mets.11[,2:8]*100, 2)

matt.diff.15 <- matt.mets.15
colnames(matt.diff.15) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
matt.diff.15[,2:8] <- round((matt.mets.15[,2:8]-matt.mets.11[,2:8])/matt.mets.11[,2:8]*100, 2)

pamu.diff.15 <- pamu.mets.15
colnames(pamu.diff.15) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
pamu.diff.15[,2:8] <- round((pamu.mets.15[,2:8]-pamu.mets.11[,2:8])/pamu.mets.11[,2:8]*100, 2)

rapp.diff.15 <- rapp.mets.15
colnames(rapp.diff.15) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
rapp.diff.15[,2:8] <- round((rapp.mets.15[,2:8]-rapp.mets.11[,2:8])/rapp.mets.11[,2:8]*100, 2)

jaup.diff.15 <- jaup.mets.15
colnames(jaup.diff.15) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
jaup.diff.15[,2:8] <- round((jaup.mets.15[,2:8]-jaup.mets.11[,2:8])/jaup.mets.11[,2:8]*100, 2)

jami.diff.15 <- jami.mets.15
colnames(jami.diff.15) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
jami.diff.15[,2:8] <- round((jami.mets.15[,2:8]-jami.mets.11[,2:8])/jami.mets.11[,2:8]*100, 2)

appo.diff.15 <- appo.mets.15
colnames(appo.diff.15) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
appo.diff.15[,2:8] <- round((appo.mets.15[,2:8]-appo.mets.11[,2:8])/appo.mets.11[,2:8]*100, 2)


kable(shen.diff.15,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Shenandoah River Segments (ccP10T10 Scenario)",
      label = "runit.pctshenqout10",
      col.names = colnames(shen.diff.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.shen.diff.10",file_ext,sep=""))

kable(matt.diff.15,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Mattaponi River Segments (ccP10T10 Scenario)",
      label = "runit.pctmattqout10",
      col.names = colnames(matt.diff.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.matt.diff.10",file_ext,sep=""))

kable(pamu.diff.15,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Pamunkey River Segments (ccP10T10 Scenario)",
      label = "runit.pctpamuqout10",
      col.names = colnames(pamu.diff.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.pamu.diff.10",file_ext,sep=""))

kable(rapp.diff.15,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Rappahannock River Segments (ccP10T10 Scenario)",
      label = "runit.pctrappqout10",
      col.names = colnames(rapp.diff.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.rapp.diff.10",file_ext,sep=""))

kable(jaup.diff.15,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Upper James River Segments (ccP10T10 Scenario)",
      label = "runit.pctjaupqout10",
      col.names = colnames(jaup.diff.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.jaup.diff.10",file_ext,sep=""))

kable(jami.diff.15,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Middle James River Segments (ccP10T10 Scenario)",
      label = "runit.pctjamiqout10",
      col.names = colnames(jami.diff.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.jami.diff.10",file_ext,sep=""))

kable(appo.diff.15,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Appomattox River Segments (ccP10T10 Scenario)",
      label = "runit.pctappoqout10",
      col.names = colnames(appo.diff.15)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.appo.diff.10",file_ext,sep=""))

shen.diff.16 <- shen.mets.16
colnames(shen.diff.16) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
shen.diff.16[,2:8] <- round((shen.mets.16[,2:8]-shen.mets.11[,2:8])/shen.mets.11[,2:8]*100, 2)

matt.diff.16 <- matt.mets.16
colnames(matt.diff.16) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
matt.diff.16[,2:8] <- round((matt.mets.16[,2:8]-matt.mets.11[,2:8])/matt.mets.11[,2:8]*100, 2)

pamu.diff.16 <- pamu.mets.16
colnames(pamu.diff.16) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
pamu.diff.16[,2:8] <- round((pamu.mets.16[,2:8]-pamu.mets.11[,2:8])/pamu.mets.11[,2:8]*100, 2)

rapp.diff.16 <- rapp.mets.16
colnames(rapp.diff.16) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
rapp.diff.16[,2:8] <- round((rapp.mets.16[,2:8]-rapp.mets.11[,2:8])/rapp.mets.11[,2:8]*100, 2)

jaup.diff.16 <- jaup.mets.16
colnames(jaup.diff.16) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
jaup.diff.16[,2:8] <- round((jaup.mets.16[,2:8]-jaup.mets.11[,2:8])/jaup.mets.11[,2:8]*100, 2)

jami.diff.16 <- jami.mets.16
colnames(jami.diff.16) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
jami.diff.16[,2:8] <- round((jami.mets.16[,2:8]-jami.mets.11[,2:8])/jami.mets.11[,2:8]*100, 2)

appo.diff.16 <- appo.mets.16
colnames(appo.diff.16) <- c('River Segment', 'Q5 (%)', 'Q10 (%)', 
                            'Q25 (%)', 'Q50 (%)', 'Q75 (%)',
                            'Q90 (%)', 'Q95 (%)')
appo.diff.16[,2:8] <- round((appo.mets.16[,2:8]-appo.mets.11[,2:8])/appo.mets.11[,2:8]*100, 2)


kable(shen.diff.16,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Shenandoah River Segments (ccP90T90 Scenario)",
      label = "runit.pctshenqout90",
      col.names = colnames(shen.diff.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.shen.diff.90",file_ext,sep=""))

kable(matt.diff.16,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Mattaponi River Segments (ccP90T90 Scenario)",
      label = "runit.pctmattqout90",
      col.names = colnames(matt.diff.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.matt.diff.90",file_ext,sep=""))

kable(pamu.diff.16,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Pamunkey River Segments (ccP90T90 Scenario)",
      label = "runit.pctpamuqout90",
      col.names = colnames(pamu.diff.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.pamu.diff.90",file_ext,sep=""))

kable(rapp.diff.16,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Rappahannock River Segments (ccP90T90 Scenario)",
      label = "runit.pctrappqout90",
      col.names = colnames(rapp.diff.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.rapp.diff.90",file_ext,sep=""))

kable(jaup.diff.16,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Upper James River Segments (ccP90T90 Scenario)",
      label = "runit.pctjaupqout90",
      col.names = colnames(jaup.diff.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.jaup.diff.90",file_ext,sep=""))

kable(jami.diff.16,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Middle James River Segments (ccP90T90 Scenario)",
      label = "runit.pctjamiqout90",
      col.names = colnames(jami.diff.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.jami.diff.90",file_ext,sep=""))

kable(appo.diff.16,  booktabs = T,
      caption = "Percent Changes in Runoff Quantiles in Appomattox River Segments (ccP90T90 Scenario)",
      label = "runit.pctappoqout90",
      col.names = colnames(appo.diff.16)) %>%
  kable_styling(latex_options = latexoptions) %>%
  #column_spec(1, width = "6em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("runit.appo.diff.90",file_ext,sep=""))

median(shen.diff.15$`Q5 (%)`)
median(shen.diff.15$`Q10 (%)`)
median(shen.diff.15$`Q25 (%)`)
median(shen.diff.15$`Q50 (%)`)
median(shen.diff.15$`Q75 (%)`)
median(shen.diff.15$`Q90 (%)`)
median(shen.diff.15$`Q95 (%)`)

median(shen.diff.14$`Q5 (%)`)
median(shen.diff.14$`Q10 (%)`)
median(shen.diff.14$`Q25 (%)`)
median(shen.diff.14$`Q50 (%)`)
median(shen.diff.14$`Q75 (%)`)
median(shen.diff.14$`Q90 (%)`)
median(shen.diff.14$`Q95 (%)`)

median(shen.diff.16$`Q5 (%)`)
median(shen.diff.16$`Q10 (%)`)
median(shen.diff.16$`Q25 (%)`)
median(shen.diff.16$`Q50 (%)`)
median(shen.diff.16$`Q75 (%)`)
median(shen.diff.16$`Q90 (%)`)
median(shen.diff.16$`Q95 (%)`)

median(matt.diff.15$`Q5 (%)`)
median(matt.diff.15$`Q10 (%)`)
median(matt.diff.15$`Q25 (%)`)
median(matt.diff.15$`Q50 (%)`)
median(matt.diff.15$`Q75 (%)`)
median(matt.diff.15$`Q90 (%)`)
median(matt.diff.15$`Q95 (%)`)

median(matt.diff.14$`Q5 (%)`)
median(matt.diff.14$`Q10 (%)`)
median(matt.diff.14$`Q25 (%)`)
median(matt.diff.14$`Q50 (%)`)
median(matt.diff.14$`Q75 (%)`)
median(matt.diff.14$`Q90 (%)`)
median(matt.diff.14$`Q95 (%)`)

median(matt.diff.16$`Q5 (%)`)
median(matt.diff.16$`Q10 (%)`)
median(matt.diff.16$`Q25 (%)`)
median(matt.diff.16$`Q50 (%)`)
median(matt.diff.16$`Q75 (%)`)
median(matt.diff.16$`Q90 (%)`)
median(matt.diff.16$`Q95 (%)`)

median(pamu.diff.15$`Q5 (%)`)
median(pamu.diff.15$`Q10 (%)`)
median(pamu.diff.15$`Q25 (%)`)
median(pamu.diff.15$`Q50 (%)`)
median(pamu.diff.15$`Q75 (%)`)
median(pamu.diff.15$`Q90 (%)`)
median(pamu.diff.15$`Q95 (%)`)

median(pamu.diff.14$`Q5 (%)`)
median(pamu.diff.14$`Q10 (%)`)
median(pamu.diff.14$`Q25 (%)`)
median(pamu.diff.14$`Q50 (%)`)
median(pamu.diff.14$`Q75 (%)`)
median(pamu.diff.14$`Q90 (%)`)
median(pamu.diff.14$`Q95 (%)`)

median(pamu.diff.16$`Q5 (%)`)
median(pamu.diff.16$`Q10 (%)`)
median(pamu.diff.16$`Q25 (%)`)
median(pamu.diff.16$`Q50 (%)`)
median(pamu.diff.16$`Q75 (%)`)
median(pamu.diff.16$`Q90 (%)`)
median(pamu.diff.16$`Q95 (%)`)

median(rapp.diff.15$`Q5 (%)`)
median(rapp.diff.15$`Q10 (%)`)
median(rapp.diff.15$`Q25 (%)`)
median(rapp.diff.15$`Q50 (%)`)
median(rapp.diff.15$`Q75 (%)`)
median(rapp.diff.15$`Q90 (%)`)
median(rapp.diff.15$`Q95 (%)`)

median(rapp.diff.14$`Q5 (%)`)
median(rapp.diff.14$`Q10 (%)`)
median(rapp.diff.14$`Q25 (%)`)
median(rapp.diff.14$`Q50 (%)`)
median(rapp.diff.14$`Q75 (%)`)
median(rapp.diff.14$`Q90 (%)`)
median(rapp.diff.14$`Q95 (%)`)

median(rapp.diff.16$`Q5 (%)`)
median(rapp.diff.16$`Q10 (%)`)
median(rapp.diff.16$`Q25 (%)`)
median(rapp.diff.16$`Q50 (%)`)
median(rapp.diff.16$`Q75 (%)`)
median(rapp.diff.16$`Q90 (%)`)
median(rapp.diff.16$`Q95 (%)`)

median(jaup.diff.15$`Q5 (%)`)
median(jaup.diff.15$`Q10 (%)`)
median(jaup.diff.15$`Q25 (%)`)
median(jaup.diff.15$`Q50 (%)`)
median(jaup.diff.15$`Q75 (%)`)
median(jaup.diff.15$`Q90 (%)`)
median(jaup.diff.15$`Q95 (%)`)

median(jaup.diff.14$`Q5 (%)`)
median(jaup.diff.14$`Q10 (%)`)
median(jaup.diff.14$`Q25 (%)`)
median(jaup.diff.14$`Q50 (%)`)
median(jaup.diff.14$`Q75 (%)`)
median(jaup.diff.14$`Q90 (%)`)
median(jaup.diff.14$`Q95 (%)`)

median(jaup.diff.16$`Q5 (%)`)
median(jaup.diff.16$`Q10 (%)`)
median(jaup.diff.16$`Q25 (%)`)
median(jaup.diff.16$`Q50 (%)`)
median(jaup.diff.16$`Q75 (%)`)
median(jaup.diff.16$`Q90 (%)`)
median(jaup.diff.16$`Q95 (%)`)

median(jami.diff.15$`Q5 (%)`)
median(jami.diff.15$`Q10 (%)`)
median(jami.diff.15$`Q25 (%)`)
median(jami.diff.15$`Q50 (%)`)
median(jami.diff.15$`Q75 (%)`)
median(jami.diff.15$`Q90 (%)`)
median(jami.diff.15$`Q95 (%)`)

median(jami.diff.14$`Q5 (%)`)
median(jami.diff.14$`Q10 (%)`)
median(jami.diff.14$`Q25 (%)`)
median(jami.diff.14$`Q50 (%)`)
median(jami.diff.14$`Q75 (%)`)
median(jami.diff.14$`Q90 (%)`)
median(jami.diff.14$`Q95 (%)`)

median(jami.diff.16$`Q5 (%)`)
median(jami.diff.16$`Q10 (%)`)
median(jami.diff.16$`Q25 (%)`)
median(jami.diff.16$`Q50 (%)`)
median(jami.diff.16$`Q75 (%)`)
median(jami.diff.16$`Q90 (%)`)
median(jami.diff.16$`Q95 (%)`)

median(appo.diff.15$`Q5 (%)`)
median(appo.diff.15$`Q10 (%)`)
median(appo.diff.15$`Q25 (%)`)
median(appo.diff.15$`Q50 (%)`)
median(appo.diff.15$`Q75 (%)`)
median(appo.diff.15$`Q90 (%)`)
median(appo.diff.15$`Q95 (%)`)

median(appo.diff.14$`Q5 (%)`)
median(appo.diff.14$`Q10 (%)`)
median(appo.diff.14$`Q25 (%)`)
median(appo.diff.14$`Q50 (%)`)
median(appo.diff.14$`Q75 (%)`)
median(appo.diff.14$`Q90 (%)`)
median(appo.diff.14$`Q95 (%)`)

median(appo.diff.16$`Q5 (%)`)
median(appo.diff.16$`Q10 (%)`)
median(appo.diff.16$`Q25 (%)`)
median(appo.diff.16$`Q50 (%)`)
median(appo.diff.16$`Q75 (%)`)
median(appo.diff.16$`Q90 (%)`)
median(appo.diff.16$`Q95 (%)`)

