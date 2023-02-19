# HIVtreeRevisions

This repository has the code and data files needed to reproduce a subset of results in the originally submitted and revised versions of "Bayesian Phylogenetic Inference of HIV Latent Lineage Ages Using Serial Sequences".
This repository contains two partially processed datasets, in the original_data and revision_data directories.
The scripts create three plots for each dataset, one with the incorrect calculation of mean square error (MSE), one with the correct calculation of MSE, and one with the calculation of root mean square error (RMSE).

R must be installed to create the figures.
Once R is installed, the R packages ggplot2, viridis, cowplot, ggpubr, and scale must be installed.
To install the R packages needed for plotting the results, run the following command from within the HIVtreeRevisions repository

```
Rscript installPackages.R
```

To reproduce the figure in the cover letter for the third manuscript version submitted to Journal of the Royal Society Interface, run the following code from inside the HIVtreeRevisions directory on a unix machine. 

```
./runComparion.sh 
```

The plots are output to a file summaryRevisions.pdf. The left column of plots are created with the original dataset and the right column plots are created with the dataset used in the revisions.
