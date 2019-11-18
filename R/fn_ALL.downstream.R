fn_ALL.downstream <- function(riv.seg, AllSegList) {
  downstreamSeg <- fn_downstream(riv.seg, AllSegList)
  Alldownstream <- character(0)
  BranchedSegs <- character(0)
  while (is.na(downstreamSeg[1])==FALSE || is.empty(BranchedSegs) == FALSE) {
    while (is.na(downstreamSeg[1])==FALSE) {
      num.segs <- as.numeric(length(downstreamSeg))
      if (num.segs > 1) {
        BranchedSegs[(length(BranchedSegs)+1):(length(BranchedSegs)+num.segs-1)] <- downstreamSeg[2:num.segs]
        downstreamSeg <- downstreamSeg[1]
      }
      Alldownstream[length(Alldownstream)+1] <- downstreamSeg
      downstreamSeg <- fn_downstream(downstreamSeg, AllSegList)
    }
    num.branched <- as.numeric(length(BranchedSegs))
    downstreamSeg <- BranchedSegs[1]
    BranchedSegs <- BranchedSegs[-1]
  }
  Alldownstream <- Alldownstream[which(Alldownstream != 'NA')]
  if (is.empty(Alldownstream[1])==TRUE) {
    Alldownstream <- 'NA'
  }
  return(Alldownstream)
}