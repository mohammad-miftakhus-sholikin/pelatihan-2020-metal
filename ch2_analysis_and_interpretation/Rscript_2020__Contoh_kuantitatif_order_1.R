#!/usr/bin/Rscript

#Script : Rscript_2020__Contoh _kuantitatif-1
#Author : Mohammad Miftakhus Sholikin
#Descr. : Effect of Antimicrobial Peptide on Broiler Performance: Linear Mixed Model Evaluation
#Date   : 08-Oktober-2020
  

# initialize
## install new packages
wants <- c("curl", "readxl", "lme4")
has <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## input library
library(curl)
library(readxl)
library(lme4)

## check current directory
getwd()

## set working directory
#setwd("c:/Users/windows_name/Downloads/pelatihan-2020-metal-master") #check your path especially for this user windows_name


# input and build model
## input data
### offline >> local directory
metal_data <- read_excel("Data_2020__AMP_broiler.xlsx")
### online >> github
get_url <- curl("https://raw.githubusercontent.com/mohammad-miftakhus-sholikin/pelatihan-2020-metal/master/Data_2020__AMP_broiler.csv")
metal_data <- read.csv(get_url, sep = ",", dec = ".")

## model
### linear and linear mixed model
lm_1 <- lm(bw ~ scale(level), data=metal_data)
lm_2 <- lmer(bw ~ scale(level) + (1|study), data=metal_data)

### linear mixed model: ord1 and ord2
lm_ord1 <- lmer(bw ~ scale(level) + (1|study), data=metal_data)
lm_ord2 <- lmer(bw ~ scale(level) + I((scale(level))^2) + (1|study), data=metal_data)

### linear mixed model: ord1 and ord2 with weight option
lm_ord1 <- lmer(bw ~ scale(level) + (1|study), weights = ~ I(1/b), data=metal_data)
lm_ord2 <- lmer(bw ~ scale(level) + I((scale(level))^2) + (1|study), weights = ~ I(1/b), data=metal_data)

## validation
### BIC and AIC value
BIC(lm_1, lm_2)
AIC(lm_1, lm_2)

## summary of the model
summary(lm_lm1)
summary(lm_lm2)
summary(lm_ord1)
summary(lm_ord2)
