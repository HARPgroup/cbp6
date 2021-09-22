#!/bin/csh

set SCENARIO = $argv[1]

# sbatch --mem=54000 --mem-per-cpu=1500 --cpus-per-task=1 --job-name=DyHM --dependency=singleton --nodes=4 --mincpus=36 --ntasks=144 --ntasks-per-node=36 sum_upstream_steps.csh 20210601_DyHM 
#


set PROJECT_HOME       = /modeling/gb605
srun --ntasks-per-node=1 --ntasks=4 --exclusive aws_wsm_script_init.sh $PROJECT_HOME &

set SSEQUENCE = 1
set ESEQUENCE = 710

set ISEQUENCE = $SSEQUENCE

while ( $ISEQUENCE <= $ESEQUENCE )

   foreach line ( "`grep ,${ISEQUENCE},X ../../../../../config/catalog/geo/CalCAST01/ROUTING_ATTRIBUTES_seq.csv`" )
      set data = `echo $line:q | sed 's/,/ /g'`
      echo $data[1] $data[2]
      srun --nodes=1 --ntasks=1 --exclusive sum_upstream.csh $SCENARIO $data[1] &
   end

   wait
   @ ISEQUENCE = $ISEQUENCE + 1

end

