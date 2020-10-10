#!/usr/bin/Rscript



#Script	: Rscript_2020__Antimicrobial_peptide_metal_broiler_kualitatif
#Author	: Mohammad Miftakhus Sholikin
#Analy.	: Meta-Analisis
#Date   : 10-Okt-2020



####################################################INITIALIZE####################################################
## Instalasi program tambahan "tanda '#' menyebabkan baris kode tidak dieksekusi/dijalankan di r console atau biasa disebut dengan komen".
wants <- c("readxl", "xlsx", "tidyverse", "reshape2", "broom", "nlme", "lme4", "DescTools", "lmerTest", "lsmeans", 
           "multcomp", "multcompView")
has <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## Memanggil program tambahan yang digunakan.
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
## Memasukkan data dari file .xlsx sesuai dengan nama dan sheet ke-i (jangan lupa menambahakan quote "").
data_metal = read_excel("Data_2019__Antimicrobial_peptide_metal_broiler.xlsx", sheet = "AMP_invivo_awal_input")

## Melakukan editing data, kolom berapakah output (y/parameter) berada, lihat kembali file .xlsx.
head_table_metal = names(data_metal)[c(17:172)]

#1. Kolom ke-i dimana output dimulai sebagai 1 samapai kolom terakhir misal 156
head_table_metal_qual_model = head_table_metal[c(1:156)]

#2. Ini adalah
head_table_metal_qual_model = head_table_metal[c(1:14, 22, 25:27, 30, 34, 36, 40, 42, 44, 46, 48, 50:55, 57, 60:64, 66:78, 80:96, 98:109, 111:113, 118:119, 121:134, 139:141, 153)]

#3. Isikan dnegan sifat kualitatif yang ingin dianalisis, si sini saya menggunakan "purity" lihat data
mean_data_metal_awal = data_metal[c(5)]

#4. Isikan kolom sesuai dengan no 1. c(1 ... 156)
data_metal_yvalue = data_metal[c(17:172)]

#5. Isikan kolom sesuai dengan no 2. c(1 ... 153)
mean_data_metal_awal = data.frame(mean_data_metal_awal, data_metal_yvalue[c(1:14, 22, 25:27, 30, 34, 36, 40, 42, 44, 46, 48, 50:55, 57, 60:64, 66:78, 80:96, 98:109, 111:113, 118:119, 121:134, 139:141, 153)])



####################################################ANALYSIS####################################################
## Ekstrak nilai-nilai ordo 2
# Ringkasan ANOVA; lihat kembali bahwa purity merupakan sifat kualitatif yang saya dianalisis dan efek randomnya adalah study.
func_models_metal_qual_model = function(response) {
  form = paste(response, "~ purity + (1|study)") #ganti dengan sifat kualitatif lainnya "purity"
  lmer(as.formula(form), REML = FALSE, data = data_metal)
}
models_metal_qual = head_table_metal_qual_model %>%
  map(func_models_metal_qual_model)

# Analisis post hoc
func_post_hoc_model_metal = function(response) {
  cld(lsmeans(response,"purity")) #ganti dengan sifat kualitatif lainnya "purity"
}

# Ringkasan ANOVA
anova_model_metal_qual = melt(lapply(models_metal_qual, anova))
anova_model_metal_qual = data.table::dcast(anova_model_metal_qual, L1 ~ variable)

# Ringkasan post hoc
post_hoc_model_metal_qual = reshape2::melt(lapply(models_metal_qual, func_post_hoc_model_metal))
post_hoc_model_metal_qual = data.table::dcast(post_hoc_model_metal_qual, L1 + purity + .group ~ variable) #ganti dengan sifat kualitatif lainnya "purity"
post_hoc_model_metal_qual = post_hoc_model_metal_qual[c(1:3)]
post_hoc_model_metal_qual = data.table::dcast(post_hoc_model_metal_qual, L1 ~ purity) #ganti dengan sifat kualitatif lainnya "purity"

## Rataan data
mean_data_metal = mean_data_metal_awal %>% 
  group_by(purity) %>%
  summarise_each(funs(mean(., na.rm = TRUE), sd(., na.rm = TRUE)))
mean_data_metal = reshape2::melt(mean_data_metal, id=c("purity")) #ganti dengan sifat kualitatif lainnya "purity"
mean_data_metal = data.table::dcast(mean_data_metal, variable ~ purity)
View(mean_data_metal)

## Tabel
table_qual <- data.frame(mean_data_metal, anova_model_metal_qual, post_hoc_model_metal_qual)



####################################################OUPUT####################################################
## Menyimpan hasil analisis
write.xlsx(table_qual, file="Transition_2019_Antimicrobial_peptide_metal_broiler.xlsx", sheetName="table_qual", append=TRUE)
