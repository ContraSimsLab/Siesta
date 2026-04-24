#!/bin/bash
#PBS -S /bin/bash
#PBS -N test_siesta
#PBS -l select=1:ncpus=6:mpiprocs=6
#PBS -q workq
#PBS -joe
#PBS -V
#PBS -e test.err
#PBS -o test.out
export KMP_AFFINITY=verbose,scatter
export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
ulimit -s unlimited

source /c14scratch/apps/modules/init/bash

module load openmpi/5.0.5
module load fftw-3/3.3.10
module load tbb/latest
module load compiler-rt/latest
module load mkl/2024.2

cd $PBS_O_WORKDIR
cat $PBS_NODEFILE > pbs_nodes
echo Working directory is $PBS_O_WORKDIR
NPROCS=`wc -l < $PBS_NODEFILE`
NNODES=`uniq $PBS_NODEFILE | wc -l`

mpirun -np $NPROCS /c14scratch/apps/siesta/v5.4/bin/siesta --electrode input.fdf | tee output.txt
