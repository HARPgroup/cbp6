RivSeg <- 'JB0_7051_0001'

inflow <- read.csv(paste0('http://deq2.bse.vt.edu/p6/p6_gb604/out/river/CFBASE30Y20180615/stream/', 
                                RivSeg, "_0011.csv"), header = FALSE, sep = ",", stringsAsFactors = FALSE);

discharge <- read.csv(paste0('http://deq2.bse.vt.edu/p6/p6_gb604/out/river/CFBASE30Y20180615/eos/', 
                          RivSeg, "_3007.csv"), header = FALSE, sep = ",", stringsAsFactors = FALSE);

ag.discharge <- read.csv(paste0('http://deq2.bse.vt.edu/p6/p6_gb604/out/river/CFBASE30Y20180615/eos/', 
                             RivSeg, "_3008.csv"), header = FALSE, sep = ",", stringsAsFactors = FALSE);

outflow <- read.csv(paste0('http://deq2.bse.vt.edu/p6/p6_gb604/out/river/CFBASE30Y20180615/eos/', 
                                RivSeg, "_3000.csv"), header = FALSE, sep = ",", stringsAsFactors = FALSE);

calc.outflow <- inflow$V5 - (discharge$V5 + ag.discharge$V5)

which(outflow$V5 > 0)
which(calc.outflow > 0)
