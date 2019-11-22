nse = function(gage.dat, scen.dat) {
  gage.mean <- mean(gage.dat$flow)
  nse <- 1 - (sum((scen.dat$flow - gage.dat$flow)^2)/sum((gage.dat$flow - gage.mean)^2))
  nse <- round(nse, digits = 3)
  return(nse)
}
