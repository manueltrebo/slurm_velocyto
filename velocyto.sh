#!/bin/bash

#SBATCH --job-name=velocyto_bd
#SBATCH --partition=small_jobs
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=50
#SBATCH --mem=100G
#SBATCH --output=/home/q089mt/scRNAseq/HLH_velocyto/results/%j.out
#SBATCH --error=/home/q089mt/scRNAseq/HLH_velocyto/results/%j.err

# activate conda env

source /opt/spack/spack/opt/spack/linux-rocky9-zen3/gcc-11.3.1/miniconda3-22.11.1-gh5btg2paoib4qia5y5xv6lqr7pfsmak/etc/profile.d/conda.sh

spack load /kyfnji3 #spack load nextflow
spack load /xshgbz3 # spack load samtools - now the older version (newer one had a problem with six)
conda activate velocyto

# Enable verbose output and debugging
set -x
echo "Starting Nextflow job"

# START THE APPLICATION
nextflow run main.nf -profile cluster,conda -resume
echo "Nextflow job completed"
