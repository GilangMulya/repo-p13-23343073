# Security Checklist - P14

- [x] **Secure Storage:** Mengganti penyimpanan *plain-text* dengan enkripsi level OS (lutter_secure_storage).
- [x] **Code Obfuscation:** Menerapkan argumen --obfuscate saat *compile build release*.
- [ ] **SSL Pinning:** Memastikan sertifikat server valid pada layer API untuk mencegah serangan MitM.
- [ ] **Jailbreak/Root Detection:** Menambahkan proteksi *environment* runtime menggunakan package eksternal.
