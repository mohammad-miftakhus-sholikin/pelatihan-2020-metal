# Pelatihan Meta-Analisis Menggunakan R

# A. Instalasi R
1. Download di [**sini**](https://cran.r-project.org/bin/windows/base/R-4.0.2-win.exe) atau pergi kelaman [**ini**](https://cran.r-project.org/bin/windows/base/). (**NB: file rada gede gan 80an MB**)
2. Lakukan instalasi pada umumnya (pergi ke folder download -> klik dua kali file instaler -> ikuti petunjuk).

   ![Cara install](images/cara-install-r-windows.gif)

3. Kalau udah kelar coba cari di start menu ketikan **r** atau cari saja scrolling.

# B. Install packages yang dibutuhkan buat metal
1. Lihat dulu tampilan program R nya.

   ![R interface](images/rconsole.png)

2. Di R console ketikan perintah berikut, "*bagian yang merah*".
```r
install.packages("lme4")
install.packages("readxl")
```