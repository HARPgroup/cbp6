github_link = 'C:\\Users\\danie\\Documents\\HARP\\GitHub'
site = "http://deq2.bse.vt.edu/d.dh"
cbp6_link = paste0(github_link, "/cbp6/code") 
source(paste0(cbp6_link,"/cbp6_functions.R"))

#retrieve rest token
source(paste(github_link,"auth.private", sep = "/"));#load rest username and password, contained in auth.private file
token1 <- rest_token(site, token1, rest_uname, rest_pw);
options(timeout=120); # set timeout to twice default level to avoid abort due to high traffic
token <- token1

cbp6_link = paste0(github_link, "/cbp6/code") 
source(paste0(cbp6_link,"/cbp6_functions.R"))

#retrieve rest token
source(paste(github_link,"auth.private", sep = "/"));#load rest username and password, contained in auth.private file
# token <- rest_token(site, token, rest_uname, rest_pw);
# options(timeout=120); # set timeout to twice default level to avoid abort due to high traffic

mod.scenario <- 'CFBASE30Y20180615'
mod.scenario <- 'CBASE1808L55CY55R45P50R45P50Y'

# CREATING LIST OF RIVER SEGS ---------------------------------------------------

info <- read.csv(paste0(cbp6_link, "/data.csv"))
all.riv.segs <- as.vector(info$riv.seg)

num.segs <- as.numeric(length(all.riv.segs))
seg.names <- all.riv.segs

metrics.names <- 'x7q10'

num.metrics <- length(metrics.names)

# CREATES EMPTY DATA FRAME WITH DIMENSIONS OF ALL METRICS BY NUM.SEGS ------------
all.errors.all.segments <- data.frame(matrix(NA, nrow = num.segs, ncol = num.metrics))
colnames(all.errors.all.segments) <- metrics.names
rownames(all.errors.all.segments) <- seg.names

# POPULATES DATA FRAME WITH ALL_METRICS PERCENT ERROR DATA -----------------------
all.errors.line.no <- 1
start.num <- 1

for (i in start.num:num.segs) {
  RivSeg <- all.riv.segs[i]
  print(paste('Downloading data for segment', i, 'of', num.segs))
  
  # GETTING MODEL DATA FROM VA HYDRO
  hydrocode = paste("vahydrosw_wshed_",RivSeg,sep="");
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
  print(paste("Retrieved hydroid",hydroid,"for", fname,RivSeg, sep=' '));
  # get the p5.3.2, scenario  model segment attached to this river feature
  inputs <- list(
    varkey = "om_model_element",
    featureid = hydroid,
    entity_type = "dh_feature",
    propcode = mod.scenario
  )
  token = token
  model <- getProperty(inputs, site, model)
  all.metrics <- data.frame(matrix(NA, nrow = 1, ncol = num.metrics))
  # Getting the contributing drainage area feature
  areainfo <- list(
    varkey = "wshed_drainage_area_sqmi",
    featureid = as.integer(as.character(hydroid)),
    entity_type = "dh_feature"
  )
  contrib.drain.area <- getProperty(areainfo, site, contrib.drain.area)
  all.metrics[1,num.metrics] <- contrib.drain.area$propvalue
  all.metrics[1,num.metrics] <- all.metrics[1,num.metrics]
  
  # GETTING MODEL METRICS FROM VA HYDRO
  # 35: 7Q10
  alfinfo <- list(
    varkey = "7q10",
    featureid = as.integer(as.character(model$pid)),
    entity_type = "dh_properties"
  )
  alfprop <- getProperty(alfinfo, site, alfprop)
  all.metrics[1,1] <- alfprop$propvalue
  
  all.errors.all.segments[all.errors.line.no,] <- all.metrics[1,1:num.metrics]
  #Normalizing data: dividing all metrics by the contributing drainage area of the river segment
  all.errors.all.segments[all.errors.line.no,-num.metrics] <- all.errors.all.segments[all.errors.line.no,-num.metrics]/all.errors.all.segments[all.errors.line.no,num.metrics]
  all.errors.line.no <- all.errors.line.no + 1
}

Metrics <- all.errors.all.segments[,]
Metrics

probs <- which(Metrics == 'NaN')
seg.names[probs]
