library(knitr)
library("png")
github_link <- "/usr/local/home/git"
authloc <- paste0(github_link, "/hydro-tools");
cbp6_link <- paste0(github_link, "/cbp6/code");
source(paste0(cbp6_link,"/cbp6_functions.R"))
source(paste(authloc,"auth.private", sep = "/"));#load rest username and password, contained in
source(paste(cbp6_link, "/fn_vahydro-1.0.R", sep = ''))
token <- rest_token(site, token, rest_uname, rest_pw);
options(timeout=1200); # set timeout to twice default level to avoid abort due to high traffic

riv.seg <- 'YP3_6700_6670'
start.date <- '1984-01-01'
end.date <- '2014-12-31'
site <- 'http://deq2.bse.vt.edu/d.dh'
site.or.server <- 'site'
run.id1 <- 120
run.id2 <- 121
gage_number <- '01671020'

data2 <- vahydro_import_data_cfs(riv.seg, run.id1, token, site, start.date, end.date)
data1 <- gage_import_data_cfs(gage_number, start.date, end.date)

# TRIMMING DATA TO PROPER WATER YEAR
data1 <- water_year_trim(data1)
data2 <- water_year_trim(data2)

all_data <- all_data_maker(data1, data2)

fig1.hydrograph(all_data, 'USGS', "VAHydro")
#include_graphics("fig1.png")
pp <- readPNG("fig1.png")
plot.new() 
rasterImage(pp,0,0,1,1)

metrics1 <- metrics_calc_all(data1)
metrics2 <- metrics_calc_all(data2)
percent_difference <- metrics_compare(metrics1, metrics2, riv.seg)

Table1 <- tab1.monthly.low.flows(percent_difference)
Table2 <- tab2.monthly.average.flows(percent_difference)


#https://github.com/HARPgroup/cbp6/blob/master/code/automated_metric_2_vahydro.R