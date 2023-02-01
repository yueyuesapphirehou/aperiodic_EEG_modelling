#!/bin/bash
#SBATCH --time=003:00:00
#SBATCH --account=def-akhadra
#SBATCH --mem=5000
#SBATCH --mail-user=niklas.brake@mail.mcgill.ca
#SBATCH --mail-type=FAIL,END

module load matlab/2020a

# mValues='/home/nbrake/aperiodic_EEG_modelling/simulations/mValues'
# m=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $mValues)
matlab -nodisplay -r "initialize_synapse_embedding('$1')"