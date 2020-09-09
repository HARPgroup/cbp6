fig10.runit.boxplot <- function(lri.dat, export_path = '/tmp/') {
  boxplot(as.numeric(lri.dat$flow.unit) ~ year(lri.dat$date), outline = FALSE, ylab = 'Runit Flow (cfs)', xlab = 'Date')
  outfile <- paste0(export_path,"fig10.png")
  dev.copy(png, outfile)
  dev.off()
  print(paste('Fig. 10: Runit Boxplot saved at location ', outfile, sep = ''))
}
