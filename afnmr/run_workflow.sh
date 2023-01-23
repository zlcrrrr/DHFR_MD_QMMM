#!/bin/bash

if ! [ -d "./logs/" ]; then
    mkdir ./logs/
fi

minimization_job_id=$(sbatch --parsable run_minimization.sh) # run the restrained minimization using Schrödinger Suite
afnmr_job_id=$(sbatch --parsable --dependency=afterany:${minimization_job_id} run_afnmr.sh )
