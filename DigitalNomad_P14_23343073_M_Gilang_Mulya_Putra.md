# Ringkasan Analitis Keamanan Mobile

**Disusun oleh:** M. Gilang Mulya Putra (23343073)

## Sumber 1: Engineering Blog (Gojek Tech - "Securing Mobile Applications at Scale")
* **Temuan Utama:** Gojek menekankan bahwa mengamankan aplikasi bukan hanya soal enkripsi data, melainkan *defense in depth* (pertahanan berlapis). Mereka menggarisbawahi pentingnya mendeteksi *environment* perangkat (apakah di-*root* atau *jailbreak*) dan mencegah *reverse engineering* pada kode sumber.
* **Relevansi untuk Flutter:** Sangat relevan karena aplikasi Flutter mudah di-*decompile* jika tidak diproteksi, yang bisa mengekspos *logic* bisnis di dalam Dart *Isolates* atau *ViewModels*.
* **Rekomendasi Implementasi:** Selalu gunakan argumen --obfuscate dan --split-debug-info saat melakukan *build release* APK/AAB di Flutter agar struktur kode menjadi tidak terbaca oleh peretas.

## Sumber 2: Laporan Keamanan Global (OWASP Mobile Top 10 - 2024)
* **Temuan Utama:** Kerentanan M1 (Penggunaan Kredensial yang Buruk) dan M2 (Ketidakamanan Rantai Pasok) menduduki peringkat teratas. Banyak aplikasi membocorkan kunci API (*API Keys*) secara *hardcoded* di dalam kode.
* **Relevansi untuk Flutter:** Pengembang Flutter sering kali tidak sengaja memasukkan token API atau kredensial Firebase langsung ke dalam file .dart dan mengunggahnya ke GitHub publik.
* **Rekomendasi Implementasi:** Terapkan file .env menggunakan *package* lutter_dotenv dan wajib memasukkannya ke dalam .gitignore, sehingga kunci rahasia tidak pernah terekam di repositori.
