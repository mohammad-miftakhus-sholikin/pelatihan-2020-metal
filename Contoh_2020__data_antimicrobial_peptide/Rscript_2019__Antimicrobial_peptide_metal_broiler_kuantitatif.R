#!/usr/bin/Rscript



#Script	: Rscript_2020__Antimicrobial_peptide_metal_broiler_kuantitatif
#Author	: Mohammad Miftakhus Sholikin
#Analy.	: Meta-Analisis
#Date   : 10-Okt-2020



####################################################INITIALIZE####################################################
## Instalasi program tambahan "tanda '#' menyebabkan baris kode tidak dieksekusi/dijalankan di r console atau biasa disebut dengan komen".
wants <- c("readxl", "xlsx", "reshape2", "data.table", "tidyverse", "nlme", "ggplot2")
has <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## Memanggil program tambahan yang digunakan.
library(readxl)
library(xlsx)
library(reshape2)
library(data.table)
library(tidyverse)
library(nlme)
library(ggplot2)



####################################################EDITDATA####################################################
## Memasukkan data dari file .xlsx sesuai dengan nama dan sheet ke-i (jangan lupa menambahakan quote "").
data_metal = read_excel("Data_2019__Antimicrobial_peptide_metal_broiler.xlsx", sheet = "AMP_invivo_sekarang_input")

## Melakukan editing data, kolom berapakah output (y/parameter) berada, lihat kembali file .xlsx.
head_table_metal = names(data_metal)[c(17:177)]

# ordo 1; cari output yang bisa dianalisis dengan syarat: (1)>1 studi/eksperimen, (2) bukan data penggandaan/duplikasi, 
#(3) nomor ini merupakan nomor dari kolom pertama output sampai kolom terakhir output.
head_table_metal_or1 = head_table_metal[c(1:20, 22, 24:25, 27, 30, 34:38, 40, 42, 46:47, 51:87, 89:96, 98:109, 113:161)]

# ordo 2; lakukan cara yang sama dengan langkah sebelumnya.
head_table_metal_or2 = head_table_metal[c(1:20, 22, 24:25, 27, 30, 34:36, 38, 40, 42, 46:47, 51:82, 84:87, 89:96, 118:119, 121:134, 139:141, 143, 146, 148, 153, 155, 157:161)]


####################################################ANALYSIS####################################################
## Membuat model ord 1; lihat kembali bahwa level yang saya gunakan ada di kolom lvl dan efek randomnya adalah study.
func_models_metal_ord1 = function(response) {
  form = paste(response, "~ lvl")
  lme(as.formula(form), random = list(~1|study), na.action=na.exclude, method ="ML", data = data_metal) #random = list(~1|study, ~1|sx), weights = varIdent(form=~pty|brl
}

models_metal_ord1 = head_table_metal_or1 %>%
  map(func_models_metal_ord1)

## Membuat model ordo 2; karena ini ordo 2 maka modelnya adalah y = ax^2 + bx + c jadi lvlnya dikuadratkan.
func_models_metal_ord2 = function(response) {
  form = paste(response, "~ (lvl + I(lvl^2))")
  lme(as.formula(form), random = list(~1|study), na.action=na.exclude, method ="ML", data = data_metal) #random = list(~1|study, ~1|sx), weights = varIdent(form=~pty|brl
}

models_metal_ord2 = head_table_metal_or2 %>%
  map(func_models_metal_ord2)



####################################################EXTRACTORD1####################################################
## Ekstrak nilai-nilai ordo 1
# Ringkasan ANOVA
sums_metal = lapply(models_metal_ord1, summary)

# Koefisien
coefs_metal = reshape2::melt(lapply(sums_metal, coefficients))
coefs_metal = data.table::dcast(coefs_metal, coefs_metal[[4]] + coefs_metal[[1]] ~ coefs_metal[[2]])

# Jumlah observasi
nobs_metal = t(as.data.frame(lapply(models_metal_ord1, nobs)))

# RMSE
# Fungsi pemanggil RMSE
rmse_metal_func <- function(var) {
  sqrt(mean(var$residuals^2))
}
# Nilai RMSE
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
View(table_ord1)



####################################################EXTRACTORD2####################################################
## Ekstrak nilai-nilai ordo 2
# Ringkasan ANOVA
sums_metal = lapply(models_metal_ord2, summary)

# Koefisien
coefs_metal = reshape2::melt(lapply(sums_metal, coefficients))
coefs_metal = data.table::dcast(coefs_metal, coefs_metal[[4]] + coefs_metal[[1]] ~ coefs_metal[[2]])

# Jumlah observasi
nobs_metal = t(as.data.frame(lapply(models_metal_ord2, nobs)))

# RMSE
# Fungsi pemanggil RMSE
rmse_metal_func <- function(var) {
  sqrt(mean(var$residuals^2))
}

# Nilai RMSE
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
View(table_ord2)

  

####################################################OUTPUT####################################################
## Menyimpan hasil analisis
write.xlsx(table_ord1, file="Transition_2019__Antimicrobial_peptide_metal_broiler.xlsx", sheetName="table_ord1", append=TRUE)
write.xlsx(table_ord2, file="Transition_2019__Antimicrobial_peptide_metal_broiler.xlsx", sheetName="table_ord2", append=TRUE)
