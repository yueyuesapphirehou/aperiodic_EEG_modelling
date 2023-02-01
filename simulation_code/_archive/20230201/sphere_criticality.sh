#!/bin/bash
#SBATCH --time=000:10:00
#SBATCH --account=def-akhadra
#SBATCH --mem=4000
#SBATCH --mail-user=niklas.brake@mail.mcgill.ca
#SBATCH --mail-type=ALL

module load python/3.8.10
module load mpi4py
module load scipy-stack
module load matlab/2020a
module load neuron

virtualenv --no-download $SLURM_TMPDIR/env
source $SLURM_TMPDIR/env/bin/activate
pip install --no-index --upgrade pip --quiet
pip install --no-index -r requirements.txt --quiet
pip install --no-index LFPy --quiet

matlab -nodisplay -r "sphere_criticality('$1')"