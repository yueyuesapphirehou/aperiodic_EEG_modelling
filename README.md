## Overview
In this repository is the code associated with the following paper: 

Brake N, Duc F, Rokos A, Arseneau F, Shiva Shahiri S, Khadra A and Plourde G (2023). "A Unified Theory of Aperiodic EEG Predicts Signatures of Propofol Anesthesia." ***Submitted***

The repo contains functions to reproduce all the figures in the paper. Use function set_matlab_path to set the path. Functions take the argument ***dataFolder***, which is the path to analyzed EEG data and simulations. This data can be downloaded here:  
    https://drive.google.com/uc?export=download&id=173OsShSYm1u3OX_Q96gsWXYATuHBbL0s


The repo also contains functions to run EEG simulations. Things that need to be compiled for simulation  
&emsp;From the base directory, compile the C program for computing tiling correlation (requires openmp for parallel computing)  
&emsp;&emsp;gcc -o ./simulation_code/compute_tiling_correlation.exe ./simulation_code/compute_tiling_correlation.c -fopenmp -lm  
&emsp;Navigate to ./simulation_code/mod_files and compile the MOD files for neuron, i.e. using nrnivmodl.  

Python dependencies  
    python/3.8.10  
    mpi4py  
    scipy-stack  
    neuron  
    LFPy  
    umap-learn  

## License
<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.

To reference this code, please cite the journal article mentioned above.
