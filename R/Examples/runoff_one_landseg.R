library('hydroTSM')
ro_base_url = 'http://deq2.bse.vt.edu/p6/p6_gb604/out/land'
lseg = 'H51009'

fname <- paste0('land.use.timeseries_', lseg, '.csv')
lu_base <- read.csv(
  paste(
    ro_base_url,
    'CFBASE30Y20180615',
    'eos',
    fname,
    sep='/'
  )
)
lu_cc10 <- read.csv(
  paste(
    ro_base_url,
    'CBASE1808L55CY55R45P10R45P10Y',
    'eos',
    fname,
    sep='/'
  )
)
lu_cc90 <- read.csv(
  paste(
    ro_base_url,
    'CBASE1808L55CY55R45P90R45P90Y',
    'eos',
    fname,
    sep='/'
  )
)

#fd_base$cci <- 
#  lu_base$cci[
#    order(lu_base$cci, decreasing = TRUE)
#  ]

# use log="x" to make x-axis log,
# or use log="" to make NEITHER axis log
fdc(lu_base$cci,log="y",new=TRUE,ylab="Runoff in/acre/day")
fdc(lu_cc10$cci,new=FALSE,col="red")

legend(
  'topright', 
  legend = c('Base Scenario', 'ccP10T10 Scenario'), 
  col = c('black', 'red'), 
)
