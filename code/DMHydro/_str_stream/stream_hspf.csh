#!/bin/csh

# e.g., csh stream.csh 20210601_DyHM EM2_009405936
# for more see test2

set SCENARIO      = $argv[1]
set GROUPSEG      = $argv[2]

source ../../../../../run/fragments/set_tree

set TEMPDIR = ${SCENARIO}_`uuidgen`
mkdir -p /modeling/gb605/tmp/gbhatt-scratch/$TEMPDIR
cd /modeling/gb605/tmp/gbhatt-scratch/$TEMPDIR


# STEP 1
set RCHWDM = ${GROUPSEG}.wdm
cp -vip ../../../config/blank_wdm/river.wdm $RCHWDM
echo $SCENARIO $GROUPSEG | ../../../code/src/postproc/CalCAST01/_str_sum_upstream/sum_upstream.exe
#mv -v $RCHWDM ../../../tmp/wdm/river/${SCENARIO}/stream/


if ( -e problem ) then
   echo "ERROR PROBLEM file found in SUM UPSTREAM $SCENARIO $GROUPSEG"
   cat problem
   pwd
   exit
endif




# STEP 2
#echo $SCENARIO $GROUPSEG | ../../../code/src/postproc/CalCAST01/_str_stream/stream.exe
set seg = $GROUPSEG
set scenario = $SCENARIO
source $tree/run_bhatt/fragments/set_quiet_hspf


   # STEP 2(A)
   echo making River UCI for segment $seg   River scenario $scenario
   echo $seg, $scenario | $tree/code/bin/rug.exe
   if ( -e problem ) then
      echo "ERROR PROBLEM file found in RUG $SCENARIO $GROUPSEG"
      cat problem
      pwd
      exit
   endif


   # STEP 2(B)
   #TODO SPECIAL ACTION

   # STEP 2(C)
   #cp -v $tree/config/blank_wdm/blank_ps_sep_rib_rpa_div_ams.wdm ps_sep_div_ams_$scenario'_'$seg'.wdm'
   cp -v $tree/config/blank_wdm/blank_ps_sep_rib_rpa_div_ams.wdm DL_$scenario'_'$seg'.wdm'
   echo $scenario, $seg | $tree/code/bin/combine_ps_sep_rib_rpa_div_ams_from_landsegs.exe
   if ( -e problem ) then
      echo "ERROR PROBLEM file found in COMBINE PS AND OTHER DIRECT LOADS $SCENARIO $GROUPSEG"
      cat problem
      pwd
      exit
   endif


   # STEP 2(C)
   set inp = $seg'.uci'
   mkdir plt
   cp $tree/tmp/uci/river/$scenario/$seg'.uci' ./
   if (!(-e $inp)) then
      echo 'HSPF UCI for segment ' $seg ' named'
      echo $inp 'does not exist'
      exit
   endif
   echo $inp | $hspf

   tail -1 $seg'.ech' > EOJtest$$
   diff $tree/run_bhatt/fragments/EOJ EOJtest$$ > diffeoj
   rm EOJtest$$
   if (!(-z diffeoj)) then
      if (-e problem) then
         rm problem
      endif
      echo 'river segment: ' $seg ' did not run'  >problem
      echo '  input file ' $inp >>problem
      #set fnam = $tree/tmp/scratch/temp$$/$seg'.ech '
      #set fnam = $tree/tmp/${user}-scratch/$tempdir/$seg'.ech '
      set fnam = $tree/tmp/${user}-scratch/$TEMPDIR/$seg'.ech '
      echo '  check the file ' $fnam >>problem
      cat problem
      exit
   endif


   # STEP 2(D)
   #TODO reservoir_type_II.exe
   #TODO scrorg.exe


   mv -v $RCHWDM ../../../tmp/wdm/river/${SCENARIO}/stream/



if ( -e problem ) then
   echo "ERROR PROBLEM file found $SCENARIO $GROUPSEG"
   cat problem
   pwd
   exit
endif

#sleep 2

cd ..
rm -r $TEMPDIR

