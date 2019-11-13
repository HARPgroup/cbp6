fig10.runit.boxplot <- function(riv.seg, run.id, token, site, start.date, end.date) {
  dat <- vahydro_import_local.runoff.inflows_cfs(riv.seg, run.id, token, site, start.date, end.date);
  dat <- subset(dat, dat$date >= start.date & dat$date <= end.date);
  
  boxplot(as.numeric(dat$flow.unit) ~ year(dat$date), outline = FALSE, ylab = 'Runit Flow (cfs)', xlab = 'Date')
  dev.copy(png, 'fig10.png')
  dev.off()
  print(paste('Fig. 10: Runit Boxplot saved at location ', as.character(getwd()), '/fig10.png', sep = ''))
}
