#!/bin/bash
for i in {0..10..10}
do
if [[ $i -eq 0 ]]
then
idx=${i}
else
idx=${i}0
fi
echo "#!/bin/bash
#SBATCH --job-name=qm
#SBATCH --output=./logs/array_%A-%a.out
#SBATCH --error=./logs/array_%A-%a.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=03:00:00
#SBATCH -p fcpu
#SBATCH --array=61

source ~/.bashrc
cd ./${idx}
working_dir=\$(pwd)

filename=schrodinger_md_${idx}.pdb
filename=\${filename%.*}
appendix=0

if [[ \$SLURM_ARRAY_TASK_ID -lt 10 ]]
then
appendix=\"00\${SLURM_ARRAY_TASK_ID}\"
elif [[ \$SLURM_ARRAY_TASK_ID -lt 100 ]]
then
appendix=\"0\${SLURM_ARRAY_TASK_ID}\"
elif [[ \$SLURM_ARRAY_TASK_ID -ge 100 ]]
then
appendix=\"\${SLURM_ARRAY_TASK_ID}\"
fi

inputfile=\"\${filename}_\${appendix}.orcainp\"
outputfile=\"\${filename}_\${appendix}.out\"

#if [ -f \$outputfile ]; then
#    exit 1
#fi

module load orca

# run job in the tmp dir
export scratchlocation=/local
if [ ! -d \$scratchlocation/\$USER ]
then
  mkdir -p \$scratchlocation/\$USER
fi
tdir=\$(mktemp -d \$scratchlocation/\$USER/orcajob_\${SLURM_JOB_ID}_\${SLURM_ARRAY_TASK_ID}-XXXXX)

cp  \$inputfile \$tdir/
cp  \${filename}_\${appendix}.pos \$tdir/
cp  \${filename}_\${appendix}.pqr \$tdir/

cd \$tdir

echo \$tdir \$inputfile \$outputfile
orca \$inputfile > \$outputfile

# cp output to working dir
cd \$working_dir
cp \$tdir/* ./
#cp \$tdir/\$outputfile ./
rm -r \$tdir/

" > ./${idx}/submit_${idx}.sh

done

