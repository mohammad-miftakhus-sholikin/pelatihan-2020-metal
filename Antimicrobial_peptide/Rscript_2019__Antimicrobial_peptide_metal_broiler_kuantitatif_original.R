#!/usr/bin/Rscript



#Script	: Rscript_2020__Antimicrobial_peptide_metal_broiler_kuantitatif
#Author	: Mohammad Miftakhus Sholikin
#Analy.	: Meta-Analisis
#Date   : 29-Mei-2020



####################################################INITIALIZE####################################################
## Library
wants <- c("readxl", "xlsx", "reshape2", "data.table", "tidyverse", "nlme", "ggplot2")
has <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

library(readxl)
library(xlsx)
library(reshape2)
library(data.table)
library(tidyverse)
library(nlme)
library(ggplot2)



####################################################EDITDATA####################################################
## Input data
data_metal = read_excel("Data_2019__Antimicrobial_peptide_metal_broiler.xlsx", sheet = "AMP_invivo_sekarang_input")

## Edit data
head_table_metal = names(data_metal)[c(17:177)]



###################################################GRAPH####################################################
# # Set graph
# func_plot_metal = function(x, y) {
#   ggplot(data_metal, aes(x = .data[[x]], y = .data[[y]]) ) +
#     geom_point() +
#     theme_minimal() +
#     labs(x = x,
#          y = y)
# }
# 
# elev_plots = map(head_table_metal, ~func_plot_metal("level", .x) )
# elev_plots



####################################################ANALYSIS####################################################
## Build model ord 1
#head_table_metal_or1 = head_table_metal[c(1:38, 40:67, 70, 73:96, 98:117, 119:154, 156)] # data_awal
#head_table_metal_or1 = head_table_metal[c(1:10, 12:20, 22, 24:25, 27, 30, 34:38, 40, 42, 46:47, 51:68, 70, 73:82, 84:87, 89:96, 98:109, 113:117, 119:153, 156)] # data_sekarang
head_table_metal_or1 = head_table_metal[c(1:20, 22, 24:25, 27, 30, 34:38, 40, 42, 46:47, 51:87, 89:96, 98:109, 113:161)]
func_models_metal_ord1 = function(response) {
  form = paste(response, "~ lvl")
  lme(as.formula(form), random = list(~1|study), na.action=na.exclude, method ="ML", data = data_metal) #random = list(~1|study, ~1|sx), weights = varIdent(form=~pty|brl
}

models_metal_ord1 = head_table_metal_or1 %>%
  map(func_models_metal_ord1)

## Build model ord 2
#head_table_metal_or2 = head_table_metal[c(1:36, 38, 40:68, 70, 74:96, 98:113, 124, 126, 133:134, 139:141, 143, 148)] # data_awal
#head_table_metal_or2 = head_table_metal[c(1:6, 8:10, 13, 15:20, 22, 24:25, 27, 30, 34:36, 38, 40, 42, 46, 51:68, 70, 74:82, 84:87, 89:96, 98:99, 101:102, 104:105, 107:109, 119, 124, 126:134, 139, 140:141, 143, 148)] # data_sekarang
head_table_metal_or2 = head_table_metal[c(1:20, 22, 24:25, 27, 30, 34:36, 38, 40, 42, 46:47, 51:82, 84:87, 89:96, 118:119, 121:134, 139:141, 143, 146, 148, 153, 155, 157:161)]
func_models_metal_ord2 = function(response) {
  form = paste(response, "~ (lvl + I(lvl^2))")
  lme(as.formula(form), random = list(~1|study), na.action=na.exclude, method ="ML", data = data_metal) #random = list(~1|study, ~1|sx), weights = varIdent(form=~pty|brl
}

models_metal_ord2 = head_table_metal_or2 %>%
  map(func_models_metal_ord2)



####################################################EXTRACTORD1####################################################
## Ekstrak nilai-nilai ord1
# summary
sums_metal = lapply(models_metal_ord1, summary)
# koefisien
coefs_metal = reshape2::melt(lapply(sums_metal, coefficients))
coefs_metal = data.table::dcast(coefs_metal, coefs_metal[[4]] + coefs_metal[[1]] ~ coefs_metal[[2]])
# jumlah observasi
nobs_metal = t(as.data.frame(lapply(models_metal_ord1, nobs)))
# rmse
# fungsi pemanggil rmse
rmse_metal_func <- function(var) {
  sqrt(mean(var$residuals^2))
}
# nilai rmse
rmse_metal = t(as.data.frame(lapply(sums_metal, rmse_metal_func)))
# AIC
AIC_metal = t(as.data.frame(lapply(models_metal_ord1, AIC)))
# BIC
BIC_metal = t(as.data.frame(lapply(models_metal_ord1, BIC)))
## Tabel
table_coef_metal_ord1 <- data.frame(coefs_metal)
table_coef_metal_ord1 <- data.table::dcast(setDT(table_coef_metal_ord1), coefs_metal..4.. ~ coefs_metal..1.., value.var=c('Value', 'Std.Error', 'Std.Error', 'p.value', 't.value', 'DF'))
table_valid_metal_ord1 <- data.frame(head_table_metal_or1, rmse_metal, nobs_metal, AIC_metal, BIC_metal)
table_ord1 <- data.frame(table_valid_metal_ord1, table_coef_metal_ord1)
# View(table_ord1)



####################################################EXTRACTORD2####################################################
## Ekstrak nilai-nilai ord2
# summary
sums_metal = lapply(models_metal_ord2, summary)
# koefisien
coefs_metal = reshape2::melt(lapply(sums_metal, coefficients))
coefs_metal = data.table::dcast(coefs_metal, coefs_metal[[4]] + coefs_metal[[1]] ~ coefs_metal[[2]])
# jumlah observasi
nobs_metal = t(as.data.frame(lapply(models_metal_ord2, nobs)))
# rmse
# fungsi pemanggil rmse
rmse_metal_func <- function(var) {
  sqrt(mean(var$residuals^2))
}
# nilai rmse
rmse_metal = t(as.data.frame(lapply(sums_metal, rmse_metal_func)))
# AIC
AIC_metal = t(as.data.frame(lapply(models_metal_ord2, AIC)))
# BIC
BIC_metal = t(as.data.frame(lapply(models_metal_ord2, BIC)))
## Tabel
table_coef_metal_ord2 <- data.frame(coefs_metal)
table_coef_metal_ord2 <- data.table::dcast(setDT(table_coef_metal_ord2), coefs_metal..4.. ~ coefs_metal..1.., value.var=c('Value', 'Std.Error', 'p.value', 't.value', 'DF'))
table_valid_metal_ord2 <- data.frame(head_table_metal_or2, rmse_metal, nobs_metal, AIC_metal, BIC_metal)
table_ord2 <- data.frame(table_valid_metal_ord2, table_coef_metal_ord2)
# View(table_ord2)

  

####################################################OUTPUT####################################################
## Export
write.xlsx(table_ord1, file="Transition_2019__Antimicrobial_peptide_metal_broiler.xlsx", sheetName="table_ord1", append=TRUE)
write.xlsx(table_ord2, file="Transition_2019__Antimicrobial_peptide_metal_broiler.xlsx", sheetName="table_ord2", append=TRUE)
