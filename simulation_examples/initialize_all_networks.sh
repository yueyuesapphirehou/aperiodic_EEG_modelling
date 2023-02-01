#!/bin/bash
#SBATCH --time=001:00:00
#SBATCH --account=def-akhadra
#SBATCH --mem=4000
#SBATCH --mail-user=niklas.brake@mail.mcgill.ca
#SBATCH --mail-type=FAIL

module load matlab/2020a

# masterPath='/lustre04/scratch/nbrake/data/simulations/raw/synapse_embedding_2'
masterPath=$1
mValues='/home/nbrake/aperiodic_EEG_modelling/simulations/mValues'

# N=$(cat $mValues | wc -w)

# for (( i=1; i<=N; i++ ))
# do
#     m=$(sed -n ${i}p $mValues)
#     DIR="${masterPath}/m=${m}"
#     matlab -nodisplay -r "initialize_all_networks('$DIR',$m)"
# done

m=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $mValues)
DIR="${masterPath}/m=${m}"
matlab -nodisplay -r "initialize_all_networks('$DIR',$m)"