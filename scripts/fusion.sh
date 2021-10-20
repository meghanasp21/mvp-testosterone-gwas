#! /bin/bash
#SBATCH --mem=80G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-22%22


chroms=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)
chrom=${chroms[$SLURM_ARRAY_TASK_ID-1]}

tissue=$1

echo $tissue
echo $chrom

ld=/cellar/users/mpagadal/Data2/ldsc/1000G_plink/EUR/1000G.EUR.

cmd="Rscript FUSION.assoc_test.R --sumstats ukbb.sumstats.tsv --weights ./WEIGHTS/WEIGHTS/$tissue.pos --weights_dir ./WEIGHTS/WEIGHTS/ --ref_ld_chr $ld --chr $chrom --out ukbb.$tissue.$chrom.dat"
echo $cmd
$cmd

cat ukbb.$tissue.$chrom.dat | awk 'NR == 1 || $NF < 0.05/2058' > ukbb.$tissue.$chrom.top

Rscript FUSION.post_process.R --sumstats ukbb.sumstats.tsv --input ukbb.$tissue.$chrom.top --out ukbb.$tissue.$chrom.top.analysis --ref_ld_chr $ld --chr $chrom --plot --locus_win 100000

cmd="Rscript FUSION.assoc_test.R --sumstats eur.sumstats.tsv --weights ./WEIGHTS/WEIGHTS/$tissue.pos --weights_dir ./WEIGHTS/WEIGHTS/ --ref_ld_chr $ld --chr $chrom --out eur.$tissue.$chrom.dat"
echo $cmd
$cmd

cat eur.$tissue.$chrom.dat | awk 'NR == 1 || $NF < 0.05/2058' > eur.$tissue.$chrom.top

Rscript FUSION.post_process.R --sumstats eur.sumstats.tsv --input eur.$tissue.$chrom.top --out eur.$tissue.$chrom.top.analysis --ref_ld_chr $ld --chr $chrom --plot --locus_win 100000
