#!/bin/sh
#SBATCH --job-name=out_changed_1benchmark_sphere          #Job name
#SBATCH --ntasks=64                 #Number of tasks/How many parallel jobs to run -> equivalent to -n in peacock
#SBATCH --nodes=2                  #xueyang added 
#SBATCH --cpus-per-task=1          #xueyang added
#SBATCH --mem-per-cpu=2gb           #Memory (120 gig/node) -> use just enough so your memory usage is 70-80%
#SBATCH --time=3-00:00:00             #Walltime hh:mm:ss
#SBATCH --output=output.out #Output and error log name
#SBATCH --mail-type=ALL             #When to email user: NONE,BEGIN,END,FAIL,REQUEUE,ALL
#SBATCH --mail-user=wuxueyang@ufl.edu       #Email address to send mail to
#SBATCH --qos=michael.tonks                #Allocation group name, add -b for burst job
##SBATCH --array=1-200%10           #Used to submit multiple jobs with one submit

srun --mpi=pmi2 /home/wuxueyang/projects/moose/modules/phase_field/phase_field-opt -i /ufrc/michael.tonks/wuxueyang/1benchmark_sphere/spherebench.i


