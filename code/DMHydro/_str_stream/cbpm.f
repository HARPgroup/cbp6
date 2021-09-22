
      !*****************************************************************
      !*****************************************************************
      SUBROUTINE CBPM_HYDR(
     I     wdmrch,
     I     nRvarInp,RdsnInp,RnameInp,
     I     nRvarOut,RdsnOut,RnameOut,
     I     sdate,edate )
      !{

       implicit none

       include 'stream.inc'


       integer wdmrch

       character*4 Rvar

!       double precision D_RI_WATR_(ndaymax*24)
!       double precision D_RO_WATR_(ndaymax*24)

       double precision D_RI_WATR_(ndaymax*24)
       real D_RO_WATR_(ndaymax*24)

       integer nvals_
       integer it1

       print*,'... CBPM_HYDR WATR'
       Rvar = 'WATR'

       call getrdata(
     I     wdmrch,
     I     nRvarInp,RdsnInp,RnameInp,
     I     sdate,edate,
     I     Rvar,
     O     D_RI_WATR_, nvals_)


       do it1 = 1,nvals_
          D_RO_WATR_(it1) = D_RI_WATR_(it1)
       end do
 

       call putrdata(
     I     wdmrch,
     I     nRvarOut,RdsnOut,RnameOut,
     I     sdate,edate,
     I     Rvar,
     I     D_RO_WATR_, nvals_ )

      !}
      END SUBROUTINE CBPM_HYDR
      !*****************************************************************
      !*****************************************************************





      !*****************************************************************
      !*****************************************************************
      SUBROUTINE CBPM_HTRCH(
     I     wdmrch,
     I     nRvarInp,RdsnInp,RnameInp,
     I     nRvarOut,RdsnOut,RnameOut,
     I     sdate,edate )
      !{

       implicit none

       include 'stream.inc'


       integer wdmrch

       character*4 Rvar

!       double precision D_RI_HEAT_(ndaymax*24)
!       double precision D_RO_HEAT_(ndaymax*24)

       double precision D_RI_HEAT_(ndaymax*24)
       real D_RO_HEAT_(ndaymax*24)

       integer nvals_
       integer it1

       print*,'... CBPM_HTRCH HEAT'
       Rvar = 'HEAT'

       call getrdata(
     I     wdmrch,
     I     nRvarInp,RdsnInp,RnameInp,
     I     sdate,edate,
     I     Rvar,
     O     D_RI_HEAT_, nvals_)


       do it1 = 1,nvals_
          D_RO_HEAT_(it1) = D_RI_HEAT_(it1)
       end do


       call putrdata(
     I     wdmrch,
     I     nRvarOut,RdsnOut,RnameOut,
     I     sdate,edate,
     I     Rvar,
     I     D_RO_HEAT_, nvals_ )

      !}
      END SUBROUTINE CBPM_HTRCH
      !*****************************************************************
      !*****************************************************************







      SUBROUTINE getrdata (
     I     wdmrch_,
     I     nRvar_,Rdsn_,Rname_,
     I     sdate,edate,
     I     C4_Rvar_,
     O     D_rdata_,
     O     nvals)
      !{

       implicit none

       include 'stream.inc'

       integer wdmrch_
       integer nRvar_
       integer Rdsn_(maxRvar)    
       character*4 Rname_(maxRvar) 
       character*4 C4_Rvar_

!       double precision D_rdata_(ndaymax*24)
!       double precision D_thdat_(ndaymax*24)
       double precision D_rdata_(ndaymax*24)
       real D_thdat_(ndaymax*24)

       integer iRvar

       integer it1

       print*,wdmrch_
       print*,sdate(1),sdate(2),sdate(3)
       print*,edate(1),edate(2),edate(3)
       print*,' '

       do it1 = 1,ndaymax
          D_rdata_(it1) = 0.0
       end do

       do iRvar = 1,nRvar_
          if ( Rname_(iRvar) .eq. C4_Rvar_ ) then
             print*,'... reading from ',Rname_(iRvar),Rdsn_(iRvar)
             call gethourdsn(wdmrch_,sdate,edate,
     .                Rdsn_(iRvar),nvals,D_thdat_)
             print*,'nvals = ',nvals
             do it1 = 1,nvals
                D_rdata_(it1) = D_rdata_(it1) + D_thdat_(it1)
             end do
          end if
       end do

       return

      !}
      END SUBROUTINE getrdata 






      SUBROUTINE putrdata (
     I     wdmrch_,
     I     nRvar_,Rdsn_,Rname_,
     I     sdate,edate,
     I     C4_Rvar_,
     I     D_thdat_,
     I     nvals)
      !{

       implicit none

       include 'stream.inc'

       integer wdmrch_
       integer nRvar_
       integer Rdsn_(maxRvar)
       character*4 Rname_(maxRvar)
       character*4 C4_Rvar_

!       double precision D_rdata_(ndaymax*24)
!       double precision D_thdat_(ndaymax*24)
       real D_thdat_(ndaymax*24)

       integer iRvar

       integer it1


       do iRvar = 1,nRvar_
          if ( Rname_(iRvar) .eq. C4_Rvar_ ) then
             print*,'... writing to ',Rname_(iRvar),Rdsn_(iRvar)
             call puthourdsn(wdmrch_,sdate,edate,
     .                Rdsn_(iRvar),nvals,D_thdat_)
          end if
       end do

       return

      !}
      END SUBROUTINE putrdata
