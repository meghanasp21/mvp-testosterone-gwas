#! /bin/bash
#SBATCH --mem=20G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-3%3
#SBATCH --partition=carter-compute

date

########################
# GET BASELINE LDSCORE #
########################

groups=(eur afr his)
group=${groups[$SLURM_ARRAY_TASK_ID-1]}

folders=(EUR AFR AMR)
folder=${folders[$SLURM_ARRAY_TASK_ID-1]}

sbatch --wait compute_ldscore.sh $folder


#############################
# FORMAT SUMMARY STATISTICS #
#############################

sumstats_dir=/cellar/users/mpagadal/projects/TestosteroneGWAS/heritability/ldsc/sumstats
h2_dir=/cellar/users/mpagadal/projects/TestosteroneGWAS/heritability/ldsc/data/h2
ref_dir=/cellar/users/mpagadal/data/ldsc/1000G_plink/$folder/baseline.
weights_dir=/cellar/users/mpagadal/data/ldsc/weights_hm3_no_hla/weights.
frq_dir=/cellar/users/mpagadal/data/ldsc/1000G_plink/$folder\_frq/1000G.$folder.
sumstats=/cellar/users/mpagadal/projects/TestosteroneGWAS/discovery/data/summarystats/full/compiled.$group.rsid.release4.testosterone.glm.linear

cd $sumstats_dir

~/Programs/miniconda3/envs/py2/bin/python ~/Programs/ldsc/munge_sumstats.py --out $group.testosterone --snp ID --a1 ALT --a2 REF --N-col OBS_CT --sumstats $sumstats

cd $h2_dir

~/Programs/miniconda3/envs/py2/bin/python ~/Programs/ldsc/ldsc.py --h2 $sumstats_dir/$group.testosterone.sumstats.gz --ref-ld-chr $ref_dir --w-ld-chr $weights_dir --frqfile-chr $frq_dir --overlap-annot --out $group.baseline.nomerge


date

