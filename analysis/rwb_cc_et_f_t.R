#----------------------------------------------
site <- "http://deq2.bse.vt.edu/d.dh"    #Specify the site of interest, either d.bet OR d.dh
#----------------------------------------------
# Load Libraries
basepath='/var/www/R';
source(paste(basepath,'config.R',sep='/'))
cbp6_location <- 'https://raw.githubusercontent.com/HARPgroup/cbp6/master'
data.location <- paste0(cbp6_location,'/Data/CBP6_Temp_Prcp_Data/')

# TO run this first
# you must include: cbp6/daniel's thesis scripts/prcp_evap_landuse.table.R

pct_names <- names(pct_changes_10)
pct_names[2] <- 'evap_mean'
pct_names[3] <- 'prcp_mean'
pct_names[4] <- 'evap_l30'
pct_names[5] <- 'prcp_l30'
pct_names[6] <- 'evap_l90'
pct_names[7] <- 'prcp_l90'
names(pct_changes_10) <- pct_names
# medians
names(pct_changes_50) <- pct_names
# 90s
names(pct_changes_90) <- pct_names

dec10 <- sqldf(
  ' select a.FIPS, a.Dec as dec_dpre, b.Dec as dec_dtmp, 
      b.Jul as jul_dtmp, 
      a.Total as dpre, b.Total as dtmp, 
      c.evap_mean as evap, c.prcp_mean as prcp, c.fors
    from precp_ens_10_pct as a
    left outer join temp_ens_10_pct as b 
    on (
     a.FIPS = b.FIPS
    )
    left outer join pct_changes_10 as c
    on (
     a.FIPS = substr(c.segment,2,5)
    )
  '
  )
plot(dec10$dec_dpre ~ dec10$dec_dtmp)

dec50 <- sqldf(
  ' select a.FIPS, a.Dec as dec_dpre, b.Dec as dec_dtmp, 
      b.Jul as jul_dtmp, 
      a.Total as dpre, b.Total as dtmp, 
      c.evap_mean as evap, c.prcp_mean as prcp, c.fors
    from precp_ens_50_pct as a
    left outer join temp_ens_50_pct as b 
    on (
     a.FIPS = b.FIPS
    )
    left outer join pct_changes_50 as c
    on (
     a.FIPS = substr(c.segment,2,5)
    )
  '
)
plot(dec50$dec_dpre ~ dec50$dec_dtmp)

dec90 <- sqldf(
  ' select a.FIPS, a.Dec as dec_dpre, b.Dec as dec_dtmp, 
      b.Jul as jul_dtmp, 
      a.Total as dpre, b.Total as dtmp, 
      c.evap_mean as evap, c.prcp_mean as prcp, c.fors
    from precp_ens_90_pct as a
    left outer join temp_ens_90_pct as b 
    on (
     a.FIPS = b.FIPS
    )
    left outer join pct_changes_90 as c
    on (
     a.FIPS = substr(c.segment,2,5)
    )
  '
)
plot(dec90$dec_dpre ~ dec90$dec_dtmp)

decall <- sqldf(
  " select * from dec10 where FIPS like '51%'
    UNION
    select * from dec50 where FIPS like '51%'
    UNION
    select * from dec90 where FIPS like '51%'
  "
)
decall
plot(decall$dec_dpre ~ decall$dec_dtmp)
# change in evap = f(overall change in temp)
plot(
  decall$evap ~ decall$dtmp, 
  xlab = 'Modeled Change in Temperature (%)',
  ylab = 'Modeled Change in Evaporation (%)'
)
# plot the decreasers in p10
plot(dec10$evap ~ dec10$dtmp)
plot(decall$dpre ~ decall$dtmp)
plot(pct_changes_10$evap_mean ~ pct_changes_10$prcp_mean, ylim = c(0,20), xlim = c(-10, 30))
points(pct_changes_50$evap_mean ~ pct_changes_50$prcp_mean, col = 'red')
points(pct_changes_90$evap_mean ~ pct_changes_90$prcp_mean, col = 'blue')
# Forest
plot(pct_changes_10$evap_mean ~ pct_changes_10$fors, ylim = c(-20,80), xlim = c(-30, 80))
points(pct_changes_50$evap_mean ~ pct_changes_50$fors, col = 'red')
points(pct_changes_90$evap_mean ~ pct_changes_90$fors, col = 'blue')


quantile(pct_changes_10$evap_mean)
quantile(pct_changes_10$prcp_mean)

foreg <- lm(fors ~ evap + prcp, data=decall)
summary(foreg)

foreg <- lm(fors ~ evap_mean, data=pct_changes_10)
summary(foreg)
foreg <- lm(fors ~ prcp_mean, data=pct_changes_10)
summary(foreg)
plot(pct_changes_10$fors ~ pct_changes_10$evap_mean , ylim = c(-40,20), xlim = c(0, 5))
foreg <- lm(fors ~ evap_mean + prcp_mean, data=pct_changes_10)
summary(foreg)
quantile(pct_changes_10$evap_mean)
quantile(pct_changes_10$prcp_mean)
quantile(pct_changes_10$fors )


pct_changes_10_wet <- sqldf("select * from pct_changes_10 where prcp_l90 > -5")
plot(pct_changes_10_wet$fors ~ pct_changes_10_wet$evap_mean , ylim = c(-40,20), xlim = c(0, 5))
foreg <- lm(fors ~ prcp_mean, data=pct_changes_10_wet)
summary(foreg)
foreg <- lm(fors ~ evap_mean, data=pct_changes_10_wet)
summary(foreg)
foreg <- lm(fors ~ evap_mean + prcp_mean, data=pct_changes_10_wet)
summary(foreg)

quantile(pct_changes_10$evap_l90)
quantile(pct_changes_10$prcp_l90)
quantile(pct_changes_50$evap_l90)
quantile(pct_changes_50$prcp_l90)
quantile(pct_changes_50$evap_mean)
quantile(pct_changes_50$prcp_mean)


# Raw meteorological data from WDMs
p6dat <- '/opt/model/p6/p6_gb604/out/climate'
lseg <- 'N51107'
fname <- paste0(lseg, '_1000-2000.csv')
p10_met <- read.csv(paste(p6dat,'5545HS10CA2_and_55R45KK1095',fname,sep='/'))

