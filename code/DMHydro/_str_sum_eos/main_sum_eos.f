
      implicit none

      include '../../../lib/inc/locations.inc'
      include '../strtopodata.inc'
      include 'eos.inc'

      integer      I_comid
      character*13 C13_comid

      integer I_success


      read*,C_rscen,I_comid

      call loadstreambasindb(C3_basin,I_success)

      call F_C13_comid(I_comid,C3_basin,C13_comid)
      print*,C13_comid

      !write(C_rscen,*) 'null'
      !write(C_rscen,'(A)') '20210601_DyHM'
      !write(C_lscen,*) 'null'
      C_lscen = 'null'
      call sum_eos(I_comid,C13_comid,C_rscen,C_lscen,1984,2014)



      return

      END


