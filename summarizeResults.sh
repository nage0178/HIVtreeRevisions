#!/bin/bash

maxBatch=20 # Should be 20
maxRep=5 # Should be 5
maxSub=3 # Should be 3
for data in original revision
do

	mkdir summary_${data}
for calculation in MSE MSEerror RMSE
do
# Calculates some summary statistics for each set of analyses on a fixed tree using an R script
  for gene in nef tat p17 C1V2
  do
      for ((rep=1;rep<=maxRep;rep++));
      do
        for ((sub=1;sub<=maxSub;sub++));
        do
          for ((batch=1;batch<=maxBatch;batch++));
          do
		name=b${batch}r${rep}s${sub}${gene}
		Rscript summaryStats${calculation}.R ${data}_data/LS/results/${name}_combine.csv summary_${data}/${name}_${calculation}_summaryLS.csv 1 &> summary_${data}/${name}_${calculation}_summaryLS &
		Rscript summaryStats${calculation}.R ${data}_data/ML/results/${name}_combine.csv summary_${data}/${name}_${calculation}_summaryML.csv 0 &> summary_${data}/${name}_${calculation}_summaryML &
		Rscript summaryStats${calculation}.R ${data}_data/LR/results/${name}_combine.csv summary_${data}/${name}_${calculation}_summaryLR.csv 1 &> summary_${data}/${name}_${calculation}_summaryLR &
		Rscript summaryStats${calculation}.R ${data}_data/mcmctree/${name}_combine.csv summary_${data}/${name}_${calculation}_summaryBayes.csv 1 &> summary_${data}/${name}_${calculation}_summaryBayes &
       	done
      done
      wait $!
    done
  done


for ((rep=1;rep<=maxRep;rep++));
do
	for ((batch=1;batch<=maxBatch;batch++));
	do
		sub=1
		name=b${batch}r${rep}s${sub}combine
	
		Rscript summaryStats${calculation}.R ${data}_data/rmNAcombineGeneFiles/${name}.csv summary_${data}/${name}_${calculation}_summaryBayesCombine.csv 1 &> summary_${data}/${name}_${calculation}_summaryBayesCombine &
		Rscript summaryStats${calculation}.R ${data}_data/rmNAcombineGeneFiles/${name}2.csv summary_${data}/${name}_${calculation}_summaryBayesCombine2.csv 1 &> summary_${data}/${name}_${calculation}_summaryBayesCombine2 &
	done
done
done
done
