#!/bin/csh

# e.g., csh sum_eos.csh 20210601_DyHM 9423425 SU4

set SCENARIO     = $argv[1]
set COMID        = $argv[2]
set SUBWATERSHED = $argv[3]

set TEMPDIR = ${SCENARIO}_`uuidgen`
mkdir -p /modeling/gb605/tmp/gbhatt-scratch/$TEMPDIR
cd /modeling/gb605/tmp/gbhatt-scratch/$TEMPDIR
pwd

set RCHWDM = ${SUBWATERSHED}_`printf %09d $COMID`.wdm
echo $RCHWDM 

cp -vip ../../../config/blank_wdm/river.wdm $RCHWDM

echo $SCENARIO $COMID | ../../../code/src/postproc/CalCAST01/_str_sum_eos/sum_eos.exe
if ( -e problem ) then
   echo "ERROR PROBLEM file found"
   cat problem
   pwd
   exit
endif

mv -v $RCHWDM ../../../tmp/wdm/river/${SCENARIO}/eos/


sleep 2

cd ..
rm -r $TEMPDIR

