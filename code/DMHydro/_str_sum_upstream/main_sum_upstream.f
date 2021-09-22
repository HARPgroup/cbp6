
      implicit none

      include 'upstream.inc'

      character*13 C13_igroup

      integer I_success


      read*,C_rscen,C13_igroup


      !write(C_rscen,*) 'null'
      !write(C_rscen,'(A)') '20210601_DyHM'
      !write(C_lscen,*) 'null'
      call sum_upstream(C_rscen,C13_igroup)



      return

      END


