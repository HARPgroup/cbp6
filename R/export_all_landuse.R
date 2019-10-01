source("./fn_lutablegen.R")
basepath <- '/opt/model/p6/p6_gb604'
lu.scenario = 'BASE20180615'
model.scenario = 'CFBASE30Y20180615'

lufile.list <- list.files(paste0(basepath, '/input/scenario/river/land_use/'),pattern=lu.scenario)
lrsegfile <- lufile.list[1]
lrseglist <- read.csv(paste0(basepath,'/input/scenario/river/land_use/', lufile))

for (i in 1:length(lrseglist)) {
  
  land.segment = as.character(lrseglist[i,"landseg"])
  river.segment = as.character(lrseglist[i,"riverseg"])
  # Get the base table
  tbl = lutablegen(land.segment, basepath, lu.scenario)
  # Transpose the table 
  tblt <- t(tbl)
  tblt <- as.data.frame(tblt)
  tblt <- cbind(names(tbl), tblt)
  cn <- c("thisyear", tbl$thisyear)
  names(tblt) <- cn
  tbl_om <- sqldf("select * from tblt where thisyear not in ('thisyear', 'riverseg', 'landseg')");
  outpath = basepath 
  outfile = paste0(
    outpath,"/out/land/", model.scenario, 
    "/landuse/","lutable_",
    land.segment,"_",river.segment, ".csv"
  );
  print(paste0("Writing: ", outfile))
  write.csv(tbl_om, outfile, row.names=FALSE)

}