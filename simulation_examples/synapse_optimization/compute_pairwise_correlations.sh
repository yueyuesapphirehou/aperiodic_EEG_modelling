#!/bin/bash
#SBATCH --time=006:00:00
#SBATCH --account=def-akhadra
#SBATCH --mem=4G
#SBATCH --mail-user=niklas.brake@mail.mcgill.ca
#SBATCH --mail-type=FAIL
#SBATCH --cpus-per-task=8
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

masterPath=$1
mValues=$2
m=$(sed -n ${SLURM_ARRAY_TASK_ID}p $mValues)
DIR="${masterPath}/m=${m}"

folder1="$DIR/dyad_1/presynaptic_network/spikeTimesLong.csv"
folder2="$DIR/dyad_1/presynaptic_network/correlations.csv"
./functions/compute_tiling_correlation.exe $folder1 $folder2