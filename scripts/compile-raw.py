import pandas as pd
from itertools import islice
import argparse
import os

def main(args):
    file_path=args.directory
    
    chroms=["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","X"]

    compiled_raw=pd.read_csv(file_path+"/Testosterone.1.raw",delim_whitespace=True)
    
    del compiled_raw["IID"]
    del compiled_raw["PAT"]
    del compiled_raw["MAT"]
    del compiled_raw["SEX"]
    del compiled_raw["PHENOTYPE"]
    
    for x in chroms[1:]:
        try:
            file="Testosterone."+x+".raw"
            filename=file_path+"/"+file
            raw=pd.read_csv(filename,delim_whitespace=True)
            
            if x == "X":
                mappingx=pd.read_csv("/nrnb/ukb-salem/GenoInfo/UKBiobank_genoQC_allancestry_linker.txt",delim_whitespace=True)
                mapx=dict(zip(mappingx["FID_Salem"],mappingx["FID"]))
                raw["FID"]=raw["FID"].map(mapx)
                raw = raw[~raw["FID"].isnull()]

            del raw["PAT"]
            del raw["MAT"]
            del raw["SEX"]
            del raw["PHENOTYPE"]
            del raw["IID"]
            
            compiled_raw=pd.merge(compiled_raw,raw,on=["FID"],how="left")

#             with open(filename,"r") as fin:
#                 for line in fin.readlines()[1:]:
#                     out=file_path+"/"+line.split("\t")[1]+".geno.txt"
#                     with open(out, "a") as file_object:
#                         # Append genotypes
#                         file_object.write(" ".join(line.split("\t")[6:]))
        except:
            print("{} chromosome file not found".format(x))
            
    compiled_raw.to_csv(args.out,index=None,sep="\t")
        
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--directory', type=str, help='where raw files are located')
    parser.add_argument('--out', type=str, help='output file')
#     parser.add_argument('--iid', type=str, help='name of patient')
    args = parser.parse_args()
    main(args) 
