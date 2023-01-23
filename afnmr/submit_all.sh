#!/bin/bash
# this script is to submit jobs one by one, after the previous one is complete
# Get first job id

# jid_1=$(sbatch ./71/submit_71.sh | cut -d ' ' -f4) # main script
# sbatch --dependency=afterany:${jid_1} ./71/cleanup_71.sh # clean up script

# Remainder jobs
for k in {600..990..10}
do
    if [[ $k -eq 0 ]]
    then
        idx=${k}
    else
        idx=${k}0
    fi
	echo $idx
    jid_1=$(sbatch ./${idx}/submit_${idx}.sh | cut -d ' ' -f4)
    #sbatch --dependency=afterany:${jid_1} ./${idx}/cleanup_${idx}.sh # clean up script
done
