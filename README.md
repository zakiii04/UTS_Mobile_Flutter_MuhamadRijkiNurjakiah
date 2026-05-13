# 🛒 Tokopadia - Aplikasi Mobile Flutter

## 📱 Tentang Aplikasi

**Tokopadia** adalah aplikasi e-commerce mobile yang dibangun menggunakan **Flutter**.
Aplikasi ini menampilkan daftar produk elektronik dengan fitur autentikasi, profil pengguna yang dapat diedit, serta navigasi antar halaman yang lengkap dan interaktif.

---

# ✅ Fitur & Penjelasan (Sesuai Soal UTS)

---

## 🔐 Halaman Login

Halaman pertama yang muncul setelah splash screen untuk autentikasi pengguna.

### ✨ Fitur

* Input Email & Password
* Validasi format email dan password
* Link menuju halaman daftar/register
* SnackBar notifikasi login berhasil atau gagal

### ✅ Validasi

* Email wajib menggunakan format valid (`@`)
* Password minimal 6 karakter

### 📸 Screenshot

<img width="499" height="601" alt="Halaman Login" src="https://github.com/user-attachments/assets/284dfd0c-e52b-49a7-8c5c-ff9ac8c60098" />

<img width="496" height="605" alt="Verifikasi Login 2" src="https://github.com/user-attachments/assets/e325222d-2c19-45a1-8361-0bb021dfa06c" />

---

## 🧭 Routing & Navigator

Implementasi navigasi antar halaman yang aman dan terorganisir.

### 📌 Routes

* `/splash`
* `/login`
* `/register`
* `/home`
* `/profile`

### ⚙️ Logic

Menggunakan `pushNamedAndRemoveUntil` setelah login agar pengguna tidak bisa kembali ke halaman login menggunakan tombol back.

---

## 📦 ListView & Data Dummy

Menampilkan katalog produk secara dinamis di halaman utama.

### ✨ Widget Yang Digunakan

* `ListView.builder`
* `GridView`
* `Card`
* `Container`

### 🎯 Interaksi

Pengguna dapat menekan produk untuk melihat halaman detail produk lengkap.

### 📸 Screenshot

<img width="496" height="602" alt="Home 1" src="https://github.com/user-attachments/assets/e5e768d7-6beb-4543-af86-ea18d6c22090" />

<img width="499" height="603" alt="Home 2" src="https://github.com/user-attachments/assets/ca7c43e2-ade1-4b2e-b739-b7aeeb9c6db5" />

<img width="494" height="597" alt="detail produk" src="https://github.com/user-attachments/assets/4af62ef6-ab75-4b3e-9552-d0e7355957f2" />

---

## 👤 CRUD Profile

Halaman profil yang memungkinkan pengguna mengelola informasi pribadi.

### ✨ Fitur

* Menampilkan data profile
* Edit profile pengguna
* Tombol Simpan dan Batal
* Sinkronisasi data menggunakan Provider

### 📋 Data Yang Dikelola

* Nama
* Email
* Nomor HP
* Alamat

### 📸 Screenshot

<img width="499" height="608" alt="halaman profile edit profile" src="https://github.com/user-attachments/assets/ca921dd6-fe67-408a-b01b-eb3780321a2f" />

---

## 🚪 Logout, State Management & UI/UX

Fitur tambahan untuk meningkatkan pengalaman pengguna aplikasi.

### ✨ Fitur

* Dialog konfirmasi logout
* State management menggunakan Provider
* Desain modern dengan tema putih & hijau
* Animasi transisi halaman
* UI clean dan responsive

### 📸 Screenshot

<img width="494" height="604" alt="logout" src="https://github.com/user-attachments/assets/aaeeb7c9-907e-4540-9218-b990d1caa883" />

---

# 📂 Struktur Project

```text
lib/
├── data/           # Data dummy produk
├── models/         # Model data (Product, User)
├── pages/          # Semua halaman aplikasi
├── providers/      # State management
├── themes/         # Tema & warna aplikasi
├── widgets/        # Komponen UI reusable
└── main.dart       # Entry point & routing
```

---

# 🛠️ Teknologi Yang Digunakan

* Flutter
* Dart
* Provider
* Material Design
* Navigator

---

# ☁️ Google Drive Project

📁 Link Google Drive:
https://drive.google.com/drive/folders/1Q4B7lAynqGCwnafX72gAYQ9ydL0Jl415?usp=sharing

Isi folder:

* Source Code
* APK Project
* Screenshots
* Dokumentasi Tambahan

---

<p align="center">© 2026 Muhamad Rijki Nurjakiah</p>
