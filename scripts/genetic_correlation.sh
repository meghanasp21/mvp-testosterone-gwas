#! /bin/bash
#SBATCH --mem=20G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR

date

#out=/cellar/users/mpagadal/Data2/ldsc
#cd $out

###############################################
### GENETIC CORRELATION BETWEEN EUR and AFR ###
###############################################

/cellar/users/mpagadal/Programs/anaconda3/envs/py2/bin/python ~/Programs/ldsc/ldsc.py --rg eur.testosterone.sumstats.gz,afr.testosterone.sumstats.gz --ref-ld-chr /cellar/users/mpagadal/Data2/ldsc/1000G_plink/EUR/baseline. --w-ld-chr /cellar/users/mpagadal/Data2/ldsc/weights_hm3_no_hla/weights. --out eur.afr.eur.ref.corr

###############################################
### GENETIC CORRELATION BETWEEN EUR and HIS ###
###############################################

/cellar/users/mpagadal/Programs/anaconda3/envs/py2/bin/python ~/Programs/ldsc/ldsc.py --rg eur.testosterone.sumstats.gz,his.testosterone.sumstats.gz --ref-ld-chr /cellar/users/mpagadal/Data2/ldsc/1000G_plink/EUR/baseline. --w-ld-chr /cellar/users/mpagadal/Data2/ldsc/weights_hm3_no_hla/weights. --out eur.his.eur.ref.corr


###############################################
### GENETIC CORRELATION BETWEEN AFR and HIS ###
###############################################

/cellar/users/mpagadal/Programs/anaconda3/envs/py2/bin/python ~/Programs/ldsc/ldsc.py --rg afr.testosterone.sumstats.gz,his.testosterone.sumstats.gz --ref-ld-chr /cellar/users/mpagadal/Data2/ldsc/1000G_plink/AFR/baseline. --w-ld-chr /cellar/users/mpagadal/Data2/ldsc/weights_hm3_no_hla/weights. --out afr.his.afr.ref.corr


date

