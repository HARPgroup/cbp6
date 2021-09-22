#!/bin/csh

set SCENARIO = $argv[1]

# sbatch --mem=54000 --mem-per-cpu=1500 --cpus-per-task=1 --job-name=DyHM --dependency=singleton --nodes=4 --mincpus=36 --ntasks=144 --ntasks-per-node=36 sum_eos_steps.csh 20210601_DyHM 
#

echo "LOG SUM_EOS :: Started  ' `date`"
echo ""

set PROJECT_HOME       = /modeling/gb605
srun --ntasks-per-node=1 --ntasks=4 --exclusive aws_wsm_script_init.sh $PROJECT_HOME &


set ICOUNT = 0
foreach line ( "`cat ../../../../../config/catalog/geo/CalCAST01/ROUTING_ATTRIBUTES.csv`" )

   if ( $ICOUNT >  0 ) then
      set data = `echo $line:q | sed 's/,/ /g'`
      echo $data[1] $data[5]
      srun --nodes=1 --ntasks=1 --exclusive sum_eos.csh $SCENARIO $data[1] $data[5] &
   endif

   @ ICOUNT = $ICOUNT + 1

end
wait

echo ""
echo "LOG SUM_EOS :: Finished  ' `date`"
