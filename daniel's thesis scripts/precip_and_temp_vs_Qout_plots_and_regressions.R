# Creates plots of changes between GCM temperature and precipitation inputs and resultant VA Hydro 
# model precipitation, evapotranspiration, and surface runoff (Qout) flows.

basepath <- '/var/www/R'
source(paste(basepath,"config.local.private", sep = "/"))

dir.location <- '~/Precip_and_Temp_Mapper'
setwd(dir.location)

rseg.info.10 <- read.csv("precip_and_temp_vs_Qout_rseg.info.10.csv")
rseg.info.50 <- read.csv("precip_and_temp_vs_Qout_rseg.info.50.csv")
rseg.info.90 <- read.csv("precip_and_temp_vs_Qout_rseg.info.90.csv")

model.10.cbp6 <- lm(Flow.Change ~ Prcp..Change + Temp..Change, data = rseg.info.10)
model.50.cbp6 <- lm(Flow.Change ~ Prcp..Change + Temp..Change, data = rseg.info.50)
model.90.cbp6 <- lm(Flow.Change ~ Prcp..Change + Temp..Change, data = rseg.info.90)

model.10.vahydro <- lm(Flow.Change ~ Prcp..Change..VA.Hydro. + Evap..Change..VA.Hydro., data = rseg.info.10)
model.50.vahydro <- lm(Flow.Change ~ Prcp..Change..VA.Hydro. + Evap..Change..VA.Hydro., data = rseg.info.50)
model.90.vahydro <- lm(Flow.Change ~ Prcp..Change..VA.Hydro. + Evap..Change..VA.Hydro., data = rseg.info.90)

summary(model.10.cbp6)
# Prcp. Change is significiant -- t-value of -5.435, P(>|t|) = 5.5e-07
# Not a great fit -- adjusted R-squared is 0.4054
plot(rseg.info.10$Prcp..Change, rseg.info.10$Flow.Change)
abline(lm(Flow.Change ~ Prcp..Change, data = rseg.info.10))
legend('topright', legend = paste('Rsq =', round(summary(lm(Flow.Change ~ Prcp..Change, data = rseg.info.10))$r.squared, 2), sep = ' '))
plot(rseg.info.10$Temp..Change, rseg.info.10$Flow.Change)
abline(lm(Flow.Change ~ Temp..Change, data = rseg.info.10))
legend('topright', legend = paste('Rsq =', round(summary(lm(Flow.Change ~ Temp..Change, data = rseg.info.10))$r.squared, 2), sep = ' '))

summary(model.10.vahydro)
# Prcp. Change significant at 0.01 -- t = 3.041, P = 0.0032
# Evap. Change significant at 0.001 -- t = -4.573, P = 1.69e-05
# Bad adjusted R-sq of 0.1838
plot(rseg.info.10$Prcp..Change..VA.Hydro., rseg.info.10$Flow.Change)
abline(lm(Flow.Change ~ Prcp..Change..VA.Hydro., data = rseg.info.10))
legend('topright', legend = paste('Rsq =', round(summary(lm(Flow.Change ~ Prcp..Change..VA.Hydro., data = rseg.info.10))$r.squared, 2), sep = ' '))
plot(rseg.info.10$Evap..Change..VA.Hydro., rseg.info.10$Flow.Change)
abline(lm(Flow.Change ~ Evap..Change..VA.Hydro., data = rseg.info.10))
legend('topright', legend = paste('Rsq =', round(summary(lm(Flow.Change ~ Evap..Change..VA.Hydro., data = rseg.info.10))$r.squared, 2), sep = ' '))

summary(model.50.cbp6)
# Prcp. Change significant at 0.05 -- t = -2.039, P = 0.044
# Temp. Change significant at 0.1 -- t = -1.861, P = 0.066
# Awful fit -- adjusted R-sq = 0.1271
plot(rseg.info.50$Prcp..Change, rseg.info.50$Flow.Change)
abline(lm(Flow.Change ~ Prcp..Change, data = rseg.info.50))
legend('topright', legend = paste('Rsq =', round(summary(lm(Flow.Change ~ Prcp..Change, data = rseg.info.50))$r.squared, 2), sep = ' '))
plot(rseg.info.50$Temp..Change, rseg.info.50$Flow.Change)
abline(lm(Flow.Change ~ Temp..Change, data = rseg.info.50))
legend('topright', legend = paste('Rsq =', round(summary(lm(Flow.Change ~ Temp..Change, data = rseg.info.50))$r.squared, 2), sep = ' '))

summary(model.50.vahydro)
# Prcp. Change significant at 0.05 -- t = 2.099, P = o.038
# Evap. Change significant at 0.01 -- t = -3.10, P = 0.00256
# Awful fit -- adjusted R-sq = 0.072
plot(rseg.info.50$Prcp..Change..VA.Hydro., rseg.info.50$Flow.Change)
abline(lm(Flow.Change ~ Prcp..Change..VA.Hydro., data = rseg.info.50))
legend('topright', legend = paste('Rsq =', round(summary(lm(Flow.Change ~ Prcp..Change..VA.Hydro., data = rseg.info.50))$r.squared, 2), sep = ' '))
plot(rseg.info.50$Evap..Change..VA.Hydro., rseg.info.50$Flow.Change)
abline(lm(Flow.Change ~ Evap..Change..VA.Hydro., data = rseg.info.50))
legend('topright', legend = paste('Rsq =', round(summary(lm(Flow.Change ~ Evap..Change..VA.Hydro., data = rseg.info.50))$r.squared, 2), sep = ' '))


summary(model.90.cbp6)
# Prcp. Change significant at 0.001 -- t = 3.637, P = 0.00057
# Temp. Change significant at 0.01 -- t = -2.779, P = 0.0073
# Decent fit -- adjusted R-sq = 0.6306
plot(rseg.info.90$Prcp..Change, rseg.info.90$Flow.Change)
abline(lm(Flow.Change ~ Prcp..Change, data = rseg.info.90))
legend('topright', legend = paste('Rsq =', round(summary(lm(Flow.Change ~ Prcp..Change, data = rseg.info.90))$r.squared, 2), sep = ' '))
plot(rseg.info.90$Temp..Change, rseg.info.90$Flow.Change)
abline(lm(Flow.Change ~ Temp..Change, data = rseg.info.90))
legend('topright', legend = paste('Rsq =', round(summary(lm(Flow.Change ~ Temp..Change, data = rseg.info.90))$r.squared, 2), sep = ' '))


summary(model.90.vahydro)
# Evap. Change significant at 0.001 -- t = -12.800, P < 2e-16
# Pretty good fit -- adjusted Rsq = 0.767
plot(rseg.info.90$Prcp..Change..VA.Hydro., rseg.info.90$Flow.Change)
abline(lm(Flow.Change ~ Prcp..Change..VA.Hydro., data = rseg.info.90))
legend('topright', legend = paste('Rsq =', round(summary(lm(Flow.Change ~ Prcp..Change..VA.Hydro., data = rseg.info.90))$r.squared, 2), sep = ' '))
plot(rseg.info.90$Evap..Change..VA.Hydro., rseg.info.90$Flow.Change)
abline(lm(Flow.Change ~ Evap..Change..VA.Hydro., data = rseg.info.90))
legend('topright', legend = paste('Rsq =', round(summary(lm(Flow.Change ~ Evap..Change..VA.Hydro., data = rseg.info.90))$r.squared, 2), sep = ' '))

plot(rseg.info.10$Prcp..Change, rseg.info.10$Prcp..Change..VA.Hydro.)
plot(rseg.info.50$Prcp..Change, rseg.info.50$Prcp..Change..VA.Hydro.)
plot(rseg.info.90$Prcp..Change, rseg.info.90$Prcp..Change..VA.Hydro.)

boxplot(rseg.info.10$Flow.Change, rseg.info.50$Flow.Change, rseg.info.90$Flow.Change,
        names = c('ccP10T10', 'ccP50T50', 'ccP90T90'),
        at = c(1,2,3),
        ylab = 'Flow Change from Base Scenario (%)')

avg.runit.vals <- read.csv('avg.runit.vals.csv')
runit.percent.difference <- read.csv('runit.percent.difference.csv')

runit.percent.difference <- runit.percent.difference[complete.cases(runit.percent.difference),]
boxplot(runit.percent.difference$run15, runit.percent.difference$run14, 
        runit.percent.difference$run16,
        names = c('ccP10T10', 'ccP50T50', 'ccP90T90'),
        at = c(1,2,3),
        ylab = 'Surface Runoff Change from Base Scenario (%)')

avg.runit.vals2 <- read.csv('avg.runit.vals2.csv')
runit.percent.difference2 <- read.csv('runit.percent.difference2.csv')

runit.percent.difference2 <- runit.percent.difference2[complete.cases(runit.percent.difference2),]
boxplot(runit.percent.difference2$run17, runit.percent.difference2$run19, 
        runit.percent.difference2$run20,
        names = c('ccP10T10', 'ccP50T50', 'ccP90T90'),
        at = c(1,2,3),
        ylab = 'Surface Runoff Change from Base Scenario (%)')
