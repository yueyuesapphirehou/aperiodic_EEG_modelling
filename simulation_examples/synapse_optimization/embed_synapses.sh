#!/bin/bash
#SBATCH --time=000:30:00
#SBATCH --account=def-akhadra
#SBATCH --mem=20G
#SBATCH --mail-user=niklas.brake@mail.mcgill.ca
#SBATCH --mail-type=FAIL
#SBATCH --cpus-per-task=5
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

module load python/3.8.10
module load mpi4py
module load scipy-stack

virtualenv --no-download $SLURM_TMPDIR/env
source $SLURM_TMPDIR/env/bin/activate
pip install --no-index umap-learn

masterPath=$1
mValues=$2
m=$(sed -n ${SLURM_ARRAY_TASK_ID}p $mValues)

for (( j=1; j<=15; j++ ))
do
    DIR="${masterPath}/m=${m}/rep${j}"
    folder1="$DIR/presynaptic_network/correlations.csv"
    folder2="$DIR/presynaptic_network/UMAP_embedding.csv"
    python ./functions/embed_data.py $folder1 $folder2
done
