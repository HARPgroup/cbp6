
      SUBROUTINE sum_eos(
     I       I_comid_,
     I       C13_comid_,
     I       C_rscen,
     I       C_lscen,
     I       I_avgSYEAR, I_avgEYEAR )


      !{ 
       implicit none

       include 'eos.inc'
       !include '../../../lib/inc/locations.inc'
       !include '../../../lib/inc/modules.inc'
       include 'land.inc'
       include '../landuse.inc'
       include '../units.inc'

       integer I_comid_
       character*13 C13_comid_

       integer iRvar,iLU,iLvar
       integer iLseg
       integer It1,It2

       integer sdate(ndate),edate(ndate)

       integer reqSRTy,reqSRTm,reqSRTd  ! requested start time 
       integer reqENDy,reqENDm,reqENDd  ! requested stop time

       character*200 C_filename_
       integer Ifile_,err_
       character*200 line_

       integer Ilc
       character*3 Ctlcs(I_NLCS)
       character*20 Cnull

       integer     Ifeatureid
       character*6 Clseg
       double precision D1acres(I_NLCS)

       double precision DX_acre(I_MAXLSEG,I_NLCS)

       integer   wdmfil
       parameter (wdmfil=51)

       integer   wdmrch
       parameter (wdmrch=wdmfil+2)

       !double precision D_lhdat(ndaymax*24) !hourly land data
       !double precision D_rhdat(ndaymax*24,maxRvar) !hourly river data
       !double precision D_thdat(ndaymax*24)

       real D_lhdat(ndaymax*24) !hourly land data
       double precision D_rhdat(ndaymax*24,maxRvar) !hourly river data
       real D_thdat(ndaymax*24)

       integer I_AET_FACTORS
       parameter ( I_AET_FACTORS = 0 )
       double precision D_AETfacs(I_MAXLSEG,I_NLCS,1984:2014)
       double precision D_AETfac
       integer idate(ndate)
       integer iYR


       !*** Step 00: Get the list of land segments 
       !*** Step 01: For (lseg,lu): get time series of LU factor, L2W, BMP, S2R
       !*** Step 02: Get the list of -> River Modules -> Rvars -> Rdsn -> 
       !***                          -> Lvars -> Ldsns
       !*** Step 03: For (lseg,lu): add time series of LAND WDMs
      

       !*** >> Step 00:
       I_nlseg = 0
       call getlrsegs(I_comid_,C_rscen,I_rscen,C_lsegs,I_nlseg)
       print*,I_nlseg
       do It1 = 1,I_nlseg
          print*,C_lsegs(It1)
       end do



       !*** >> Step 02:
!       modules(1) = 'HYDR'
!       modeles(2) = 'HTRCH'
!       nmod = 2

       call lencl(C_rscen,I_rscen)
       print*,C_rscen
       print*,I_rscen

!      TODO 
!      call readcontrol_tmsce(C_rscen,I_rscen,
!     O                      reqSRTy,reqSRTm,reqSRTd,
!     O                      reqENDy,reqENDm,reqENDd,
!     O                      LandScen)
       reqSRTy = 1984
       reqSRTm = 01 
       reqSRTd = 01
       reqENDy = 2014
       reqENDm = 12
       reqENDd = 31

       sdate(1) = reqSRTy
       sdate(2) = reqSRTm
       sdate(3) = reqSRTd
       sdate(4) = 0
       sdate(5) = 0
       sdate(6) = 0

       edate(1) = reqENDy
       edate(2) = reqENDm
       edate(3) = reqENDd
       edate(4) = 24
       edate(5) = 0
       edate(6) = 0

       call readcontrol_modules(C_rscen,I_rscen,
     O                         modules,nmod)
       print*,'# modules = ',nmod
       print*,modules(1)
       print*,modules(2)
       print*,modules(3)

       call readcontrol_Rioscen(
     I                         C_rscen,I_rscen,
     O                         ioscen)
       call lencl(ioscen,lenioscen)

       print*,ioscen(:lenioscen)
       
       call masslink(
     I              ioscen,lenioscen,modules,nmod,
     O              nRvar,Rdsn,Rname,RvarBMP,
     O              nLvar,Ldsn,Lname,Lfactor)

       print*,'nRvar = ', nRvar
       !print*,nLvar
       do It1 = 1,nRvar
          print*,Rname(It1)
          print*,'...',(nLvar(It1,It2),It2=1,nlu)
       end do


       !call loadlctable(C3_lcs,I1_lcs)
       call loadlcP6lu(C3_lcs,I1_lcs,C3_lus)


       do It1 = 1,I_NLCS
          print*,C3_lcs(It1),I1_lcs(It1),C3_lus(It1)
       end do




       wdmfnam = dummyWDMname
       call wdbopnlong(wdmfil+1,wdmfnam,0,err)


       !*** Step : Open and DO read row by row land cover
       C_filename_ = catdir//'geo/'//'CalCAST01/'//
     .             '20191009_P6_LandSeg_NHDv2_LandCover.csv'
       print*,C_filename_
       open(Ifile_,file=C_filename_,status='old',iostat=err_)
       if (err_ .ne. 0) goto 902
       read(Ifile_,*) Cnull,Cnull,(Ctlcs(Ilc),Ilc=1,I_NLCS)
       !print*,'... ',(Ctlcs(Ilc),Ilc=1,I_NLCS)
       do ilc = 1,I_NLCS
          if ( Ctlcs(Ilc) .ne. C3_lcs(Ilc) ) then
             print*,'... ERROR: landcover header does not match @ ',Ilc
             print*,'... expected ',C3_lcs(Ilc)
             print*,'... file has ',Ctlcs(Ilc)
             return
          end if
       end do

       do iLU = 1,nlu
          do iLseg=1,I_nlseg
             DX_acre(iLseg,iLU) = 0.0
          end do
       end do
       !TODO: this will eventually need an interpolation fn and time
       !comonent to the DX_acre array
       do
          read(Ifile_,*,end=0201) Ifeatureid,Clseg,
     .        (D1acres(Ilc),Ilc=1,I_NLCS) !area in square meters
          if ( Ifeatureid .eq. I_comid_ ) then
             do iLseg=1,I_nlseg
                if(Clseg .eq. C_lsegs(iLseg)) then
                   do iLU = 1,nlu
                      DX_acre(iLseg,iLU) = D1acres(iLU) / D_ACRE2SQM
                   end do
                end if
             end do
          end if
       end do
0201   close(Ifile_)


       do iRvar=1,nRvar
          print*,Rname(iRvar)
          do It1 = 1,ndaymax*24
             D_rhdat(It1,iRvar) = 0.0
             !D_rhdat(It1) = 0.0
          end do
       end do

       do iLseg=1,I_nlseg
        do iLU = 1,nlu
         do iYR = 1984,2014
             D_AETfacs(iLseg,iLU,iYR) = 1.0
         end do
        end do
       end do

       if ( I_AET_FACTORS .eq. 1 ) then
          call getAETfactors(I_comid_,C_lsegs,I_nlseg,C3_lcs,I1_lcs,
     .         D_AETfacs)
       end if

       do iLU = 1,nlu
          print*,'... ...',luname(iLU),
     .        ' . ',C3_lcs(iLU),' . ',C3_lus(iLU)
          if ( C3_lcs(iLU) .eq. 'WAT' ) cycle
          do iLseg=1,I_nlseg
             if ( C_lsegs(iLseg) .eq. 'Z00000' ) cycle 
             ! TODO MAYBE add a table for looking up land segments outside the
             ! watershed ??
             if ( C_lsegs(iLseg) .eq. 'N54083' .or. 
     .            C_lsegs(iLseg) .eq. 'N54075' .or. 
     .            C_lsegs(iLseg) .eq. 'N54025' .or.
     .            C_lsegs(iLseg) .eq. 'N51037' .or.
     .            C_lsegs(iLseg) .eq. 'N51111' ) cycle
             wdmfnam = outwdmdir//'land/'//C3_lus(iLU)//
     .             '/CFBASE30Y20180615/'//
     .             C3_lus(iLU)//C_lsegs(iLseg)//'.wdm'
             print*,wdmfnam
             call wdbopnlong(wdmfil,wdmfnam,0,err)
             if (err .ne. 0) go to 901

             do iRvar=1,nRvar 

                do iLvar=1,nLvar(iRvar,iLU) 

                   print*,'... ... ...',Rname(iRvar),' ',
     .               Lname(iRvar,iLU,iLvar),Ldsn(iRvar,iLU,iLvar)

                   call gethourdsn(wdmfil,sdate,edate,
     .                 Ldsn(iRvar,iLU,iLvar),nvals,D_lhdat)

                   idate(1) = sdate(1)
                   idate(2) = sdate(2)
                   idate(3) = sdate(3)
                   idate(4) = sdate(4)
                   idate(5) = sdate(5)
                   idate(6) = sdate(6)
                   iYR = -9

                   do It1=1,nvals
!                   print*,C3_lus(iLU),It1,D_lhdat(It1),
!     .                    DX_acre(iLseg,iLU),
!     .                    Lfactor(iRvar,iLU,iLvar)

                      D_AETfac = 1
                      if ( I_AET_FACTORS .eq. 1 .and. 
     .                     Rname(iRvar) .eq. 'WATR' ) then
                         D_AETfac = D_AETfacs(iLseg,iLU,idate(1)) 
                         call onehour(idate(1),idate(2),idate(3),
     .                            idate(4))

                         if (iYR .ne. idate(1)) then 
                            iYR = idate(1)
                            print*,'->> ',iYR,D_AETfac
                         end if

                      end if

                      D_rhdat(It1,iRvar) 
     .                  = D_rhdat(It1,iRvar) 
     .                    + D_lhdat(It1) * DX_acre(iLseg,iLU)
     .                      * Lfactor(iRvar,iLU,iLvar)
     .                      * D_AETfac
                   end do

                end do
             end do

             call wdflcl(wdmfil,err)
          end do
       end do

       wdmfnam = C13_comid_//'.wdm'
       call wdbopnlong(wdmrch,wdmfnam,0,err)
       if (err .ne. 0) go to 901

       do iRvar=1,nRvar
          print*,'... writing edge of stream WDM DSN ',Rdsn(iRvar)
          do It1=1,nvals
             D_thdat(It1) = D_rhdat(It1,iRvar)
             !??print*,It1,D_thdat(It1)
          end do
          call puthourdsn(wdmrch,sdate,edate,Rdsn(iRvar),nvals,D_thdat)
       end do

       call wdflcl(wdmrch,err)




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
       

999    call stopreport(report)

      END






      SUBROUTINE F_C9_comid(
     I       I_comid_,
     O       C9_comid_ )
      !{ 
       implicit none

       include '../strtopodata.inc'

       integer      I_comid_
       character*9 C9_comid_

       integer comidx2
       external comidx2

       write(C9_comid_,'(I0.9)')
     .     I_comid_

       return
      !}
      END SUBROUTINE F_C9_comid




      SUBROUTINE F_C13_comid(
     I       I_comid_,
     I       C3_basin,
     O       C13_comid_ )
      !{ 
       implicit none

       include '../strtopodata.inc'

       integer      I_comid_
       character*13 C13_comid_

       integer comidx2
       external comidx2

       write(C13_comid_,'(A3,A,I0.9)')
     .     C3_basin(comidx2(I_comid_)),'_',I_comid_


       return

      !}
      END SUBROUTINE F_C13_comid





      SUBROUTINE getlrsegs(
     I       I_comid_,
     I       C_rscen,
     I       I_rscen,
     O       C_lsegs_,
     O       I_nlseg_ )
      !{ 
       implicit none

       include '../../../lib/inc/locations.inc'
       include 'eos.inc'

       integer I_comid_

       character*6 C_lsegs_(I_MAXLSEG)
       integer     I_nlseg_

       character*200 C_filename_
       integer Ifile_,err_
       character*200 line_
       integer Ifound_

       integer I_featureid_
       character*6 C6_lseg_
       integer I_found_


       !*** TODO 
       !*** get geoscen for the C_rscen_(:I_rscen_)
       geoscen = 'CalCAST01'
       call lencl(geoscen,lengeoscen)

       C_filename_ = catdir//'geo/'//geoscen(:lengeoscen)//
     .       '/featureid_lseg.csv'

       call findopen(Ifile_)
       open (Ifile_,file=C_filename_,status='old',iostat=err_)
       if (err_.ne.0) go to 901

       I_nlseg_ = 0
       I_found_ = 0
       
       read(Ifile_,*) line_ ! header line
       do
          read(Ifile_,'(A200)',end=0102) line_
          read(line_,*) I_featureid_,C6_lseg_
          if ( I_comid_ .eq. I_featureid_ ) then
             Ifound_ = 1
             I_nlseg_ = I_nlseg_ + 1
             C_lsegs_(I_nlseg_) = C6_lseg_
          end if
       end do

0102   close(Ifile_)

       if ( Ifound_ .eq. 0 ) go to 902

       return


901    print*,'ERROR unable to open file'
       print*,':',C_filename_
       stop

902    print*,'ERROR COMID not found'
       print*,'comid:',I_comid_
       print*,'file:',C_filename_
       stop


      END SUBROUTINE getlrsegs






      SUBROUTINE masslink(ioscen,lenioscen,modules,nmod,
     O                    nRvar,Rdsn,Rname,RvarBMP,
     O                    nLvar,Ldsn,Lname,Lfactor)


      implicit none

      include 'land.inc'

      integer i,l,n,nR,nm     ! indices

      integer dsnR,dsnL                   ! temp variables for reading
      character*1 cl                      ! temp character variable
      character*4 name,nameR,nameL            !     catalog files
      character*3 bmp

      character*6 Tmod                  ! temp variable for modules
      character*300 lin3                  ! reading variable
      real factor

      logical found,scompare,scompcase,comment
      external scompare,scompcase,comment

      integer lenf                               ! length of land use field
      parameter (lenf=nlu*4)                     !   in file land_to_water
      character lus(lenf)                        ! change to lenf
                                                 ! also change in format statement
******** populate nRvar, Rdsn, Rname, RvarBMP from 'rchres_in'
      fnam = catdir//'iovars/'//ioscen(:lenioscen)//'/rchres_in'
      open(dfile,file=fnam,status='old',iostat=err)
      if (err.ne.0) go to 991

      nRvar = 0
      read(dfile,'(a100)') line
      do while (line(:3).ne.'end')
        read(line,'(a6,1x,i3,24x,a4,3x,a3)',iostat=err)Tmod,dsn,name,bmp
        if (err.eq.0.and.dsn.ne.0) then
          found = .false.
          do nm = 1,nmod
            if (scompcase(Tmod,modules(nm))) found=.true.
          end do
          if (found) then
            nRvar = nRvar + 1
            Rdsn(nRvar) = dsn
            Rname(nRvar) = name
            RvarBMP(nRvar) = bmp
          end if
        end if
        read(dfile,'(a100)') line
      end do

      close (dfile)
******* populate nLvar, Ldsn, Lname, Lfactor from 'land_to_river'
      fnam = catdir//'iovars/'//ioscen(:lenioscen)//'/land_to_river'
      open(dfile,file=fnam,status='old',iostat=err)
      if (err.ne.0) go to 991

      do i = 1,maxRvar     ! initialize number of land variables
        do l = 1,nlu
          nLvar(i,l) = 0
        end do
      end do

      read(dfile,'(a300)') lin3
      if (lin3(296:300).ne.'      ') go to 992

      do while (lin3(:3).ne.'end')
        read(lin3,1234,iostat=err)Tmod,dsnR,nameR,dsnL,nameL,factor
        if (lin3(35:44).eq.'          ') factor = 1.0
        if (err.eq.0.and.dsnR.ne.0.and..not.comment(lin3)) then
          found = .false.
          do nm = 1,nmod       ! test if module in use
            if (scompare(Tmod,modules(nm))) found = .true.
          end do
          if (found) then
            do nR = 1,nRvar
              if (Rdsn(nR).eq.dsnR) then
                do l = 1,nlu
                  i = 47         ! first column with land use
                  do while(i.lt.298)
                    if (luname(l).eq.lin3(i:i+2)) then
                      nLvar(nR,l) = nLvar(nR,l) + 1
                      Ldsn(nR,l,nLvar(nR,l)) = dsnL
                      Lname(nR,l,nLvar(nR,l)) = nameL
                      Lfactor(nR,l,nLvar(nR,l)) = factor
                    end if
                    i = i+4
                  end do
                end do
              end if
            end do
          end if
        end if
        read(dfile,'(a300)') lin3
      end do

      close (dfile)

      return

1234  format(a6,3x,i4,2x,a4,3x,i4,2x,a4,2x,f10.0)

***************** ERROR SPACE ******************************************
991   report(1) = '  Problem opening file'
      report(2) = fnam
      report(3) = '  error code = '
      write(report(3)(16:18),'(i3)') err
      go to 999

992   report(1)='Characters near the far right of file: land_to_river'
      report(2)=' indicate that recoding may be necessary to allow for'
      report(3)=' more land uses ./code/src/etm/transfer_wdm/masslink.f'
      go to 999

999   call stopreport(report)
      stop

      END SUBROUTINE masslink





      SUBROUTINE getAETfactors(I_comid_,C_lsegs_,I_nlseg_,C3_lcs,I1_lcs,
     .         D_AETfacs)


       implicit none

       include '../../../lib/inc/standard.inc'
       include '../../../lib/inc/locations.inc'
       include 'eos.inc'
       include '../landuse.inc'


       integer I_comid_

       character*6 C_lsegs_(I_MAXLSEG)
       integer     I_nlseg_

       character*200 C_filename_
       integer Ifile_,err_
       character*200 line_
       character*4000 longline_
       integer Ifound_

       integer I_featureid_
       character*6 C6_lseg_
       integer I_found_

       integer ilu, iyr, ix
       character*10 ihdr1,ihdr2,ihdr(360)
       character*10 istr


       double precision D_AETfacs(I_MAXLSEG,I_NLCS,1984:2014)


       !*** TODO 
       !*** get geoscen for the C_rscen_(:I_rscen_)
       ioscen = 'CalCAST01'
       call lencl(ioscen,lenioscen)

       C_filename_ = catdir//'iovars/'//ioscen(:lenioscen)//
     .       '/AETfactors.csv'

       call findopen(Ifile_)
       open (Ifile_,file=C_filename_,status='old',iostat=err_)
       if (err_.ne.0) go to 901


       !read(Ifile_,*) longline_ ! header line
       !print*,longline_
       read(Ifile_,*) ihdr1,ihdr2,(ihdr(ix),ix=1,360)
       do ilu = 1,I_NLCS
          do iyr = 1,30
             print*,ihdr((ilu-1)*30+iyr)
          end do
       end do
!       do
!          read(Ifile_,'(A200)',end=0102) line_
!          read(line_,*) I_featureid_,C6_lseg_
!          if ( I_comid_ .eq. I_featureid_ ) then
!             Ifound_ = 1
!             I_nlseg_ = I_nlseg_ + 1
!             C_lsegs_(I_nlseg_) = C6_lseg_
!          end if
!       end do

       stop

901    report(1) = 'ERROR unable to open file'
       report(2) = ':'//C_filename_
       goto 999

902    report(1) = 'ERROR COMID not found'
       !report(2) = 'comid:'//I_comid_
       write(report(2)(8:18),'(i10)') I_comid_
       report(3) = 'file:'//C_filename_
       goto 999

999   call stopreport(report)

      stop
      END SUBROUTINE