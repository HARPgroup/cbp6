basepath <- '/opt/model/p6/p6_gb604'
land.segment = 'N51121'
river.segment = 'JU1_7690_7490'
lu.scenario = 'BASE20180615'
model.scenario = 'CFBASE30Y20180615'
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
write.csv(tbl_om, outfile, row.names=FALSE)

