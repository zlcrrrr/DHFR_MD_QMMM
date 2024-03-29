# DHFR\_MD\_QMMM

This repo contains the code and files for the paper titled *[Predicted and Experimental NMR Chemical Shifts at Variable Temperatures: The Effect of Protein Conformational Dynamics](https://doi.org/10.1021/acs.jpclett.3c02589) (J. Phys. Chem. Lett. 2024, 15, 8, 2270–2278)*. 

![Fig](./figures/fig.png)

## Data availability
The molecular dynamics trajectory, minimized MD snapshots and predicted chemical shifts we used in the paper can be downloaded at [here](https://osf.io/wqyb4/).

## Reproduce MD/QM/MM

### Prerequisite
* [Anaconda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/)
* [Schrödinger Suite](https://www.schrodinger.com/downloads/releases) (Not required for running the minimal example below, but required for reproducing our MD trajectory and minimized snapshots)
* [AFNMR](https://github.com/dacase/afnmr)
* [AmberTools](https://ambermd.org/AmberTools.php)
* [ORCA](https://www.orcasoftware.de/tutorials_orca/)

### Setup environment
```
git clone git@github.com:zlcrrrr/DHFR_MD_QMMM.git
conda env create -n AmberTools22 --file AmberTools22.yml
```

### MD simulation
The DHFR initial structure (DHFR\_init.pdb) and the prepared structure for MD (DHFR\_md\_input.pdb) are in ./initial_structure. The details of the initial structure preparation, and MD simulation setup are in the paper. We provide the 1μs MD trajectory we used in the paper [here](https://osf.io/wqyb4/) (~6.75 GB). For reproducing the trajectory, you need to install [Schrödinger Suite](https://www.schrodinger.com/downloads/releases).

### QM/MM calculation
Note: we performed all the AFNMR and QMMM calculations described in the paper on a HPC cluster using Slurm. The scripts provided in the respository are just examples. You may need to tweak our scripts to fit your computing environment.

Download the [MD trajectory and snapshots](https://osf.io/wqyb4/). Unzip and move the contents of the downloaded folders to the repository, and extract MD snapshots from the trajectory to a folder named snapshots
```
cd sh
chmod +x ./*.sh
./extract_shifts.sh # this requires Schrodinger Suite. But you can use free softwares like VMD to do the same job as well.
```

Then submit minimization and AFNMR jobs to Slurm. 
```
cd sh
chmod +x ./*.sh
./run_workflow.sh # this scripts requires Schrodinger Suite
```

Or you can use the minimized snapshots we provided and skip the steps above
```
cd sh
chmod +x ./*.sh
sbatch run_afnmr.sh
```

After the minimization and AFNMR jobs are done, run
```
./prepare_scripts.sh # prepare QM/MM calculation scripts
```
and 
```
./submit_all.sh # submit QM/MM calculation jobs to Slurm.
```

Finally, extract the calculated chemical shifts. Results are in a folder ./sh/results/
```
./extract_shifts.sh
```

### Minimal example

We provide an example to run a AF-QM/MM calculation using AFNMR and ORCA for the first residue (MET1) in the first snapshot of the MD trajectory (schrodinger_md_0.pdb).

Install [Anaconda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/), [AFNMR](https://github.com/dacase/afnmr), and [ORCA](https://www.orcasoftware.de/tutorials_orca/).

Clone the repository and setup the conda environment

```
git clone git@github.com:zlcrrrr/DHFR_MD_QMMM.git
conda env create -n AmberTools22 --file AmberTools22.yml
```
Then run AFNMR and QM/MM calculations. 
```
cd ./DHFR_MD_QMMM/example
chmod +x ./run_example.sh
./run_example.sh
```
The calculated chemical shifts are in results.txt (as shown below). Columns are residue index, atom name, residue name, chemical shift, delta, eta, xx, yy, zz, respectively.

```
1	N	MET	  26.962	  13.053	   0.282	 200.985	 218.722	 222.408
1	H1	MET	   4.906	 -14.839	   0.075	  20.321	  21.428	  43.133
1	H2	MET	   5.160	 -13.178	   0.141	  20.522	  22.378	  41.218
1	H3	MET	   4.913	 -11.649	   0.044	  22.208	  22.717	  39.936
1	CA	MET	  57.680	  19.816	   0.690	 112.304	 135.191	 148.864
1	HA	MET	   3.954	   2.103	   0.943	  27.143	  29.305	  31.289
1	CB	MET	  31.892	  25.632	   0.181	 132.276	 168.403	 173.044
1	HB2	MET	   2.319	   6.280	   0.359	  24.601	  32.894	  35.147
1	HB3	MET	   2.331	  -6.124	   0.734	  25.559	  30.056	  36.993
1	CG	MET	  27.314	 -19.298	   0.903	 144.127	 161.548	 181.784
1	HG2	MET	   2.205	  -6.771	   0.866	  24.680	  30.541	  37.766
1	HG3	MET	   2.289	   6.861	   0.925	  24.050	  31.168	  37.514
1	CE	MET	  20.212	 -25.434	   0.515	 150.322	 163.421	 195.022
1	HE1	MET	   1.603	 -10.060	   0.321	  24.950	  28.184	  41.657
1	HE2	MET	   2.139	  -7.020	   0.977	  24.122	  30.979	  38.081
1	HE3	MET	   1.286	  -9.262	   0.233	  26.202	  28.364	  41.176

```



# Organization of this directory
```
.
├── AmberTools22.yml
├── LICENSE.md
├── README.md
├── bin
│   └── getshifts-orca-old
├── example
│   ├── run_example.sh
│   └── schrodinger_md_0.pdb
├── figures
│   └── fig.png
├── initial_structures
│   ├── DHFR_init.pdb
│   └── DHFR_md_input.pdb
├── lib
│   ├── SO4.frcmod
│   ├── SO4.lib
│   ├── TMP.frcmod
│   └── TMP.lib
├── sh
│   ├── extract_shifts.sh
│   ├── logs
│   ├── prepare_scripts.sh
│   ├── run_afnmr.sh
│   ├── run_minimization.sh
│   ├── run_workflow.sh
│   └── submit_all.sh
└── trj2pdb.sh

7 directories, 20 files
```
