
      implicit none

      include 'stream.inc'

      character*13 C13_igroup

      integer I_success


      read*,C_rscen,C13_igroup


      call stream(C_rscen,C13_igroup)


      return

      END
