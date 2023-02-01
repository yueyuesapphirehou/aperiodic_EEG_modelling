#!/bin/bash
#SBATCH --time=01:00:00
#SBATCH --account=def-akhadra
#SBATCH --mem=4G
#SBATCH --mail-user=niklas.brake@mail.mcgill.ca
#SBATCH --mail-type=ALL

module load matlab/2020a
matlab -nodisplay -r "getCorr2('$1')"
