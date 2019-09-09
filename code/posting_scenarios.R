counter <- 1

github_link <- "C:\\Users\\danie\\Documents\\HARP\\Github"
site_url <- "http://deq2.bse.vt.edu/d.dh"

cbp6_link = paste0(github_link, "/cbp6/code");

# Sourcing functions
source(paste0(cbp6_link,"/cbp6_functions.R"))

#retrieve rest token
source(paste0(github_link, "/auth.private"));

#load rest username and password, contained in auth.private file

token <- rest_token(site_url, token, rest_uname, rest_pw);
options(timeout=120); # set timeout to twice default level to avoid abort due to high traffic

info <- read.csv(paste0(cbp6_link, "/data.csv"))

while (counter <= length(info$riv.seg)) {
  print(paste0('creating scenario ', counter, ' of ', length(info$riv.seg)))
  vahydro_post_scenario(seg.or.gage = as.character(info$riv.seg[counter]), mod.scenario = 'CBASE1808L55CY55R45P50R45P50Y', token = token, site = site_url)
  counter <- counter + 1
}
