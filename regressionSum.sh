#!/bin/bash


maxBatch=20 #20 # Should be 20
maxRep=5 # Should be 5
maxSub=3 # Should be 3

for data in original revision
do
	mkdir plots_${data}
for calculation in MSE MSEerror RMSE
do
# Puts information calculated in R into a csv for each analysis for each gene
# This produces the final csv used to make the summary figure for the analysis 
# of the main simulated data
  for gene in nef tat p17 C1V2
  do
          echo batch,rep,sub,intercept,slope,correlation,latentTime,RMSE,bias,coverageProb,CISize,per_RMSE >plots_${data}/${gene}_${calculation}_LS
          echo batch,rep,sub,intercept,slope,correlation,latentTime,RMSE,bias,per_RMSE>plots_${data}/${gene}_${calculation}_ML
          echo batch,rep,sub,intercept,slope,correlation,latentTime,RMSE,bias,coverageProb,CISize,per_RMSE>plots_${data}/${gene}_${calculation}_LR
          echo batch,rep,sub,intercept,slope,correlation,latentTime,RMSE,bias,coverageProb,CISize,per_RMSE  >plots_${data}/${gene}_${calculation}_Bayes
          
      for ((rep=1;rep<=maxRep;rep++));
      do
        for ((sub=1;sub<=maxSub;sub++));
        do
          for ((batch=1;batch<=maxBatch;batch++));
          do
        	name=b${batch}r${rep}s${sub}${gene}

        	# LS method
        	regression=$(tail -2 summary_${data}/${name}_${calculation}_summaryLS | head -1)
        	correlation=$(grep Correlation summary_${data}/${name}_${calculation}_summaryLS | awk '{ print $3 }' | sed 's/"//g')
        	means=$(tail -n +4 summary_${data}/${name}_${calculation}_summaryLS| head -1 )

        	echo ${batch},${rep},${sub},${regression},${correlation},${means}>> plots_${data}/${gene}_${calculation}_LS

        	# ML  method
        	regressionND=$(tail -2 summary_${data}/${name}_${calculation}_summaryML | head -1)
        	correlationND=$(grep Correlation summary_${data}/${name}_${calculation}_summaryML | awk '{ print $3 }' | sed 's/"//g')
        	meansND=$(tail -n +4 summary_${data}/${name}_${calculation}_summaryML | head -1 )

        	echo ${batch},${rep},${sub},${regressionND},${correlationND},${meansND}>> plots_${data}/${gene}_${calculation}_ML

        	#LR  
        	regressionLR=$(tail -2 summary_${data}/${name}_${calculation}_summaryLR | head -1)
        	correlationLR=$(grep Correlation summary_${data}/${name}_${calculation}_summaryLR | awk '{ print $3 }' | sed 's/"//g')
        	meansLR=$(tail -n +4 summary_${data}/${name}_${calculation}_summaryLR | head -1 )

		echo ${batch},${rep},${sub},${regressionLR},${correlationLR},${meansLR}>> plots_${data}/${gene}_${calculation}_LR

        	#Bayes 
        	
        	regressionBayes=$(tail -2 summary_${data}/${name}_${calculation}_summaryBayes | head -1)
        	correlationBayes=$(grep Correlation summary_${data}/${name}_${calculation}_summaryBayes | awk '{ print $3 }' | sed 's/"//g')
        	meansBayes=$(tail -n +4 summary_${data}/${name}_${calculation}_summaryBayes | head -1 )

        	echo ${batch},${rep},${sub},${regressionBayes},${correlationBayes},${meansBayes}>> plots_${data}/${gene}_${calculation}_Bayes
       	done
      done
      wait $!
    done
    sed -i 's/"//g' plots_${data}/${gene}_${calculation}_LS
    sed -i 's/  / /g' plots_${data}/${gene}_${calculation}_LS
    sed -i 's/ /,/g' plots_${data}/${gene}_${calculation}_LS
    sed -i 's/,,/,/g' plots_${data}/${gene}_${calculation}_LS

    sed -i 's/"//g' plots_${data}/${gene}_${calculation}_ML
    sed -i 's/  / /g' plots_${data}/${gene}_${calculation}_ML
    sed -i 's/ /,/g' plots_${data}/${gene}_${calculation}_ML
    sed -i 's/,,/,/g' plots_${data}/${gene}_${calculation}_ML

    sed -i 's/"//g' plots_${data}/${gene}_${calculation}_LR
    sed -i 's/  / /g' plots_${data}/${gene}_${calculation}_LR
    sed -i 's/ /,/g' plots_${data}/${gene}_${calculation}_LR
    sed -i 's/,,/,/g' plots_${data}/${gene}_${calculation}_LR

    sed -i 's/"//g' plots_${data}/${gene}_${calculation}_Bayes
    sed -i 's/  / /g' plots_${data}/${gene}_${calculation}_Bayes
    sed -i 's/ /,/g' plots_${data}/${gene}_${calculation}_Bayes
    sed -i 's/,,/,/g' plots_${data}/${gene}_${calculation}_Bayes
  done
   # For some reason, R printed out the results on two lines for this run only, so the CI was not displayed. Fixing it manually since it was only a single run


# Puts information calculated in R into a csv for each analysis for each gene
echo batch,rep,sub,intercept,slope,correlation,latentTime,RMSE,bias,coverageProb,CISize,per_RMSE >plots_${data}/${calculation}_combine_Bayes
echo batch,rep,sub,intercept,slope,correlation,latentTime,RMSE,bias,coverageProb,CISize,per_RMSE >plots_${data}/${calculation}_combine_Bayes2
        
for ((rep=1;rep<=maxRep;rep++));
do
	for ((batch=1;batch<=maxBatch;batch++));
        do
		sub=1
	      	name=b${batch}r${rep}s${sub}combine
	
	      	#Bayes 
	      	
	      	regressionBayesC=$(tail -2 summary_${data}/${name}_${calculation}_summaryBayesCombine | head -1)
	      	correlationBayesC=$(grep Correlation summary_${data}/${name}_${calculation}_summaryBayesCombine | awk '{ print $3 }' | sed 's/"//g')
	      	meansBayesC=$(tail -n +4 summary_${data}/${name}_${calculation}_summaryBayesCombine | head -1 )
	
      		echo ${batch},${rep},${sub},${regressionBayesC},${correlationBayesC},${meansBayesC}>> plots_${data}/${calculation}_combine_Bayes

	      	#Bayes 2
	      	
	      	regressionBayesC2=$(tail -2 summary_${data}/${name}_${calculation}_summaryBayesCombine2 | head -1)
	      	correlationBayesC2=$(grep Correlation summary_${data}/${name}_${calculation}_summaryBayesCombine2 | awk '{ print $3 }' | sed 's/"//g')
	      	meansBayesC2=$(tail -n +4 summary_${data}/${name}_${calculation}_summaryBayesCombine2 | head -1 )
	
      		echo ${batch},${rep},${sub},${regressionBayesC2},${correlationBayesC2},${meansBayesC2}>> plots_${data}/${calculation}_combine_Bayes2
	done
done


sed -i 's/"//g' plots_${data}/${calculation}_combine_Bayes
sed -i 's/  / /g' plots_${data}/${calculation}_combine_Bayes
sed -i 's/ /,/g' plots_${data}/${calculation}_combine_Bayes
sed -i 's/,,/,/g' plots_${data}/${calculation}_combine_Bayes

sed -i 's/"//g' plots_${data}/${calculation}_combine_Bayes2
sed -i 's/  / /g' plots_${data}/${calculation}_combine_Bayes2
sed -i 's/ /,/g' plots_${data}/${calculation}_combine_Bayes2
sed -i 's/,,/,/g' plots_${data}/${calculation}_combine_Bayes2

done
done
