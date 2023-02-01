#!/bin/bash
#SBATCH --time=000:30:00
#SBATCH --account=def-akhadra
#SBATCH --mem=5000
#SBATCH --mail-user=niklas.brake@mail.mcgill.ca
#SBATCH --mail-type=FAIL,END
#SBATCH --cpus-per-task=12
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

inputFiles=("$@")

declare -i N=${#inputFiles[@]}
for (( i=0; i<$N; i++ ))
do
    folder1="${inputFiles[$i]}/spikeFileLong.csv"
    folder2="${inputFiles[$i]}/correlation.csv"
    ./functions/compute_correlation_matrix_parallel.exe $folder1 $folder2
done
