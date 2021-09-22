#!/bin/csh

set INTERVAL = $argv[1]

while ( 1 ) 
   echo "`date` - `squeue -s | wc -l`"
   sleep $INTERVAL
end

