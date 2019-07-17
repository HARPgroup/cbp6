withdrawal.comparison <- function(riv.seg) {

  p5.discharge <- read.csv(paste('/opt/model/p53/p532c-sova/out/river/p532cal_062211/eos/ps_sep_div_ams_p532cal_062211_', riv.seg, '_3000.csv'))
  p6.discharge <- read.csv(paste('/opt/model/p6/p6_gb604/out/river/CFBASE30Y20180615/eos/ps_sep_div_ams_CFBASE30Y20180615_', riv.seg, '_3000.csv'))
  if (length(p5.discharge[,5])>(length(p6.discharge[,5]))) {
    p5.discharge <- p5.discharge[1:length(p6.discharge[,5]),]
  } else if (length(p6.discharge[,5])>(length(p5.discharge[,5]))) {
    p6.discharge <- p6.discharge[1:length(p5.discharge[,5]),]
  }
  ident.discharge <- identical(p5.discharge, p6.discharge)
  
  p5.withdrawal <- read.csv(paste('/opt/model/p53/p532c-sova/out/river/p532cal_062211/eos/ps_sep_div_ams_p532cal_062211_', riv.seg, '_3007.csv'))
  p6.withdrawal <- read.csv(paste('/opt/model/p6/p6_gb604/out/river/CFBASE30Y20180615/eos/ps_sep_div_ams_CFBASE30Y20180615_', riv.seg, '_3007.csv'))
  if (length(p5.withdrawal[,5])>(length(p6.withdrawal[,5]))) {
    p5.withdrawal <- p5.withdrawal[1:length(p6.withdrawal[,5]),]
  } else if (length(p6.withdrawal[,5])>(length(p5.withdrawal[,5]))) {
    p6.withdrawal <- p6.withdrawal[1:length(p5.withdrawal[,5]),]
  }
  ident.withdrawal <- identical(p5.withdrawal, p6.withdrawal)
  
  p5.ag.withdrawal <- read.csv(paste('/opt/model/p53/p532c-sova/out/river/p532cal_062211/eos/ps_sep_div_ams_p532cal_062211_', riv.seg, '_3008.csv'))
  p6.ag.withdrawal <- read.csv(paste('/opt/model/p6/p6_gb604/out/river/CFBASE30Y20180615/eos/ps_sep_div_ams_CFBASE30Y20180615_', riv.seg, '_3008.csv'))
  if (length(p5.ag.withdrawal[,5])>(length(p6.ag.withdrawal[,5]))) {
    p5.ag.withdrawal <- p5.ag.withdrawal[1:length(p6.ag.withdrawal[,5]),]
  } else if (length(p6.ag.withdrawal[,5])>(length(p5.ag.withdrawal[,5]))) {
    p6.ag.withdrawal <- p6.ag.withdrawal[1:length(p5.ag.withdrawal[,5]),]
  }
  ident.ag.withdrawal <- identical(p5.ag.withdrawal, p6.ag.withdrawal)
  
  return.statement <- paste('DISCHARGE SAME =', ident.discharge, '; WITHDRAWAL SAME =', ident.withdrawal, '; AG WITHDRAWAL SAME =', ident.ag.withdrawal, sep = ' ')
  return(return.statement)
}