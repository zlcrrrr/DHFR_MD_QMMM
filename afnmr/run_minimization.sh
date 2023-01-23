#!/bin/bash
#SBATCH --job-name=minimization
#SBATCH --output=./logs/array_%A-%a.out
#SBATCH --error=./logs/array_%A-%a.out
#SBATCH --ntasks-per-node=1
#SBATCH -p fcpu
#SBATCH --array=0-990:10

minimization='Y'

if [[ $SLURM_ARRAY_TASK_ID -eq 0 ]]
then
idx=${SLURM_ARRAY_TASK_ID}
else
idx=${SLURM_ARRAY_TASK_ID}0
fi

mkdir $idx
cd ./$idx
filename=schrodinger_md_${idx}.pdb
cp ../../../schrodinger_md_10A_Na_300K_1000ns/snapshots/${filename} ./schrodinger_md_${idx}_original.pdb

filename=${filename%.*}

if [[ $minimization -eq 'Y' ]]
then
    $SCHRODINGER/utilities/prepwizard -NOJOBID -HOST 'fcpu' -nobondorders -noccd -nohtreat -noidealizehtf -keepfarwat -nometaltreat -noepik -noprotassign -nopropka ${filename}_original.pdb ${filename}.pdb
fi
