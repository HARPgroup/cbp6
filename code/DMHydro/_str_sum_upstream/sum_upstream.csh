#!/bin/csh

# e.g., csh sum_upstream.csh 20210601_DyHM 9423425 SU4

set SCENARIO      = $argv[1]
set GROUPSEG      = $argv[2]

set TEMPDIR = ${SCENARIO}_`uuidgen`
mkdir -p /modeling/gb605/tmp/gbhatt-scratch/$TEMPDIR
cd /modeling/gb605/tmp/gbhatt-scratch/$TEMPDIR

#set RCHWDM = ${SUBWATERSHEED}_`printf %09d $COMID`.wdm
set RCHWDM = ${GROUPSEG}.wdm
#echo $RCHWDM 
cp -vip ../../../config/blank_wdm/river.wdm $RCHWDM

echo $SCENARIO $GROUPSEG | ../../../code/src/postproc/CalCAST01/_str_sum_upstream/sum_upstream.exe

mv -v $RCHWDM ../../../tmp/wdm/river/${SCENARIO}/stream/


if ( -e problem ) then
   echo "ERROR PROBLEM file found"
   cat problem
   pwd
   exit
endif

#sleep 2

cd ..
rm -r $TEMPDIR

