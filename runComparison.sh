#!/bin/bash

./summarizeResults.sh &> outSummarize

./regressionSum.sh &> outRegression

Rscript plots.R
