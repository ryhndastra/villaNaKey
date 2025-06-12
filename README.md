# 🏡 Villa Na Key – Aplikasi Reservasi Villa Pribadi

![Villa Na Key Logo](assets/images/logoya.png) <!-- Ganti dengan path logo kamu -->

**Villa Na Key** adalah aplikasi mobile eksklusif untuk reservasi **satu villa pribadi**, dirancang khusus untuk memberikan kemudahan dan kenyamanan dalam proses pemesanan. Dengan tampilan elegan dan fitur modern, pengguna dapat memesan vila dengan mudah langsung dari ponsel mereka.

---

## ✨ Fitur Utama

- 📅 Pilih tanggal check-in & check-out melalui kalender interaktif
- 🔐 Registrasi dan login dengan OTP melalui Gmail
- 📄 Lihat detail reservasi & histori pemesanan
- 🚫 Blokir otomatis tanggal yang sudah dipesan
- 🧍 Manajemen data pengguna (nama, kontak, dsb.)
- 📶 Deteksi status koneksi internet (offline/online)
- ⏳ Skeleton loader saat data sedang dimuat

---

## 🛠️ Teknologi yang Digunakan

| Teknologi     | Deskripsi                                  |
|---------------|---------------------------------------------|
| **Flutter**   | Framework UI multiplatform (Android/iOS)    |
| **Firebase**  | Authentication, Firestore, Cloud Functions  |
| **Provider**  | State management & data caching             |
| **Shimmer**   | Skeleton loader animasi loading             |
| **TableCalendar** | Widget kalender untuk pemesanan         |

---

## 📂 Struktur Proyek

lib/
├── pages/             # Tampilan halaman utama
├── models/            # Model data (User, Reservasi)
├── services/          # Integrasi Firebase
├── providers/         # State management (Provider)
├── widgets/           # Komponen UI reusable
└── main.dart          # Entry point aplikasi

---

## 📄 Lisensi
MIT License © 2025 [Reyhand,Naufal]
Dibuat dengan ❤️ oleh developer Flutter, untuk menghadirkan pengalaman reservasi villa yang eksklusif dan seamless.

---

## 🚀 Cara Menjalankan Aplikasi

```bash
git clone https://github.com/username/villanakey.git
cd villanakey
flutter pub get
flutter run