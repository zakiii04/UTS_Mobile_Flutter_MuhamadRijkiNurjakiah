# Tokopadia - Aplikasi Mobile Flutter

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/VS_Code-007ACC?style=for-the-badge&logo=visual-studio-code&logoColor=white" alt="VS Code">
</p>

---

## 📋 Identitas Mahasiswa

| Detail | Informasi |
| :--- | :--- |
| **Nama** | Muhamad Rijki Nurjakiah |
| **NIM** | 2306044 |
| **Kelas** | IF - B |
| **Mata Kuliah** | Praktikum Pemrograman Mobile (IFP44114) |
| **Dosen** | Egi Budiman, S.T., M.Kom. |
| **Institusi** | Institut Teknologi Garut |

---

## 📱 Tentang Aplikasi

**Tokopadia** adalah aplikasi e-commerce mobile yang dibangun menggunakan **Flutter**. Aplikasi ini menampilkan daftar produk elektronik dengan fitur autentikasi, profil pengguna yang dapat diedit, serta navigasi antar halaman yang lengkap dan interaktif.

---

## ✅ Fitur & Penjelasan (Sesuai Soal UTS)

### Soal 1 — Halaman Login
Halaman pertama yang muncul (setelah splash screen) untuk autentikasi pengguna.
- **Fitur:** Input Email & Password, Validasi format, Link Daftar.
- **Validasi:** Email harus ada '@', Password min 6 karakter.
- **Feedback:** SnackBar muncul jika login sukses/gagal.

**Screenshot:**
![Login Page](https://via.placeholder.com/300x600?text=Screenshot+Login+Page)

---

### Soal 2 — Routing & Navigator
Implementasi navigasi antar halaman yang aman dan terorganisir.
- **Routes:** `/splash`, `/login`, `/register`, `/home`.
- **Logic:** Menggunakan `pushNamedAndRemoveUntil` setelah login agar user tidak bisa kembali ke halaman login via tombol back.

---

### Soal 3 — ListView & Data Dummy
Menampilkan katalog produk secara dinamis di halaman utama.
- **Widget:** `ListView.builder` (Horizontal untuk kategori) & `GridView` (untuk produk).
- **Interaksi:** Klik produk untuk melihat detail lengkap (Product Detail Page).

**Screenshot:**
![Home Page](https://via.placeholder.com/300x600?text=Screenshot+Home+Page)

---

### Soal 4 — CRUD Profile
Halaman profil yang memungkinkan pengguna untuk mengelola informasi pribadi mereka.
- **Read:** Menampilkan data Nama, Email, HP, dan Alamat.
- **Update:** Fitur edit data dengan tombol Simpan dan Batal.
- **Logic:** Data tersinkronisasi menggunakan state management Provider.

**Screenshot:**
![Profile Page](https://via.placeholder.com/300x600?text=Screenshot+Profile+Page)

---

### Soal 5 — Logout, State Management & UI/UX
Polesan akhir untuk memberikan pengalaman pengguna yang premium.
- **Logout:** Dialog konfirmasi kustom sebelum keluar.
- **State Management:** Implementasi **Provider** untuk konsistensi data.
- **Aesthetics:** Desain modern "Putih & Hijau", Animasi transisi, dan Glassmorphism.

**Screenshot:**
![Logout Dialog](https://via.placeholder.com/300x600?text=Screenshot+Logout+Dialog)

---

## 📂 Struktur Project

```text
lib/
├── data/           # Data dummy produk
├── models/         # Model data (Product, User)
├── pages/          # Semua halaman (Login, Home, Profile, dll)
├── providers/      # Logika State Management (Auth, Product)
├── themes/         # Konfigurasi tema & warna
├── widgets/        # Komponen UI reusable (Button, Dialog, Card)
└── main.dart       # Entry point & Routing
```

---

## 🔗 Link Google Drive

Akses source code lengkap dan dokumentasi pendukung melalui link berikut:
👉 [Link Google Drive - Muhamad Rijki Nurjakiah](https://drive.google.com/drive/folders/1Q4B7lAynqGCwnafX72gAYQ9ydL0Jl415?usp=sharing)

---
<p align="center">© 2026 Muhamad Rijki Nurjakiah</p>