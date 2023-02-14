library(ggplot2)
library(viridis)
library(cowplot)
library(ggpubr)
library(scales)

dataset <- c("_original/", "_revision/")
calculation <-c("MSEerror", "MSE", "RMSE")
plot_list <- list()
for (j in 1:3) {
  for (i in 1:2) {
    C1V2 <- read.csv(paste("~/HIVtreeRevisions/plots", dataset[i], "C1V2_", calculation[j],"_LS", sep = ""))
    nef <-  read.csv(paste("~/HIVtreeRevisions/plots", dataset[i], "nef_",  calculation[j],"_LS", sep = ""))
    p17 <-  read.csv(paste("~/HIVtreeRevisions/plots", dataset[i], "p17_",  calculation[j],"_LS", sep = ""))
    tat <-  read.csv(paste("~/HIVtreeRevisions/plots", dataset[i], "tat_",  calculation[j],"_LS", sep = ""))
    
    C1V2ML <- read.csv(paste("~/HIVtreeRevisions/plots", dataset[i], "C1V2_", calculation[j], "_ML", sep = ""))
    nefML <-  read.csv(paste("~/HIVtreeRevisions/plots", dataset[i],  "nef_", calculation[j], "_ML", sep = ""))
    p17ML <-  read.csv(paste("~/HIVtreeRevisions/plots", dataset[i],  "p17_", calculation[j], "_ML", sep = ""))
    tatML <-  read.csv(paste("~/HIVtreeRevisions/plots", dataset[i],  "tat_", calculation[j], "_ML", sep = ""))
    
    C1V2LR<- read.csv(paste("~/HIVtreeRevisions/plots", dataset[i], "C1V2_", calculation[j], "_LR", sep = ""))
    nefLR <- read.csv(paste("~/HIVtreeRevisions/plots", dataset[i],  "nef_", calculation[j], "_LR", sep = ""))
    p17LR <- read.csv(paste("~/HIVtreeRevisions/plots", dataset[i],  "p17_", calculation[j], "_LR", sep = ""))
    tatLR <- read.csv(paste("~/HIVtreeRevisions/plots", dataset[i],  "tat_", calculation[j], "_LR", sep = ""))
    
    C1V2Bayes<- read.csv(paste("~/HIVtreeRevisions/plots", dataset[i], "C1V2_", calculation[j], "_Bayes", sep = ""))
    nefBayes <- read.csv(paste("~/HIVtreeRevisions/plots", dataset[i],  "nef_", calculation[j], "_Bayes", sep = ""))
    p17Bayes <- read.csv(paste("~/HIVtreeRevisions/plots", dataset[i],  "p17_", calculation[j], "_Bayes", sep = ""))
    tatBayes <- read.csv(paste("~/HIVtreeRevisions/plots", dataset[i],  "tat_", calculation[j], "_Bayes", sep = ""))
    combineBayes <-  read.csv(paste("~/HIVtreeRevisions/plots", dataset[i], calculation[j], "_combine_Bayes", sep = ""))
    combineBayes2 <- read.csv(paste("~/HIVtreeRevisions/plots", dataset[i], calculation[j], "_combine_Bayes2", sep = ""))
    
    LS <- rbind(C1V2, nef, p17, tat)
    gene <- c(rep("C1V2", dim(C1V2)[1]), 
              rep("nef", dim(nef)[1]),
              rep("p17", dim(p17)[1]),
              rep("tat", dim(tat)[1]))
    LS <- cbind(LS, as.factor(gene))
    colnames(LS)[length(colnames(LS))] <- "gene"
    
    ML <- rbind(C1V2ML, nefML, p17ML, tatML)
    ML <- cbind(ML[ ,1:(dim(ML)[2]-1)], NA, NA, ML[dim(ML)[2]])
    colnames(ML)[(length(colnames(ML))-2) : (length(colnames(ML))-1)] <- c("coverageProb", "CISize")
    geneML <- c(rep("C1V2", dim(C1V2ML)[1]), 
                rep("nef", dim(nefML)[1]),
                rep("p17", dim(p17ML)[1]),
                rep("tat", dim(tatML)[1]))
    ML <- cbind(ML, as.factor(geneML))
    colnames(ML)[length(colnames(ML))] <- "gene"
    
    LR <- rbind(C1V2LR, nefLR, p17LR, tatLR)
    geneLR <- c(rep("C1V2", dim(C1V2LR)[1]), 
                rep("nef", dim(nefLR)[1]),
                rep("p17", dim(p17LR)[1]),
                rep("tat", dim(tatLR)[1]))
    LR <- cbind(LR, as.factor(geneLR))
    colnames(LR)[length(colnames(LR))] <- "gene"
    
    Bayes <- rbind(combineBayes, combineBayes2, C1V2Bayes, nefBayes, p17Bayes, tatBayes)
    
    geneBayes <- c(rep("all", dim(combineBayes)[1]),
                   rep("p17/\ntat", dim(combineBayes2)[1]),
                   rep( "C1V2", dim(C1V2Bayes)[1]), 
                   rep("nef", dim(nefBayes)[1]),
                   rep("p17", dim(p17Bayes)[1]),
                   rep("tat", dim(tatBayes)[1]))
    Bayes <- cbind(Bayes, as.factor(geneBayes))
    colnames(Bayes)[length(colnames(Bayes))] <- "gene"
    
    combResult <- rbind(Bayes,LS, ML, LR)
    analysisType <- c(rep("Bayes", dim(Bayes)[1]), 
                      rep("LS", dim(LS)[1]),
                      rep("ML", dim(ML)[1]), 
                      rep("LR", dim(LR)[1])
    )
    combResult <- cbind(combResult, as.factor(analysisType))
    colnames(combResult)[length(colnames(combResult))] <- "analysis"
    
    rmse_p_leg <- ggplot(combResult, aes(factor(analysis), RMSE, fill = analysis)) + geom_violin() + facet_grid(cols = vars(gene))  +theme_half_open()  +labs(
      x = "Analysis",
      y = "MSE (years squared)\n"
    ) + theme(legend.position = 'top', legend.justification='center',
              legend.direction='horizontal', #panel.spacing = unit(.05, "lines"),
              panel.border = element_rect(color = "black", fill = NA), 
              strip.background = element_rect(color = "black"), 
              plot.title = element_text(face = "plain",  size = 14)) + scale_color_viridis(discrete = TRUE, option = "H") +
      scale_fill_viridis(discrete = TRUE)
    
    rmse_p <- ggplot(combResult, aes(factor(analysis), RMSE, fill = analysis)) + geom_violin() + facet_grid(~factor(gene,levels =c('all','p17/\ntat','C1V2','nef','p17', 'tat')), scales = "free", space = "free")  +theme_half_open()  +labs(
      #x = "Analysis",
      y = calculation[j]
    ) + theme(legend.position = "none", axis.title.x=element_blank(),
              axis.text.x=element_blank(),
              axis.ticks.x=element_blank(),
              panel.border = element_rect(color = "black", fill = NA), 
              strip.background = element_rect(color = "black"), 
              plot.title = element_text(face = "plain",  size = 14)) + scale_color_viridis(discrete = TRUE, option = "H") +
      scale_fill_viridis(discrete = TRUE)   
    rmse_p
    
    plot_list[[i + (length(dataset) * (j-1))]] <- rmse_p
  }
}

legend1 <- cowplot::get_legend(rmse_p_leg)
leg1 <- as_ggplot(legend1)


figure <- ggarrange(plot_list[[1]], plot_list[[2]], 
                    plot_list[[3]], plot_list[[4]], 
                    plot_list[[5]], plot_list[[6]], 
                    leg1, leg1,
                    labels = c("a", "b", "c", "d", "e", "f", ""),
                    heights = c( 3, 3, 3, .5),
                    ncol = 2, nrow = 4)
#pdf("~/latency_manuscript/figures/summaryRevisions.pdf", width = 14, height = 12)

pdf("~/HIVtreeRevisions/summaryRevisions.pdf", width = 14, height = 12)
figure
dev.off()
# save pdf 5 x 7
