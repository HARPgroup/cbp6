#!/bin/csh

set SCENARIO = $argv[1]

#sbatch --mem=54000 --mem-per-cpu=1500 --cpus-per-task=1 --job-name=${SCENARIO} --dependency=singleton --nodes=4 --mincpus=36 --ntasks=144 --ntasks-per-node=36 sum_eos_steps.csh ${SCENARIO}
sbatch --mem=54000 --cpus-per-task=1 --job-name=${SCENARIO} --dependency=singleton --nodes=4 --mincpus=36 --ntasks=144 --ntasks-per-node=36 sum_eos_steps.csh ${SCENARIO}
#sbatch --mem=54000 --threads-per-core=2 --job-name=${SCENARIO} --dependency=singleton --nodes=4 --mincpus=36 --ntasks=288 --ntasks-per-node=72 sum_eos_steps.csh ${SCENARIO}

