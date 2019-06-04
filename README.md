# cbp6
#hsioauvb
``` r
USGS_flow <- readNWISuv(gage_id, pCode, startDate, endDate)

colnames(USGS_flow) <- c('Agency','Gage Number','Date/Time','Flow','Flow Code','tz_cd')

years <- year(USGS_flow$`Date/Time`) #extract year data from Date/Time column
USGS_flow$Year <- years #add year as a new column

#USGS_flow_2017 <- USGS_flow %>% filter(Year == 2017)
USGS_flow_2017 <- filter(USGS_flow,Year==2017)
```


