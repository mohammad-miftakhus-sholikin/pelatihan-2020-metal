# Pelatihan Meta-Analisis Menggunakan R

# A. Instalasi R
1. Download di [**sini**](https://cran.r-project.org/bin/windows/base/R-4.0.2-win.exe) atau pergi kelaman [**ini**](https://cran.r-project.org/bin/windows/base/). (**NB: file rada gede gan 80an MB**)
2. Lakukan instalasi pada umumnya (pergi ke folder download -> klik dua kali file instaler -> ikuti petunjuk).

   ![cara install](images/cara-install-r-windows.gif)

3. Kalau udah kelar coba cari di start menu ketikan **r** atau cari saja scrolling.

# B. Install packages yang dibutuhkan buat metal
1. Lihat dulu tampilan program r nya.

   ![r interface](images/rconsole.png)

   ini tanda klo r console siap diberikan perintah.
   ```r
   >
   ```

2. Di R console ketikan perintah berikut dan klik enter, "*bagian yang merah*".
   ```r
   install.packages("RCurl"); install.packages("lme4"); install.packages("readxl")
   ```
3. Kalo lancar pasti gak ada error. Coba cek scroll ke atas.
   
   ini contoh selesai install
   ```
   dst. dst.
   * DONE(RCurl)
   
   dst. dst.
   * DONE(lme4)

   dst. dst.
   * DONE(readxl)
   ```
   ini contoh eror 
   ```r
   Error in install.packages :
   ```

# C. 