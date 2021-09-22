
      SUBROUTINE sum_upstream(
     I       C_rscen,
     I       C13_rseg)


      !{ 
       implicit none

       include 'upstream.inc'
       !include '../../../lib/inc/locations.inc'
       !include '../../../lib/inc/modules.inc'
       include '../units.inc'

       include '../strtopodata.inc'

       character*13 C13_rseg

       integer I_comid_
       integer I_success_
       character*13 C13_eos_
       character*13 C13_upseg_

       integer comidx2
       external comidx2

       integer RvarInp,RvarOut
       integer It1,It2
       integer Ix1,Ix2
       integer Iup

       !integer sdate(ndate),edate(ndate)

       character*200 C_filename_
       integer Ifile_,err_
       character*200 line_

       character*20 Cnull

       integer     Ifeatureid

       integer   wdmfil
       parameter (wdmfil=51)

       integer   wdmrch
       parameter (wdmrch=wdmfil+2)

!       double precision D_rhdat(ndaymax*24,maxRvar) !hourly river data
!       double precision D_thdat(ndaymax*24)

       double precision D_rhdat(ndaymax*24,maxRvar) !hourly river data
       real D_thdat(ndaymax*24)

       integer Nexits

       integer I_ISAGRP

       integer I_MAXRCH
       parameter (I_MAXRCH = 100)
       integer IX_GRPRCH(I_MAXRCH,2)
       integer I_NREACH


       !*** Step 00: 
       !*** Step 01: 
       !*** Step 02: 
       !*** Step 03: 
     

       call lencl(C_rscen,I_rscen)

       call readcontrol_Rioscen(
     I                         C_rscen,I_rscen,
     O                         ioscen)
       call lencl(ioscen,lenioscen)
       print*,ioscen(:lenioscen)



 

       !*** >> Step 00:

       call loadcomidsxdb(I_NCOMIDS,I_comids,I_success_)
       print*,I_success_
       print*,'I_NCOMIDS = ',I_NCOMIDS
       !print*,I_comids(1)

       call loadupstreamdb(I_upstreamdb,I_success_)
       print*,I_success_

       call loaddivfracdb(D_divfracdb,I_success_)
       print*,I_success_

       call loadtidaldb(D_tidaldb,I_success_)
       print*,I_success_

       call loadstreamroutingdb(C11_routing,I_success_)
       print*,I_success_

       call loadstreamgroupdb(C13_GRPstream,I_success_)
       print*,I_success_
       I_ISAGRP = 0
       do Ix2 = 1,I_NCOMIDS
          if ( C13_GRPstream(Ix2) .eq. C13_rseg ) then
             I_ISAGRP = 1
             !go to 0101
             exit
          end if
       end do
0101   print*,'Is a Group? = ',I_ISAGRP

       call loadstreambasindb(C3_basin,I_success_)
       call loadstreamgroupnamedb(C13_GRPname,I_success_)

       call loadstreamsimulationdb(C4_simulation,I_success_)



       I_NREACH = 0
       do Ix2 = 1,I_NCOMIDS
          if ( C13_GRPname(Ix2) .eq. C13_rseg ) then
             I_comid_ = I_comids(Ix2)
             I_NREACH = I_NREACH + 1
             IX_GRPRCH(I_NREACH,1) = I_comid_
             IX_GRPRCH(I_NREACH,2) = Ix2
          end if
       end do


       call readcontrol_time(C_rscen,I_rscen,sdate,edate)  ! get start and stop
       print*,sdate(1),sdate(2),sdate(3)
       print*,edate(1),edate(2),edate(3)
       call readcontrol_modules(C_rscen,I_rscen,
     O                         modules,nmod)



       wdmfnam = dummyWDMname
       call wdbopnlong(wdmfil+1,wdmfnam,0,err)


       do It2 = 1,ndaymax
          do RvarInp = 1,maxRvar
             D_rhdat(It2,RvarInp) = 0.0
          end do
       end do


       do It1 = 1,I_NREACH
          Ix1 = IX_GRPRCH(It1,1)
          Ix2 = IX_GRPRCH(It1,2)
          write(*,'(A,I9$)')C13_rseg,Ix1
          
          write(C13_eos_,'(A,A,I0.9)') C3_basin(Ix2),'_',Ix1
          write(*,'(A,A,A$)') ' (+eos ',C13_eos_,')'

          wdmfnam = outwdmdir//'river/'//C_rscen(:I_rscen)//
     .              '/eos/'//C13_eos_//'.wdm'
          !print*,wdmfnam
          call wdbopnlong(wdmfil,wdmfnam,1,err)     ! open eos wdm read only
          if (err .eq. -2) go to 992
          if (err .ne.  0) go to 993

          !TODO MAYBE need to get Nexits
          Nexits = 3
          call Rmasslink(
     I                   ioscen,lenioscen,
     I                   Nexits,modules,nmod,
     O                   nRvarInp,RdsnInp,RnameInp,
     O                   nRvarOut,RdsnOut,RnameOut)    ! POPULATE nRvar, Rdsn, Rname
          !print*,RnameInp(1)
          !TODO 
          !call wtdate(wdmfil,1,RdsnOut(1),2,asdate,aedate,err)  !
          !tests the date
          !if (err .ne. 0) go to 994

          !*** Add EOS
          do RvarInp = 1,nRvarInp
             !print*,RnameInp(RvarInp),RdsnInp(RvarInp),nvals
             call gethourdsn(wdmfil,sdate,edate,
     .             RdsnInp(RvarInp),nvals,D_thdat)
             !print*,RnameInp(RvarInp),RdsnInp(RvarInp),nvals
             do It2 = 1,nvals
                D_rhdat(It2,RvarInp) = D_rhdat(It2,RvarInp) 
     .                               + D_thdat(It2)
             end do
          end do
          call wdflcl(wdmfil,err)
          if (err.ne.0) go to 995


          !*** Add Upstream
          call streamrouting(Ix1,Ix2,D_tidaldb,C11_routing,C3_routing)
          if ( D_divfracdb(Ix2).gt.0 .and. C3_routing.eq.'YES') then
          do Iup = 1,I_upstreamdb(Ix2,1)
             if (C13_GRPname(comidx2(I_upstreamdb(Ix2,Iup+1))) 
     .           .eq. C13_rseg) cycle

             ! ?? ?? ?? TODO TODO TODO TODO TODO 
             ! Next if statement is a temporary fix only 
             ! A better provision would be to identify if the upstream
             ! is a group of streams ( an implementation would require
             ! and new column in ROUTING attribute file with a new colum 
             ! with number of streams in the group
             if (C4_simulation(comidx2(I_upstreamdb(Ix2,Iup+1))) 
     .           .eq. 'HSPF' .and. D_divfracdb(Ix2) .lt. 1 ) cycle

!             if (C13_GRPname(comidx2(I_upstreamdb(Ix2,Iup+1)))
!     .           .ne. 'null       ') then
!                write(*,'(A,A$)')  ' << ',
!     .                C13_GRPname(comidx2(I_upstreamdb(Ix2,Iup+1)))
!             else
!                write(*,'(A,I9$)') ' << ',I_upstreamdb(Ix2,Iup+1)
!             end if
             C13_upseg_ = C13_GRPname(comidx2(I_upstreamdb(Ix2,Iup+1)))
             write(*,'(A,A$)')  ' << +rivO ',C13_upseg_

             wdmfnam = outwdmdir//'river/'//C_rscen(:I_rscen)//
     .              '/stream/'//C13_upseg_//'.wdm'
             call wdbopnlong(wdmfil,wdmfnam,1,err)     ! open eos wdm read only
             if (err .eq. -2) go to 992
             if (err .ne.  0) go to 993

             !TODO need to get Nexits for the upstream
             Nexits = 3
             call Rmasslink(
     I                   ioscen,lenioscen,
     I                   Nexits,modules,nmod,
     O                   nRvarInp, RdsnInp, RnameInp,
     O                   nRvarOut,RdsnOut,RnameOut)    ! POPULATE nRvar, Rdsn, Rname

             do RvarInp = 1,nRvarInp
                do RvarOut = 1,nRvarOut
                   if (RnameInp(RvarInp).eq.RnameOut(RvarOut)) then
                      call gethourdsn(wdmfil,sdate,edate,
     .                      RdsnOut(RvarOut),nvals,D_thdat)
                      !print*,RnameOut(RvarOut),RdsnOut(RvarOut),nvals
                      do It2 = 1,nvals
                         D_rhdat(It2,RvarInp) = D_rhdat(It2,RvarInp) 
     .                                        + D_thdat(It2) 
     .                                          * D_divfracdb(Ix2)
                      end do
                   end if
                end do
             end do
             call wdflcl(wdmfil,err)
             if (err.ne.0) go to 996

          end do
          write(*,*) ' '
          end if
       end do


       wdmfnam = C13_rseg//'.wdm'
       call wdbopnlong(wdmrch,wdmfnam,0,err)     ! open main wdm read/write
       if (err .ne. 0) go to 991


       do RvarInp = 1,nRvarInp
          print*,'... writing ',RnameInp(RvarInp),RdsnInp(RvarInp)
          do It2=1,nvals
             D_thdat(It2) = D_rhdat(It2,RvarInp)
          end do
          call puthourdsn(wdmrch,sdate,edate,
     .            RdsnInp(RvarInp),nvals,D_thdat)
       end do

       call wdflcl(wdmrch,err)
       if (err.ne.0) go to 995


       return

901    if (err.lt.0) then
        report(1) = 'Error: opening wdm= '
        write(report(1)(22:24),'(i3)')err
        report(2) = wdmfnam
       else
        report(1) = wdmfnam
        report(2) = ' is not a wdm file'
       end if
       report(3) = ' '
       go to 999

902    write(report(1),*) 'ERROR Unable to open file - ',err_
       report(2) = C_filename_
       report(3) = ''
       go to 999

991   report(1) = 'Problem with opening wdm '//wdmfnam
      report(2) = '  Error =    '
      write(report(2)(11:13),'(i3)') err
      report(3) = 'Segment '//C13_rseg
      go to 999

992   report(1) = 'Problem opening wdm '//wdmfnam
      report(2) = '  WDM does not exist'
      report(3) = ' upstream segment probably not run'
      go to 999

993   report(1) = 'Problem opening wdm '//wdmfnam
      report(2) = '  Error = '
      write(report(2)(11:13),'(i3)') err
      report(3) = ' probably need to rerun'//C13_upseg_
      go to 999

995   report(1) = ' Could not close wdm'
      report(2) = ' EOS for segment '//C13_eos_
      report(3) = wdmfnam
      go to 999

996   report(1) = ' Could not close wdm'
      report(2) = ' up STREAM for segment '//C13_upseg_
      report(3) = wdmfnam
      go to 999

997   report(1) = ' Could not close wdm'
      report(2) = ' out STREAM for segment '//C13_rseg
      report(3) = wdmfnam
      go to 999

999    call stopreport(report)

      END
















      SUBROUTINE Rmasslink(
     I                     ioscen,lenioscen,
     I                     upNexits,modules,nmod,
     O                     nRvarInp,RdsnInp,RnameInp,
     O                     nRvarOut,RdsnOut,RnameOut)   
      implicit none

      include 'upstream.inc'

      integer upNexits     ! number of exits of upstream reach

      integer nInp,nOut     ! indices

      character*4 name  ! temp reading variable for name

      integer nm
      character*6 Tmod  ! temp reading variable for module

      logical found,scompcase
      external scompcase

******** populate nRvarInp, RdsnInp, RnameInp from 'rchres_in'
      fnam = catdir//'iovars/'//ioscen(:lenioscen)//'/rchres_in'
      open(dfile,file=fnam,status='old',iostat=err)
      if (err.ne.0) go to 991

      nRvarInp = 0
      read(dfile,'(a100)') line
      do while (line(:3).ne.'end')
        read(line,'(a6,1x,i3,24x,a4)',iostat=err) Tmod,dsn,name
        if (err.eq.0.and.dsn.ne.0) then
          found = .false.
          do nm = 1,nmod    ! test if module is in use
            if (scompcase(Tmod,modules(nm))) found = .true.
          end do
          if (found) then
            nRvarInp = nRvarInp + 1
            if (nRvarInp.gt.MaxRvar) go to 994
            RdsnInp(nRvarInp) = dsn
            RnameInp(nRvarInp) = name
          end if
        end if
        read(dfile,'(a100)') line
      end do

      close (dfile)

******** populate nRvarOut, RdsnOut, RnameOut from 'rchres_out'
      fnam = catdir//'iovars/'//ioscen(:lenioscen)//'/rchres_out_Xx'   !dsn and name are same for 1x,Nx
      call lencl(fnam,last)
      write(fnam(last-1:last-1),'(i1)') upNexits
      open(dfile,file=fnam,status='old',iostat=err)
      if (err.ne.0) go to 991

      nRvarOut = 0
      read(dfile,'(a100)') line
      do while (line(:3).ne.'end')
        read(line,'(a6,1x,i3,24x,a4)',iostat=err) Tmod,dsn,name
        if (err.eq.0.and.dsn.ne.0) then
          found = .false.
          do nm = 1,nmod
            if (scompcase(Tmod,modules(nm))) found=.true.
          end do
          if (found) then
            nRvarOut = nRvarOut + 1
            if (nRvarOut.gt.MaxRvar) go to 994
            RdsnOut(nRvarOut) = dsn
            RnameOut(nRvarOut) = name
          end if
        end if
        read(dfile,'(a100)') line
      end do

      close (dfile)

********** check for matches both ways
      do nInp = 1,nRvarInp
        found = .false.
        do nOut = 1,nRvarOut
          if (RnameInp(nInp).eq.RnameOut(nOut)) found = .true.
        end do
        if (.not.found) go to 993
      end do

      do nOut = 1,nRvarOut
        found = .false.
        if(RnameOut(nOut).eq.'SSCR') found=.true.
        do nInp = 1,nRvarInp
          if (RnameOut(nOut).eq.RnameInp(nInp)) found = .true.
        end do
        if (.not.found) go to 992
      end do

      return

***************** ERROR SPACE ******************************************
991   report(1) = '  Problem opening file'
      report(2) = fnam
      report(3) = '  error code = '
      write(report(3)(16:18),'(i3)') err
      go to 999

992   report(1) = fnam
      report(2)=' has a variable '//RnameOut(nOut)//' not found in '
      report(3)=' rchres_in in the same directory'
      go to 999

993   report(1) = fnam
      report(2)=' has no variable for '//RnameInp(nInp)//' in the file'
      report(3)=' rchres_in in the same directory'//'Rmasslink.f'
      go to 999

994   report(1) = 'Too many dsns in file:'
      report(2) = fnam
      write(report(3),*)
     .     ' raise maxRvar in stream_wdm.inc above ',maxRvar 
      go to 999

999   call stopreport(report)

      end 
