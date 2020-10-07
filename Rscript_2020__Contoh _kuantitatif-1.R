#!/usr/bin/Rscript


#Script	: Rscript_2020__Contoh _kuantitatif-1
#Author	: Mohammad Miftakhus Sholikin
#Descr.	: Effect of Antimicrobial Peptide on Broiler Performance: Linear Mixed Model Evaluation
#Date   	: 08-Oktober-2020

  

# input library
library(RCurl)
library(readxl)
library(lme4)



# input data
#offline >> local directory
metal_data <- read_excel("Data_2020__AMP_broiler.xlsx")

#online >> github
get_url <- getURL("https://raw.githubusercontent.com/mohammad-miftakhus-sholikin/pelatihan-2020-metal/master/Data_2020__AMP_broiler.csv")
metal_data <- read.csv(text=get_url, sep = ",", dec = ".")


# linear and linear mixed model
lm_1 <- lm(bw ~ scale(level), data=metal_data)
lm_2 <- lmer(bw ~ scale(level) + (1|study), data=metal_data)



# BIC
BIC(lm_1, lm_2)
AIC(lm_1, lm_2)
