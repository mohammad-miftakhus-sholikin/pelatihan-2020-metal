#!/usr/bin/Rscript


#Script	: Script_2020_Latihan
#Author	: Mohammad Miftakhus Sholikin
#Descr.	: Effect of Antimicrobial Peptide on Broiler Performance: Linear and Linear Mixed Model Evaluation
#Date   : 12-Mei-2020

  

#check library
if(!require('pacman'))install.packages('pacman')
pacman::p_load(RCurl,lme4)

# input library
library(RCurl)
library(readxl)
library(lme4)
#library(nlme)



# input data
#offline >> local directory
#metal_data <- read_excel("Data_2020__AMP_broiler.xlsx")
#online >> github
get_url <- getURL("https://raw.githubusercontent.com/mohammad-miftakhus-sholikin/0_2020__Modelling_Database/master/Data_2019__AMP_invivo_broiler_ver1.csv")
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