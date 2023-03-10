# This scripts summarizes results across a fixed tree for a single methods with multiple alignments 

args = commandArgs(trailingOnly = TRUE)
if(length(args) != 3) {
  stop("Incorrect number of arguements")
} else {
  inFile <- args[1] # csv file to read in
  outFile <- args[2] # name of file to print out
  CI <- args[3] # Does this method have confidence intervals
}

dates <- read.csv(inFile)
dates <- as.data.frame(dates)

# Convert days to years
dates$nodeDate <- dates$nodeDate / 365
dates$trueDate <- dates$trueDate / 365

# If the method has confidence intervals
if (CI == 1 ) {

  # Converts days to years for confidence intervals
  dates$lowCI <- dates$lowCI / 365
  dates$highCI <- dates$highCI / 365

  # Determines whether the true date is in the confidence interval
  dates <- cbind(dates, (dates$trueDate>=dates$lowCI) * (dates$trueDate<=dates$highCI))
  colnames(dates)[length(colnames(dates))] <- "Coverage"
} 

dates <- cbind(dates, dates$nodeDate - dates$trueDate)
colnames(dates)[length(colnames(dates))] <- "bias"

RMSE <- c()
Per_RMSE <- c()
bias <- c()
coverage <- c()
CI_size <- c()
#latentTimes <- unique(dates$trueDate)
index <- unique(dates$nodeName)


# For each latent time
#for (i in latentTimes ) {
for (i in index ) {

  # Find which sequences have this latent time
  # (There should be the same number as there are alignments)
  currentDate <- which(dates$nodeName == i)
  #currentDate <- which(dates$trueDate == i)

  # Calculate RMSE and bias
  RMSE <- rbind (RMSE, mean ((dates$nodeDate[currentDate] - dates$trueDate[currentDate])^2)^(1/2))
  Per_RMSE <- rbind (Per_RMSE, (mean ((dates$nodeDate[currentDate] - dates$trueDate[currentDate])^2)^(1/2)) / dates$trueDate[currentDate[1]])
  bias <- rbind(bias, mean(dates$bias[currentDate]))

  # If there are confidence intervals, find the proportion that fall within the confidence interval
  # and the size of the confidence interval
  if (CI == 1) {
    coverage <- rbind(coverage, mean(dates$Coverage[currentDate])) 
    CI_size <- rbind(CI_size, mean((dates$highCI-dates$lowCI)[currentDate]))
  }
}

findTime <- function(x) {
  as.numeric(x[4])/365
}
latentTimes <- unlist(lapply(strsplit(as.character(index), "_"), findTime))

if (CI == 1) {
  stats <- cbind(latentTimes, RMSE, bias, coverage, CI_size, Per_RMSE)
  colnames(stats) <- c("latentTime", "RMSE", "bias", "coverageProb", "CISize", "Per_RMSE")
} else {
  stats <- cbind(latentTimes, RMSE, bias, Per_RMSE)
  colnames(stats) <- c("latentTime", "RMSE", "bias", "Per_RMSE")
}


print(paste("Correlation:", cor(dates$trueDate, dates$nodeDate)))

print("Means:")
cat(colnames(stats), sep = "\t")
cat("", sep="\n")
cat(format(apply(stats, 2, mean), scientific = FALSE))

cat("", sep="\n")
print("Linear model:")
lm(dates$nodeDate ~ dates$trueDate)
#plot(dates$trueDate, dates$nodeDate, xlab = "True Time", ylab = "Inferred Time", pch =20)
#abline(lm(dates$nodeDate ~ dates$trueDate))

write.csv(stats, file = outFile, row.names = FALSE)
