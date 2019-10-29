lriv.seg1 <- 'N51007_JA5_7480_0001'
lriv.seg2 <- 'N51053_JA5_7480_0001'
lriv.seg3 <- 'N51135_JA5_7480_0001'
lriv.seg4 <- 'N51041_JA5_7480_0001'
riv.seg <- 'JA5_7480_0001'

run.id <- '122'
start.date <- '1984-01-01'
end.date <- '2014-12-31'

github_link <- "C:\\Users\\danie\\Documents\\HARP\\GitHub"
cbp6_link <- paste0(github_link, "/cbp6/code");
source(paste0(cbp6_link,"/cbp6_functions.R"))
source(paste(github_link,"auth.private", sep = "/"));#load rest username and password, contained in
source(paste(cbp6_link, "/fn_vahydro-1.0.R", sep = ''))
site <- "http://deq2.bse.vt.edu/d.dh"
token <- rest_token(site, token, rest_uname, rest_pw);

dat.lr1 <- vahydro_import_lrseg_data_cfs(riv.seg = lriv.seg1, run.id = run.id, site = site,
                                         token = token, start.date = start.date, end.date = end.date)
dat.lr2 <- vahydro_import_lrseg_data_cfs(riv.seg = lriv.seg2, run.id = run.id, site = site,
                                         token = token, start.date = start.date, end.date = end.date)
dat.lr3 <- vahydro_import_lrseg_data_cfs(riv.seg = lriv.seg3, run.id = run.id, site = site,
                                         token = token, start.date = start.date, end.date = end.date)
dat.lr4 <- vahydro_import_lrseg_data_cfs(riv.seg = lriv.seg4, run.id = run.id, site = site,
                                         token = token, start.date = start.date, end.date = end.date)
dat.r <- vahydro_import_data_cfs(riv.seg = riv.seg, run.id = run.id, site = site,
                                 token = token, start.date = start.date, end.date = end.date)

mean(dat.lr1$flow) + mean(dat.lr2$flow) + mean(dat.lr3$flow) + mean(dat.lr4$flow)
mean(dat.r$flow)
