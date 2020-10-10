#!/usr/bin/Rscript



#Script	: Rscript_2020__Antimicrobial_peptide_metal_broiler_kualitatif
#Author	: Mohammad Miftakhus Sholikin
#Analy.	: Meta-Analisis
#Date   : 29-Mei-2020



####################################################INITIALIZE####################################################
## Library
wants <- c("readxl", "xlsx", "tidyverse", "reshape2", "broom", "nlme", "lme4", "DescTools", "lmerTest", "lsmeans", 
           "multcomp", "multcompView")
has <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

library(readxl)
library(xlsx)
library(tidyverse)
library(reshape2)
library(broom)
library(nlme)
library(lme4)
library(DescTools)
library(lmerTest)
library(lsmeans)
library(multcomp)
library(multcompView)



####################################################EDITDATA####################################################
## Input data
data_metal = read_excel("Data_2019__Antimicrobial_peptide_metal_broiler.xlsx", sheet = "AMP_invivo_awal_input")

## Edit data
head_table_metal = names(data_metal)[c(17:172)]
head_table_metal_qual_model = head_table_metal[c(1:156)]
head_table_metal_qual_model = head_table_metal[c(1:14, 22, 25:27, 30, 34, 36, 40, 42, 44, 46, 48, 50:55, 57, 60:64, 66:78, 80:96, 98:109, 111:113, 118:119, 121:134, 139:141, 153)]
mean_data_metal_awal = data_metal[c(5)]
data_metal_yvalue = data_metal[c(17:172)]
mean_data_metal_awal = data.frame(mean_data_metal_awal, data_metal_yvalue[c(1:14, 22, 25:27, 30, 34, 36, 40, 42, 44, 46, 48, 50:55, 57, 60:64, 66:78, 80:96, 98:109, 111:113, 118:119, 121:134, 139:141, 153)])



####################################################ANALYSIS####################################################
## Anova and post hoc
# Anova
func_models_metal_qual_model = function(response) {
  form = paste(response, "~ purity + (1|study)")
  lmer(as.formula(form), REML = FALSE, data = data_metal)
}
models_metal_qual = head_table_metal_qual_model %>%
  map(func_models_metal_qual_model)

# Post hoc
func_post_hoc_model_metal = function(response) {
  cld(lsmeans(response,"purity"))
}

# Summary anova
anova_model_metal_qual = melt(lapply(models_metal_qual, anova))
anova_model_metal_qual = data.table::dcast(anova_model_metal_qual, L1 ~ variable)

# Summary post hoc
post_hoc_model_metal_qual = reshape2::melt(lapply(models_metal_qual, func_post_hoc_model_metal))
post_hoc_model_metal_qual = data.table::dcast(post_hoc_model_metal_qual, L1 + purity + .group ~ variable)
post_hoc_model_metal_qual = post_hoc_model_metal_qual[c(1:3)]
post_hoc_model_metal_qual = data.table::dcast(post_hoc_model_metal_qual, L1 ~ purity)

## Mean data <!-- RUWET -->
mean_data_metal = mean_data_metal_awal %>% 
  group_by(purity) %>%
  summarise_each(funs(mean(., na.rm = TRUE), sd(., na.rm = TRUE)))
mean_data_metal = reshape2::melt(mean_data_metal, id=c("purity"))
mean_data_metal = data.table::dcast(mean_data_metal, variable ~ purity)
View(mean_data_metal)

# Table
table_qual <- data.frame(mean_data_metal, anova_model_metal_qual, post_hoc_model_metal_qual)



####################################################OUPUT####################################################
# Export
write.xlsx(table_qual, file="Transition_2019_Antimicrobial_peptide_metal_broiler.xlsx", sheetName="table_qual", append=TRUE)
write.xlsx(mean_data_metal, file="Transition_2019__Antimicrobial_peptide_metal_broiler", sheetName="table_mean_sd", append=TRUE)
