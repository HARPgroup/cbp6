source("./fn_lutablegen.R")
basepath <- '/opt/model/p6/p6_gb604'
outpath = basepath 
lu.scenario = 'BASE20180615'
model.scenario = 'CFBASE30Y20180615'
replaceall = FALSE 
lufile.list <- list.files(paste0(basepath, '/input/scenario/river/land_use/'),pattern=lu.scenario)
lufile <- lufile.list[1]
lrseglist <- read.csv(paste0(basepath,'/input/scenario/river/land_use/', lufile))

for (i in 1:length(lrseglist$landseg)) {
  land.segment = as.character(lrseglist$landseg[i])
  river.segment = as.character(lrseglist$riverseg[i])
  outfile = paste0(
    outpath,"/out/land/", model.scenario, 
    "/landuse/","lutable_",
    land.segment,"_",river.segment, ".csv"
  );
  if (replaceall) {
    print(paste("Removing", land.segment, river.segment))
    file.remove(outfile)
  }
  if(!file.exists(outfile)) {
    print(paste("Handling", land.segment, river.segment))
    # Get the base table
    tbl = lutablegen(land.segment, basepath, lu.scenario)
    # Transpose the table 
    tblt <- t(tbl)
    tblt <- as.data.frame(tblt)
    tblt <- cbind(names(tbl), tblt)
    cn <- c("thisyear", tbl$thisyear)
    names(tblt) <- cn
    tbl_om <- sqldf("select * from tblt where thisyear not in ('thisyear', 'riverseg', 'landseg')");
    print(paste0("Writing: ", outfile))
    write.csv(tbl_om, outfile, row.names=FALSE)
  } else {
    print(paste("Skipping", land.segment, river.segment))
  }

}