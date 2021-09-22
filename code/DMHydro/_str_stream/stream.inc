      include '../../../lib/inc/standard.inc'
      include '../../../lib/inc/locations.inc'
      include '../../../lib/inc/wdm.inc'
      include '../../../lib/inc/upstream.inc'
      include '../../../lib/inc/modules.inc'
      include '../../../lib/inc/masslinks.inc'


      integer nRvarInp,nRvarOut              ! number of river variables
      integer RdsnInp(maxRvar)    ! dsn for each input river variable
      integer RdsnOut(maxRvar)   ! dsn for each output river variable
      character*4 RnameInp(maxRvar) ! variable name for RdsnInp
      character*4 RnameOut(maxRvar) ! variable name for RdsnOut

      integer sdate(ndate), edate(ndate)  ! start and end dates in wdm format



      character*50 C_rscen
      integer      I_rscen

