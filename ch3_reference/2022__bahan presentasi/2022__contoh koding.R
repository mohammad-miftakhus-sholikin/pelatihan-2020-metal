# Plugin
library(readxl)
library(xlsx)
library(nlme)
library(sjstats)

## Input data
data_metal = read_excel("nama_file_data.xlsx", sheet="nama_sheet_data")

# Analisis
contoh_lmm <- lme(fcr ~ level, random=list(~1|studi), na.action=na.exclude, data=contoh_data)

# Hasil
# Koefisien lmm
summary(contoh_lmm)
# R kuadrat
performance::r2(contoh_lmm)