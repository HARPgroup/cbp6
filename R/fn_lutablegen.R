library('sqldf')
basepath <- '/opt/model/p6/p6_gb604'
land.segment = 'N51005'
river.segment = 'JU3_7400_7510'
// test 
land.segment, basepath, lu.scenario = 'BASE20180615', outpath;
lutablegen(
lutablegen <- function(land.segment, basepath, lu.scenario, outpath) {
  # INPUTS ----------
  lufile.list <- list.files(paste0(basepath, '/input/scenario/river/land_use/',pattern=lu.scenario)
  lutable = FALSE
  for (i in 1:length(lufile.list)) {
    lufile <- lufile.list[i]
    luyear <- substr(lufile, 10,13)
    luyearfile <- paste0(basepath,'/input/scenario/river/land_use/', lufile)
    luyeardata <- read.csv(luyearfile)
    q = paste0(
      "select ", luyear, " as thisyear, ",
      "luyeardata.* ",
      "from luyeardata where ",
      "landseg = '", land.segment, 
      "' and riverseg = '", river.segment, "'"
    )
    
    if (!is.logical(lutable)) {
      q <- paste(q, " UNION select * from lutable ")
    }
    lutable <- sqldf(q)
  }
  lus <- names(lutable) 
  # Fix the funky "for." on the forest column name 
  lus <- lapply(lus, function(x) gsub("[.]", "", x))
  names(lutable) <- lus 
  lutable <- t(lutable)
  
}
  