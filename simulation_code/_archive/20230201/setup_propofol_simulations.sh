#!/bin/bash
#SBATCH --time=001:00:00
#SBATCH --account=def-akhadra
#SBATCH --mem=5000
#SBATCH --mail-user=niklas.brake@mail.mcgill.ca
#SBATCH --mail-type=ALL

module load python/3.8.10
module load matlab/2020a
module load neuron
module load mpi4py

virtualenv --no-download $SLURM_TMPDIR/env
source $SLURM_TMPDIR/env/bin/activate
pip install --no-index --upgrade pip
pip install --no-index -r requirements.txt
pip install --no-index LFPy
pip install --no-index --upgrade numpy

matlab -nodisplay -r "simulate_propofol_effects"