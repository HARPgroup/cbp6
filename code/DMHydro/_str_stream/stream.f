
      SUBROUTINE stream(
     I       C_rscen,
     I       C13_rseg)


      !{ 
       implicit none

       include 'stream.inc'
       !include '../../../lib/inc/locations.inc'
       !include '../../../lib/inc/modules.inc'
       include '../units.inc'

       include '../strtopodata.inc'

       character*13 C13_rseg

       integer I_comid_
       integer I_success_

       integer imod

       integer Nexits

       integer   wdmfil
       parameter (wdmfil=51)

       integer   wdmrch
       parameter (wdmrch=wdmfil+2)


       call lencl(C_rscen,I_rscen)

       call readcontrol_Rioscen(
     I                         C_rscen,I_rscen,
     O                         ioscen)
       call lencl(ioscen,lenioscen)
       print*,ioscen(:lenioscen)

       call readcontrol_time(C_rscen,I_rscen,sdate,edate)  ! get start and stop
       print*,sdate(1),sdate(2),sdate(3)
       print*,edate(1),edate(2),edate(3)

       call readcontrol_modules(C_rscen,I_rscen,
     O                         modules,nmod)


       !TODO MAYBE need to get Nexits
       Nexits = 3
       call Rmasslink(
     I                   ioscen,lenioscen,
     I                   Nexits,modules,nmod,
     O                   nRvarInp,RdsnInp,RnameInp,
     O                   nRvarOut,RdsnOut,RnameOut) 


       wdmfnam = dummyWDMname
       call wdbopnlong(wdmfil+1,wdmfnam,0,err)


!       wdmfnam = outwdmdir//'river/'//C_rscen(:I_rscen)//
!     .              '/stream/'//C13_rseg//'.wdm'
       wdmfnam = C13_rseg//'.wdm'
       call wdbopnlong(wdmrch,wdmfnam,0,err)     ! open river wdm read/write
       if (err .ne. 0) go to 991


       do imod = 1,nmod
          print*,'>',modules(imod),'<'

          if ( modules(imod) .eq. 'HYDR  ' ) 
     .       call CBPM_HYDR(wdmrch,
     I                   nRvarInp,RdsnInp,RnameInp,
     I                   nRvarOut,RdsnOut,RnameOut,
     I                   sdate,edate)

          if ( modules(imod) .eq. 'HTRCH ' )
     .       call CBPM_HTRCH(wdmrch,
     I                   nRvarInp,RdsnInp,RnameInp,
     I                   nRvarOut,RdsnOut,RnameOut,
     I                   sdate,edate)

       end do



       call wdflcl(wdmfil,err)
       if (err.ne.0) go to 996

       return

991   report(1) = 'Problem with opening wdm '//wdmfnam
      report(2) = '  Error =    '
      write(report(2)(11:13),'(i3)') err
      report(3) = 'Segment '//C13_rseg
      go to 999

996   report(1) = ' Could not close wdm'
      report(2) = ' up STREAM for segment '//C13_rseg
      report(3) = wdmfnam
      go to 999

999    call stopreport(report)

      END SUBROUTINE stream











      SUBROUTINE Rmasslink(
     I                     ioscen,lenioscen,
     I                     upNexits,modules,nmod,
     O                     nRvarInp,RdsnInp,RnameInp,
     O                     nRvarOut,RdsnOut,RnameOut)
      implicit none

      include 'stream.inc'

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
      fnam = catdir//'iovars/'//ioscen(:lenioscen)//'/rchres_out_Xx'
!dsn and name are same for 1x,Nx
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

