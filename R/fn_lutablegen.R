library('sqldf')

lutablegen <- function(land.segment, basepath, lu.scenario) {
  # INPUTS ----------
  lufile.list <- list.files(paste0(basepath, '/input/scenario/river/land_use/'),pattern=lu.scenario)
  lutable_yrs = FALSE
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
    lutable <- sqldf(q)
    lutable <- lutable[,names(lutable)]
    if (!is.logical(lutable_yrs)) {
      q <- "select * from lutable_yrs UNION select * from lutable "
    } else {
      q <- " select * from lutable "
    }
    lutable_yrs <- sqldf(q)
  }
  lus <- names(lutable_yrs) 
  # Fix the funky "for." on the forest column name 
  # do it on all in case there are other odd ones 
  lus <- lapply(lus, function(x) gsub("[.]", "", x)) 
  names(lutable_yrs) <- lus 
  lutable_yrs <- t(lutable_yrs)
  return(lutable_yrs)
}
  