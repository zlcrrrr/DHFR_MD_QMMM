#!/bin/bash
#SBATCH --job-name=afnmr_mini
#SBATCH --output=./logs/array_%A-%a.out
#SBATCH --error=./logs/array_%A-%a.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH -p fcpu
#SBATCH --array=0-990:10

if [[ $SLURM_ARRAY_TASK_ID -eq 0 ]]
then
idx=${SLURM_ARRAY_TASK_ID}
else
idx=${SLURM_ARRAY_TASK_ID}0
fi

source ~/anaconda3/etc/profile.d/conda.sh
conda activate AmberTools22

mkdir $idx
cd ./$idx
filename=schrodinger_md_${idx}.pdb
filename=${filename%.*}

cp ../../snapshots_minimized/${filename}.pdb ./

# fix residue naming for Amber
sed -ie 's/T3P/WAT/g' ${filename}.pdb
sed -i '/EPW/d' ${filename}.pdb

# cleanup for Amber
pdb4amber -i ${filename}.pdb -o ${filename}_.pdb

# run AFNMR
LIB="../../lib"
$AFNMRHOME/bin/afnmr -nomin -orca -offlib $LIB/SO4.lib -offlib $LIB/TMP.lib -frcmod $LIB/SO4.frcmod -frcmod $LIB/TMP.frcmod ${filename}_

