#!/bin/bash
#SBATCH --job-name=minimization
#SBATCH --output=./logs/array_%A-%a.out
#SBATCH --error=./logs/array_%A-%a.out
#SBATCH --ntasks-per-node=1
#SBATCH -p fcpu
#SBATCH --array=0-990:10


if [[ $SLURM_ARRAY_TASK_ID -eq 0 ]]
then
idx=${SLURM_ARRAY_TASK_ID}
else
idx=${SLURM_ARRAY_TASK_ID}0
fi

if ! [ -d ../snapshots_minimized]; then
    mkdir ../snapshots_minimized
fi

filename=schrodinger_md_${idx}.pdb
cp ../snapshots/${filename} ../snapshots_minimized/schrodinger_md_${idx}_original.pdb

filename=${filename%.*}

$SCHRODINGER/utilities/prepwizard -NOJOBID -HOST 'fcpu' -nobondorders -noccd -nohtreat -noidealizehtf -keepfarwat -nometaltreat -noepik -noprotassign -nopropka -RMSD 0.3 ${filename}_original.pdb ${filename}.pdb
rm schrodinger_md_${idx}_original.pdb