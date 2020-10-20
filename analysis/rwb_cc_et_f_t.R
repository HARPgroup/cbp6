precp_ens_10_pct <- PRCP.ENS.10.PCT
temp_ens_10_pct <- TEMP.ENS.10.PCT
pct_changes_10 <- pct.changes.10
pct_names <- names(pct_changes_10)
pct_names[2] <- 'evap_mean'
names(pct_changes_10) <- pct_names
# medians
precp_ens_50_pct <- PRCP.ENS.50.PCT
temp_ens_50_pct <- TEMP.ENS.50.PCT
pct_changes_50 <- pct.changes.50
names(pct_changes_50) <- pct_names
# 90s
precp_ens_90_pct <- PRCP.ENS.90.PCT
temp_ens_90_pct <- TEMP.ENS.90.PCT
pct_changes_90 <- pct.changes.90
names(pct_changes_90) <- pct_names

dec10 <- sqldf(
  ' select a.FIPS, a.Dec as dec_dpre, b.Dec as dec_dtmp, 
      a.Total as dtmp, b.Total as dpre, c.evap_mean as evap
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
      a.Total as dtmp, b.Total as dpre, c.evap_mean as evap
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
      a.Total as dtmp, b.Total as dpre, c.evap_mean as evap
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
plot(decall$evap ~ decall$dtmp)
plot(decall$dpre ~ decall$dtmp)
# include pcrp.evap.landuse.table.R
plot(pct.changes.10$evap.mean ~ pct.changes.10$prcp.mean, ylim = c(0,20), xlim = c(-10, 30))
points(pct.changes.50$evap.mean ~ pct.changes.50$prcp.mean, col = 'red')
points(pct.changes.90$evap.mean ~ pct.changes.90$prcp.mean, col = 'blue')
# Forest
plot(pct.changes.10$evap.mean ~ pct.changes.10$prcp.mean, ylim = c(0,20), xlim = c(-10, 30))
points(pct.changes.50$evap.mean ~ pct.changes.50$prcp.mean, col = 'red')
points(pct.changes.90$evap.mean ~ pct.changes.90$prcp.mean, col = 'blue')
