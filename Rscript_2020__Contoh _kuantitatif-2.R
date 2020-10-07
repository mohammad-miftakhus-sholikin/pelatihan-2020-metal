#!/usr/bin/Rscript


#Script	: Rscript_2020__Contoh _kuantitatif-1
#Author	: Mohammad Miftakhus Sholikin
#Descr.	: Effect of Antimicrobial Peptide on Broiler Performance: Linear Model and Linear Mixed Model Evaluation
#Date   	: 08-Oktober-2020


  

#check library
if(!require('pacman'))install.packages('pacman')
pacman::p_load(RCurl,lme4)

# input library
library(RCurl)
library(readxl)
library(lme4)
#library(nlme)


# check current directory
getwd()
setwd("c:/Users/windows_name/Downloads/pelatihan-2020-metal-master") #check your path especially for this user windows_name

# input data
#offline >> local directory
metal_data <- read_excel("Data_2020__AMP_broiler.xlsx")

#online >> github
get_url <- getURL("https://raw.githubusercontent.com/mohammad-miftakhus-sholikin/pelatihan-2020-metal/master/Data_2020__AMP_broiler.csv")
metal_data <- read.csv(text=get_url, sep = ",", dec = ".")

# linear and linear mixed model
lm_1 <- lm(bw ~ scale(level), data=metal_data)
lm_2 <- lm(bw ~ scale(level) + peptide, data=metal_data)
lm_3 <- lm(bw ~ scale(level) + peptide + treatment, data=metal_data)
lm_4 <- lm(bw ~ scale(level) + peptide + treatment + broiler, data=metal_data)
lm_5 <- lm(bw ~ scale(level) + peptide + treatment + broiler + study, data=metal_data)
lm_6 <- lmer(bw ~ scale(level) + (1|peptide), data=metal_data)
lm_7 <- lmer(bw ~ scale(level) + (1|peptide) + (1|treatment), data=metal_data)
lm_8 <- lmer(bw ~ scale(level) + (1|peptide) + (1|treatment) + (1|broiler), data=metal_data)
lm_9 <- lmer(bw ~ scale(level) + (1|peptide) + (1|treatment) + (1|broiler) + (1|study), data=metal_data)
lm_10 <- lmer(bw ~ scale(level) + (1|peptide) + (1|treatment) + (1|broiler) + (1|study) + (1|broiler:treatment:study), data=metal_data)



# BIC
BIC(lm_1, lm_2, lm_3, lm_4, lm_5, lm_6, lm_7, lm_8, lm_9, lm_10)
