# Downloads land use data from the deq2 server. Creates percent exceedance plots for some select
# land use runoff timeseries.

lu_harr_base <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CFBASE30Y20180615/eos/land.use.timeseries_N51660.csv')
lu_harr_cc10 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CBASE1808L55CY55R45P10R45P10Y/eos/land.use.timeseries_N51660.csv')

lu_amhe_base <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CFBASE30Y20180615/eos/land.use.timeseries_H51009.csv')
lu_amhe_cc10 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CBASE1808L55CY55R45P10R45P10Y/eos/land.use.timeseries_H51009.csv')

lu_gile_base <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CFBASE30Y20180615/eos/land.use.timeseries_N51071.csv')
lu_gile_cc50 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CBASE1808L55CY55R45P50R45P50Y/eos/land.use.timeseries_N51071.csv')

lu_culp_base <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CFBASE30Y20180615/eos/land.use.timeseries_N51047.csv')
lu_culp_cc50 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CBASE1808L55CY55R45P50R45P50Y/eos/land.use.timeseries_N51047.csv')

lu_high_base <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CFBASE30Y20180615/eos/land.use.timeseries_L51091.csv')
lu_high_cc90 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CBASE1808L55CY55R45P90R45P90Y/eos/land.use.timeseries_L51091.csv')

lu_nott_base <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CFBASE30Y20180615/eos/land.use.timeseries_N51135.csv')
lu_nott_cc90 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CBASE1808L55CY55R45P90R45P90Y/eos/land.use.timeseries_N51135.csv')

lu_harr_base_cch <- lu_harr_base$cch[order(lu_harr_base$cch, decreasing = TRUE)]
lu_harr_base_cci <- lu_harr_base$cci[order(lu_harr_base$cci, decreasing = TRUE)]
lu_harr_base_for <- lu_harr_base$`for`[order(lu_harr_base$`for`, decreasing = TRUE)]
lu_harr_base_pas <- lu_harr_base$pas[order(lu_harr_base$pas, decreasing = TRUE)]
lu_harr_base_soy <- lu_harr_base$soy[order(lu_harr_base$soy, decreasing = TRUE)]

lu_harr_cc10_cch <- lu_harr_cc10$cch[order(lu_harr_cc10$cch, decreasing = TRUE)]
lu_harr_cc10_cci <- lu_harr_cc10$cci[order(lu_harr_cc10$cci, decreasing = TRUE)]
lu_harr_cc10_for <- lu_harr_cc10$`for`[order(lu_harr_cc10$`for`, decreasing = TRUE)]
lu_harr_cc10_pas <- lu_harr_cc10$pas[order(lu_harr_cc10$pas, decreasing = TRUE)]
lu_harr_cc10_soy <- lu_harr_cc10$soy[order(lu_harr_cc10$soy, decreasing = TRUE)]

lu_amhe_base_cch <- lu_amhe_base$cch[order(lu_amhe_base$cch, decreasing = TRUE)]
lu_amhe_base_cci <- lu_amhe_base$cci[order(lu_amhe_base$cci, decreasing = TRUE)]
lu_amhe_base_for <- lu_amhe_base$`for`[order(lu_amhe_base$`for`, decreasing = TRUE)]
lu_amhe_base_pas <- lu_amhe_base$pas[order(lu_amhe_base$pas, decreasing = TRUE)]
lu_amhe_base_soy <- lu_amhe_base$soy[order(lu_amhe_base$soy, decreasing = TRUE)]

lu_amhe_cc10_cch <- lu_amhe_cc10$cch[order(lu_amhe_cc10$cch, decreasing = TRUE)]
lu_amhe_cc10_cci <- lu_amhe_cc10$cci[order(lu_amhe_cc10$cci, decreasing = TRUE)]
lu_amhe_cc10_for <- lu_amhe_cc10$`for`[order(lu_amhe_cc10$`for`, decreasing = TRUE)]
lu_amhe_cc10_pas <- lu_amhe_cc10$pas[order(lu_amhe_cc10$pas, decreasing = TRUE)]
lu_amhe_cc10_soy <- lu_amhe_cc10$soy[order(lu_amhe_cc10$soy, decreasing = TRUE)]

lu_gile_base_cch <- lu_gile_base$cch[order(lu_gile_base$cch, decreasing = TRUE)]
lu_gile_base_cci <- lu_gile_base$cci[order(lu_gile_base$cci, decreasing = TRUE)]
lu_gile_base_for <- lu_gile_base$`for`[order(lu_gile_base$`for`, decreasing = TRUE)]
lu_gile_base_pas <- lu_gile_base$pas[order(lu_gile_base$pas, decreasing = TRUE)]
lu_gile_base_soy <- lu_gile_base$soy[order(lu_gile_base$soy, decreasing = TRUE)]

lu_gile_cc50_cch <- lu_gile_cc50$cch[order(lu_gile_cc50$cch, decreasing = TRUE)]
lu_gile_cc50_cci <- lu_gile_cc50$cci[order(lu_gile_cc50$cci, decreasing = TRUE)]
lu_gile_cc50_for <- lu_gile_cc50$`for`[order(lu_gile_cc50$`for`, decreasing = TRUE)]
lu_gile_cc50_pas <- lu_gile_cc50$pas[order(lu_gile_cc50$pas, decreasing = TRUE)]
lu_gile_cc50_soy <- lu_gile_cc50$soy[order(lu_gile_cc50$soy, decreasing = TRUE)]

lu_culp_base_cch <- lu_culp_base$cch[order(lu_culp_base$cch, decreasing = TRUE)]
lu_culp_base_cci <- lu_culp_base$cci[order(lu_culp_base$cci, decreasing = TRUE)]
lu_culp_base_for <- lu_culp_base$`for`[order(lu_culp_base$`for`, decreasing = TRUE)]
lu_culp_base_pas <- lu_culp_base$pas[order(lu_culp_base$pas, decreasing = TRUE)]
lu_culp_base_soy <- lu_culp_base$soy[order(lu_culp_base$soy, decreasing = TRUE)]

lu_culp_cc50_cch <- lu_culp_cc50$cch[order(lu_culp_cc50$cch, decreasing = TRUE)]
lu_culp_cc50_cci <- lu_culp_cc50$cci[order(lu_culp_cc50$cci, decreasing = TRUE)]
lu_culp_cc50_for <- lu_culp_cc50$`for`[order(lu_culp_cc50$`for`, decreasing = TRUE)]
lu_culp_cc50_pas <- lu_culp_cc50$pas[order(lu_culp_cc50$pas, decreasing = TRUE)]
lu_culp_cc50_soy <- lu_culp_cc50$soy[order(lu_culp_cc50$soy, decreasing = TRUE)]

lu_high_base_cch <- lu_high_base$cch[order(lu_high_base$cch, decreasing = TRUE)]
lu_high_base_cci <- lu_high_base$cci[order(lu_high_base$cci, decreasing = TRUE)]
lu_high_base_for <- lu_high_base$`for`[order(lu_high_base$`for`, decreasing = TRUE)]
lu_high_base_pas <- lu_high_base$pas[order(lu_high_base$pas, decreasing = TRUE)]
lu_high_base_soy <- lu_high_base$soy[order(lu_high_base$soy, decreasing = TRUE)]

lu_high_cc90_cch <- lu_high_cc90$cch[order(lu_high_cc90$cch, decreasing = TRUE)]
lu_high_cc90_cci <- lu_high_cc90$cci[order(lu_high_cc90$cci, decreasing = TRUE)]
lu_high_cc90_for <- lu_high_cc90$`for`[order(lu_high_cc90$`for`, decreasing = TRUE)]
lu_high_cc90_pas <- lu_high_cc90$pas[order(lu_high_cc90$pas, decreasing = TRUE)]
lu_high_cc90_soy <- lu_high_cc90$soy[order(lu_high_cc90$soy, decreasing = TRUE)]

lu_nott_base_cch <- lu_nott_base$cch[order(lu_nott_base$cch, decreasing = TRUE)]
lu_nott_base_cci <- lu_nott_base$cci[order(lu_nott_base$cci, decreasing = TRUE)]
lu_nott_base_for <- lu_nott_base$`for`[order(lu_nott_base$`for`, decreasing = TRUE)]
lu_nott_base_pas <- lu_nott_base$pas[order(lu_nott_base$pas, decreasing = TRUE)]
lu_nott_base_soy <- lu_nott_base$soy[order(lu_nott_base$soy, decreasing = TRUE)]

lu_nott_cc90_cch <- lu_nott_cc90$cch[order(lu_nott_cc90$cch, decreasing = TRUE)]
lu_nott_cc90_cci <- lu_nott_cc90$cci[order(lu_nott_cc90$cci, decreasing = TRUE)]
lu_nott_cc90_for <- lu_nott_cc90$`for`[order(lu_nott_cc90$`for`, decreasing = TRUE)]
lu_nott_cc90_pas <- lu_nott_cc90$pas[order(lu_nott_cc90$pas, decreasing = TRUE)]
lu_nott_cc90_soy <- lu_nott_cc90$soy[order(lu_nott_cc90$soy, decreasing = TRUE)]

png(filename = 'cci.png', width = 1400, height = 700)
par(mfrow=c(2,3))
par(mar = c(5.1, 5.4, 4.1, 2.1))
plot(as.numeric(1:length(lu_amhe_base_cci[1:1000])*100/length(lu_amhe_base_cci)), lu_amhe_base_cci[1:1000], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Amherst', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_amhe_cc10_cci[1:1000])*100/length(lu_amhe_base_cci)), lu_amhe_cc10_cci[1:1000], type = 'l', col = 'chocolate2', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP10T10 Scenario'), col = c('black', 'chocolate2'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_gile_base_cci[1:1000])*100/length(lu_gile_base_cci)), lu_gile_base_cci[1:1000], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Giles', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_gile_cc50_cci[1:1000])*100/length(lu_gile_base_cci)), lu_gile_cc50_cci[1:1000], type = 'l', col = 'green3', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP50T50 Scenario'), col = c('black', 'green3'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_high_base_cci[1:1000])*100/length(lu_high_base_cci)), lu_high_base_cci[1:1000], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Highland', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_high_cc90_cci[1:1000])*100/length(lu_high_base_cci)), lu_high_cc90_cci[1:1000], type = 'l', col = 'blueviolet', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP90T90 Scenario'), col = c('black', 'blueviolet'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_harr_base_cci[1:1000])*100/length(lu_harr_base_cci)), lu_harr_base_cci[1:1000], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Harrisonburg', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_harr_cc10_cci[1:1000])*100/length(lu_harr_base_cci)), lu_harr_cc10_cci[1:1000], type = 'l', col = 'chocolate2', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP10T10 Scenario'), col = c('black', 'chocolate2'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_culp_base_cci[1:1000])*100/length(lu_culp_base_cci)), lu_culp_base_cci[1:1000], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Culpeper', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_culp_cc50_cci[1:1000])*100/length(lu_culp_base_cci)), lu_culp_cc50_cci[1:1000], type = 'l', col = 'green3', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP50T50 Scenario'), col = c('black', 'green3'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_nott_base_cci[1:1000])*100/length(lu_nott_base_cci)), lu_nott_base_cci[1:1000], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Nottoway', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_nott_cc90_cci[1:1000])*100/length(lu_nott_base_cci)), lu_nott_cc90_cci[1:1000], type = 'l', col = 'blueviolet', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP90T90 Scenario'), col = c('black', 'blueviolet'), lwd = 2, lty = 1, cex = 2)
dev.off()

png(filename = 'cch.png', width = 1400, height = 700)
par(mfrow=c(2,3))
par(mar = c(5.1, 5.4, 4.1, 2.1))
plot(as.numeric(1:length(lu_amhe_base_cch[1:1200])*100/length(lu_amhe_base_cch)), lu_amhe_base_cch[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Amherst', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_amhe_cc10_cch[1:1200])*100/length(lu_amhe_base_cch)), lu_amhe_cc10_cch[1:1200], type = 'l', col = 'chocolate2', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP10T10 Scenario'), col = c('black', 'chocolate2'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_gile_base_cch[1:1200])*100/length(lu_gile_base_cch)), lu_gile_base_cch[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Giles', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_gile_cc50_cch[1:1200])*100/length(lu_gile_base_cch)), lu_gile_cc50_cch[1:1200], type = 'l', col = 'green3', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP50T50 Scenario'), col = c('black', 'green3'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_high_base_cch[1:1200])*100/length(lu_high_base_cch)), lu_high_base_cch[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Highland', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_high_cc90_cch[1:1200])*100/length(lu_high_base_cch)), lu_high_cc90_cch[1:1200], type = 'l', col = 'blueviolet', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP90T90 Scenario'), col = c('black', 'blueviolet'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_harr_base_cch[1:1200])*100/length(lu_harr_base_cch)), lu_harr_base_cch[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Harrisonburg', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_harr_cc10_cch[1:1200])*100/length(lu_harr_base_cch)), lu_harr_cc10_cch[1:1200], type = 'l', col = 'chocolate2', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP10T10 Scenario'), col = c('black', 'chocolate2'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_culp_base_cch[1:1200])*100/length(lu_culp_base_cch)), lu_culp_base_cch[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Culpeper', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_culp_cc50_cch[1:1200])*100/length(lu_culp_base_cch)), lu_culp_cc50_cch[1:1200], type = 'l', col = 'green3', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP50T50 Scenario'), col = c('black', 'green3'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_nott_base_cch[1:1200])*100/length(lu_nott_base_cch)), lu_nott_base_cch[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Nottoway', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_nott_cc90_cch[1:1200])*100/length(lu_nott_base_cch)), lu_nott_cc90_cch[1:1200], type = 'l', col = 'blueviolet', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP90T90 Scenario'), col = c('black', 'blueviolet'), lwd = 2, lty = 1, cex = 2)
dev.off()

png(filename = 'for.png', width = 1400, height = 700)
par(mfrow=c(2,3))
par(mar = c(5.1, 5.4, 4.1, 2.1))
plot(as.numeric(1:length(lu_amhe_base_for[1:1200])*100/length(lu_amhe_base_for)), lu_amhe_base_for[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Amherst', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_amhe_cc10_for[1:1200])*100/length(lu_amhe_base_for)), lu_amhe_cc10_for[1:1200], type = 'l', col = 'chocolate2', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP10T10 Scenario'), col = c('black', 'chocolate2'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_gile_base_for[1:1200])*100/length(lu_gile_base_for)), lu_gile_base_for[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Giles', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_gile_cc50_for[1:1200])*100/length(lu_gile_base_for)), lu_gile_cc50_for[1:1200], type = 'l', col = 'green3', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP50T50 Scenario'), col = c('black', 'green3'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_high_base_for[1:1200])*100/length(lu_high_base_for)), lu_high_base_for[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Highland', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_high_cc90_for[1:1200])*100/length(lu_high_base_for)), lu_high_cc90_for[1:1200], type = 'l', col = 'blueviolet', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP90T90 Scenario'), col = c('black', 'blueviolet'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_harr_base_for[1:1200])*100/length(lu_harr_base_for)), lu_harr_base_for[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Harrisonburg', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_harr_cc10_for[1:1200])*100/length(lu_harr_base_for)), lu_harr_cc10_for[1:1200], type = 'l', col = 'chocolate2', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP10T10 Scenario'), col = c('black', 'chocolate2'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_culp_base_for[1:1200])*100/length(lu_culp_base_for)), lu_culp_base_for[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Culpeper', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_culp_cc50_for[1:1200])*100/length(lu_culp_base_for)), lu_culp_cc50_for[1:1200], type = 'l', col = 'green3', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP50T50 Scenario'), col = c('black', 'green3'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_nott_base_for[1:1200])*100/length(lu_nott_base_for)), lu_nott_base_for[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Nottoway', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_nott_cc90_for[1:1200])*100/length(lu_nott_base_for)), lu_nott_cc90_for[1:1200], type = 'l', col = 'blueviolet', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP90T90 Scenario'), col = c('black', 'blueviolet'), lwd = 2, lty = 1, cex = 2)
dev.off()

png(filename = 'pas.png', width = 1400, height = 700)
par(mfrow=c(2,3))
par(mar = c(5.1, 5.4, 4.1, 2.1))
plot(as.numeric(1:length(lu_amhe_base_pas[1:1200])*100/length(lu_amhe_base_pas)), lu_amhe_base_pas[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Amherst', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_amhe_cc10_pas[1:1200])*100/length(lu_amhe_base_pas)), lu_amhe_cc10_pas[1:1200], type = 'l', col = 'chocolate2', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP10T10 Scenario'), col = c('black', 'chocolate2'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_gile_base_pas[1:1200])*100/length(lu_gile_base_pas)), lu_gile_base_pas[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Giles', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_gile_cc50_pas[1:1200])*100/length(lu_gile_base_pas)), lu_gile_cc50_pas[1:1200], type = 'l', col = 'green3', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP50T50 Scenario'), col = c('black', 'green3'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_high_base_pas[1:1200])*100/length(lu_high_base_pas)), lu_high_base_pas[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Highland', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_high_cc90_pas[1:1200])*100/length(lu_high_base_pas)), lu_high_cc90_pas[1:1200], type = 'l', col = 'blueviolet', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP90T90 Scenario'), col = c('black', 'blueviolet'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_harr_base_pas[1:1200])*100/length(lu_harr_base_pas)), lu_harr_base_pas[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Harrisonburg', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_harr_cc10_pas[1:1200])*100/length(lu_harr_base_pas)), lu_harr_cc10_pas[1:1200], type = 'l', col = 'chocolate2', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP10T10 Scenario'), col = c('black', 'chocolate2'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_culp_base_pas[1:1200])*100/length(lu_culp_base_pas)), lu_culp_base_pas[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Culpeper', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_culp_cc50_pas[1:1200])*100/length(lu_culp_base_pas)), lu_culp_cc50_pas[1:1200], type = 'l', col = 'green3', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP50T50 Scenario'), col = c('black', 'green3'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_nott_base_pas[1:1200])*100/length(lu_nott_base_pas)), lu_nott_base_pas[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Nottoway', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_nott_cc90_pas[1:1200])*100/length(lu_nott_base_pas)), lu_nott_cc90_pas[1:1200], type = 'l', col = 'blueviolet', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP90T90 Scenario'), col = c('black', 'blueviolet'), lwd = 2, lty = 1, cex = 2)
dev.off()

png(filename = 'soy.png', width = 1400, height = 700)
par(mfrow=c(2,3))
par(mar = c(5.1, 5.4, 4.1, 2.1))
plot(as.numeric(1:length(lu_amhe_base_soy[1:1200])*100/length(lu_amhe_base_soy)), lu_amhe_base_soy[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Amherst', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_amhe_cc10_soy[1:1200])*100/length(lu_amhe_base_soy)), lu_amhe_cc10_soy[1:1200], type = 'l', col = 'chocolate2', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP10T10 Scenario'), col = c('black', 'chocolate2'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_gile_base_soy[1:1200])*100/length(lu_gile_base_soy)), lu_gile_base_soy[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Giles', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_gile_cc50_soy[1:1200])*100/length(lu_gile_base_soy)), lu_gile_cc50_soy[1:1200], type = 'l', col = 'green3', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP50T50 Scenario'), col = c('black', 'green3'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_high_base_soy[1:1200])*100/length(lu_high_base_soy)), lu_high_base_soy[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Highland', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_high_cc90_soy[1:1200])*100/length(lu_high_base_soy)), lu_high_cc90_soy[1:1200], type = 'l', col = 'blueviolet', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP90T90 Scenario'), col = c('black', 'blueviolet'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_harr_base_soy[1:1200])*100/length(lu_harr_base_soy)), lu_harr_base_soy[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Harrisonburg', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_harr_cc10_soy[1:1200])*100/length(lu_harr_base_soy)), lu_harr_cc10_soy[1:1200], type = 'l', col = 'chocolate2', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP10T10 Scenario'), col = c('black', 'chocolate2'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_culp_base_soy[1:1200])*100/length(lu_culp_base_soy)), lu_culp_base_soy[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Culpeper', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_culp_cc50_soy[1:1200])*100/length(lu_culp_base_soy)), lu_culp_cc50_soy[1:1200], type = 'l', col = 'green3', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP50T50 Scenario'), col = c('black', 'green3'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_nott_base_soy[1:1200])*100/length(lu_nott_base_soy)), lu_nott_base_soy[1:1200], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Nottoway', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_nott_cc90_soy[1:1200])*100/length(lu_nott_base_soy)), lu_nott_cc90_soy[1:1200], type = 'l', col = 'blueviolet', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP90T90 Scenario'), col = c('black', 'blueviolet'), lwd = 2, lty = 1, cex = 2)
dev.off()

plot(as.numeric(1:length(lu_high_base_for[1200:2400])*100/length(lu_high_base_for)), lu_high_base_for[1200:2400], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Highland', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_high_cc90_for[1200:2400])*100/length(lu_high_base_for)), lu_high_cc90_for[1200:2400], type = 'l', col = 'blueviolet', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP90T90 Scenario'), col = c('black', 'blueviolet'), lwd = 2, lty = 1, cex = 2)
plot(as.numeric(1:length(lu_nott_base_for[1200:2400])*100/length(lu_nott_base_for)), lu_nott_base_for[1200:2400], type = 'l',
     xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Nottoway', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_nott_cc90_for[1200:2400])*100/length(lu_nott_base_for)), lu_nott_cc90_for[1200:2400], type = 'l', col = 'blueviolet', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP90T90 Scenario'), col = c('black', 'blueviolet'), lwd = 2, lty = 1, cex = 2)

plot(as.numeric(1:length(lu_harr_base_for[1200:2400])*100/length(lu_harr_base_for)), lu_harr_base_for[1200:2400], type = 'l',
    xlab = "Percent Exceedance (%)", ylab = "Runoff (in/day/acre)", lwd = 2, main = 'Highland', cex.lab = 2, cex.axis = 2, cex.main = 2, log = 'y')
lines(as.numeric(1:length(lu_harr_cc10_for[1200:2400])*100/length(lu_harr_base_for)), lu_harr_cc10_for[1200:2400], type = 'l', col = 'blueviolet', lwd = 2, log = 'y')
legend('topright', legend = c('Base Scenario', 'ccP90T90 Scenario'), col = c('black', 'blueviolet'), lwd = 2, lty = 1, cex = 2)