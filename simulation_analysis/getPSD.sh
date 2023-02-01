#!/bin/bash
#SBATCH --time=04:00:00
#SBATCH --gpus-per-node=1
#SBATCH --account=def-akhadra
#SBATCH --mem=16G
#SBATCH --mail-user=niklas.brake@mail.mcgill.ca
#SBATCH --mail-type=ALL


module load matlab/2020a

# mValues='/home/nbrake/aperiodic_EEG_modelling/simulations/mValues'
# m=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $mValues)
# matlab -nodisplay -r "getPSD_suboptimal($m)"
matlab -nodisplay -r "getPSD3('$1')"