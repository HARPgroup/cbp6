fig10.runit.boxplot <- function(lri.dat) {
  boxplot(as.numeric(lri.dat$flow.unit) ~ year(lri.dat$date), outline = FALSE, ylab = 'Runit Flow (cfs)', xlab = 'Date')
  dev.copy(png, 'fig10.png')
  dev.off()
  print(paste('Fig. 10: Runit Boxplot saved at location ', as.character(getwd()), '/fig10.png', sep = ''))
}
