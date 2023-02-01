#!/bin/bash
#SBATCH --time=000:10:00
#SBATCH --account=def-akhadra
#SBATCH --mem=4000
#SBATCH --mail-user=niklas.brake@mail.mcgill.ca
#SBATCH --mail-type=ALL

# module load python/3.8.10
# module load neuron
# module load mpi4py

# virtualenv --no-download $SLURM_TMPDIR/env
# source $SLURM_TMPDIR/env/bin/activate
# pip install --no-index --upgrade pip
# pip install --no-index -r requirements.txt
# pip install --no-index LFPy
# pip install --no-index --upgrade numpy

module load matlab/2020a
# matlab -nodisplay -r "runBelugaSimulations('$1')"
matlab -nodisplay -r "runSimulations"