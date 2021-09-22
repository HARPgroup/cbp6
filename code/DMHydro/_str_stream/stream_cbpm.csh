#!/bin/csh

# e.g., csh stream.csh 20210601_DyHM EM2_009405936
# for more see test2

set SCENARIO      = $argv[1]
set GROUPSEG      = $argv[2]
set SLEEP_SECONDS      = $argv[3]

set TEMPDIR = ${SCENARIO}_`uuidgen`
mkdir -p /modeling/gb605/tmp/gbhatt-scratch/$TEMPDIR
cd /modeling/gb605/tmp/gbhatt-scratch/$TEMPDIR


set RCHWDM = ${GROUPSEG}.wdm
cp -vip ../../../config/blank_wdm/river.wdm $RCHWDM
echo $SCENARIO $GROUPSEG | ../../../code/src/postproc/CalCAST01/_str_sum_upstream/sum_upstream.exe
#mv -v $RCHWDM ../../../tmp/wdm/river/${SCENARIO}/stream/

if ( -e problem ) then
   echo "ERROR PROBLEM file found CBPM UPSTREAM $SCENARIO $GROUPSEG"
   cat problem
   pwd
   exit
endif


echo $SCENARIO $GROUPSEG | ../../../code/src/postproc/CalCAST01/_str_stream/stream.exe
mv -v $RCHWDM ../../../tmp/wdm/river/${SCENARIO}/stream/

if ( -e problem ) then
   echo "ERROR PROBLEM file found CBPM STREAM $SCENARIO $GROUPSEG"
   cat problem
   pwd
   exit
endif

#sleep 3
sleep $SLEEP_SECONDS

cd ..
rm -r $TEMPDIR

