#! /bin/bash
#SBATCH --mem=40G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-23%23
#SBATCH --partition=carter-compute


# Author: Meghana Pagadala
# Date: 08/31/2020
#
# Inputs:
# GENO: genotype file
# EXTRACT: snp list in rsid format
# OUT: output directory
#
# Outputs:
# Testosterone.$chrom.raw
#

chroms=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X)
chrom=${chroms[$SLURM_ARRAY_TASK_ID-1]}

echo $SLURM_ARRAY_TASK_ID
echo $HOSTNAME
echo $chrom

date

# Extract testosterone variants

GENO=/cellar/controlled/ukb-salem/GenoImpute/ukb_impute_chr$chrom\_v3
OUT=/cellar/users/mpagadal/projects/TestosteroneGWAS/data/ukbb-prs
EXTRACT=extract.metal.prs.snps.txt

/cellar/users/mpagadal/Programs/plink2 --bgen $GENO.bgen ref-first --sample $GENO.sample --extract $EXTRACT --recode A --out $OUT/Testosterone.$chrom

date
