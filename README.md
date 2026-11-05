# Konsol Otomatis Google AI Pro (5 TB) Gratis Dua Tahun

Konsol web lokal (FastAPI + Playwright) yang mengotomasi alur langganan Google AI Pro (5 TB) per akun: login, penautan kartu, penumpukan paket uji coba gratis (US$0.00 hingga 24 bulan), lalu pembatalan perpanjangan otomatis dan pengambilan tangkapan layar sebagai bukti.

> **Terjemahan bahasa Indonesia** dari proyek [worldonlyu/Google_AI_Pro_2Year_ZeroCost_Auto](https://github.com/worldonlyu/Google_AI_Pro_2Year_ZeroCost_Auto). Seluruh logika otomasi berasal dari repositori tersebut; di sini ditambahkan terjemahan antarmuka, log, dan dokumentasi, serta dukungan Ubuntu/Linux.
>
> Teks Mandarin yang tersisa di kode adalah pencocok halaman Google (`hl=zh-CN`) dan **sengaja tidak diubah** agar otomasi tetap berfungsi.

## ⚠️ Peringatan penting

- Alur ini memodifikasi permintaan pembayaran di halaman Google One dengan token penawaran yang tertanam. Itu **kemungkinan besar melanggar Ketentuan Layanan Google**. Akun dapat diblokir, langganan dapat dibatalkan, dan kartu yang ditautkan dapat bermasalah.
- Hasil "gratis 24 bulan" **tidak dijamin**. Token penawaran dapat dicabut Google kapan saja.
- Gunakan **akun cadangan**, bukan akun utama. Gunakan **kartu virtual dengan limit rendah**, bukan kartu utama.
- Pemakaian sepenuhnya menjadi tanggung jawab Anda. Proyek ini disediakan apa adanya, tanpa jaminan.

## Daftar isi

1. [Persyaratan](#1-persyaratan)
2. [Instalasi dan menjalankan](#2-instalasi-dan-menjalankan)
3. [Konfigurasi](#3-konfigurasi)
4. [Mengimpor akun](#4-mengimpor-akun)
5. [Menjalankan otomasi](#5-menjalankan-otomasi)
6. [Proxy](#6-proxy)
7. [Struktur proyek](#7-struktur-proyek)
8. [Keamanan data](#8-keamanan-data)
9. [Pemecahan masalah](#9-pemecahan-masalah)
10. [Kredit](#10-kredit)

## 1. Persyaratan

| Komponen | Windows 10 / 11 | Ubuntu / Linux |
|---|---|---|
| Python | 3.10 atau lebih baru (centang **Add Python to PATH**) | `sudo apt install python3 python3-venv python3-pip` |
| Browser | Google Chrome di lokasi bawaan | Google Chrome atau Chromium |
| Tampilan | Desktop biasa | Sesi desktop (X11 atau Wayland), karena Chrome tampil di layar |
| Jaringan | IP wilayah AS (VPN atau proxy), atau isi templat proxy | Sama |

Instal Google Chrome di Ubuntu jika belum ada:

```bash
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
```

## 2. Instalasi dan menjalankan

### Windows

1. Pertama kali: klik dua kali **`1_install_dan_jalankan.bat`** (memasang dependensi lalu menjalankan konsol).
2. Selanjutnya: klik dua kali **`2_jalankan_konsol.bat`**.
3. Browser terbuka otomatis ke http://127.0.0.1:8765.

### Ubuntu / Linux

```bash
chmod +x install_and_run.sh run.sh   # jika belum dapat dieksekusi
./install_and_run.sh                 # pertama kali: membuat .venv, memasang dependensi, menjalankan
./run.sh                             # selanjutnya
```

Lalu buka http://127.0.0.1:8765. Path Chrome terdeteksi otomatis. Untuk menentukan sendiri:

```bash
CHROME_PATH=/opt/google/chrome/chrome ./run.sh
```

### Manual (semua sistem)

```bash
python3 -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -r requirements.txt
python app.py
```

> Server hanya mendengarkan `127.0.0.1:8765`, sehingga tidak dapat diakses dari perangkat lain.

## 3. Konfigurasi

Semua pengaturan diisi lewat halaman web di bagian **Konfigurasi Global & Penautan Kartu Bebas Pajak**, lalu klik **💾 Simpan Konfigurasi**. Data disimpan di `config.json` (dibuat otomatis, tidak ikut diunggah ke Git). Contoh struktur ada di `config.example.json`.

| Kolom | Keterangan |
|---|---|
| Wilayah target | Gunakan **US** (zona bebas pajak Oregon, kode pos 97201) |
| Paket yang dijalankan | `pro_2year_zero`: Google AI Pro (5 TB) gratis dua tahun |
| Nomor kartu | Kartu valas Visa / Mastercard, 16 digit. Hanya untuk verifikasi uji coba US$0.00 |
| Masa berlaku | Bulan dan tahun, mis. `08` dan `29` |
| Kode keamanan (CVC) | 3 digit |
| Nama pemegang kartu | Huruf Latin, mis. `BUDI SANTOSO` |
| Alamat, kode pos, negara bagian | Sudah terisi bawaan (`700 SW 5th Ave`, `97201`, `OR`), tidak perlu diubah |
| Templat proxy | Opsional, lihat [bagian Proxy](#6-proxy) |
| Perlindungan Step 5 | Jika aktif, perpanjangan otomatis dibatalkan di Google Play setelah masa 24 bulan tercapai |

**Perlindungan nol biaya:** skrip hanya mengklik tombol berlangganan jika dialog pembayaran menampilkan **US$0.00**. Jika tidak, proses dihentikan dengan pesan *"Perlindungan nol biaya menghentikan proses"*.

## 4. Mengimpor akun

Tempel di kotak **Impor Akun Massal**, **satu akun per baris**, lalu klik **➕ Impor Daftar Akun**.

```text
budi@gmail.com----Sandi123!
siti@gmail.com----Rahasia#456----pemulihan@outlook.com
andi@gmail.com----P4ssw0rd----pemulihan@outlook.com----JBSWY3DPEHPK3PXP
akun-utama----rudi@gmail.com----Sandi789!----JBSWY3DPEHPK3PXP
```

- Kolom setelah sandi boleh dalam urutan bebas, karena dikenali dari bentuknya:
  - mengandung `@` → email pemulihan
  - teks Base32 sepanjang 16 karakter atau lebih (A-Z, 2-7) → kunci 2FA (TOTP)
  - berawalan `http://`, `https://`, `socks5://`, atau berbentuk `IP:port` → proxy khusus akun
- Jika kolom pertama tidak mengandung `@`, ia dipakai sebagai **ID akun** (baris terakhir pada contoh). Tanpa itu, ID otomatis menjadi `Account_1`, `Account_2`, dan seterusnya.
- Pemisah yang didukung: `----` (disarankan), `—`, `|`, `/`, tab, koma, spasi.
- **Gunakan `----` jika sandi mengandung `/`, `|`, koma, atau spasi**, kalau tidak sandi akan terpotong.
- Email yang sama (titik diabaikan) tidak diduplikasi; datanya hanya diperbarui.
- Baris yang kurang dari dua kolom atau tanpa `@` dilewati tanpa pesan error. Periksa jumlahnya di log.

## 5. Menjalankan otomasi

Klik **▶ Jalankan Otomatis** di baris akun, atau **▶ Jalankan Otomatis Semua Akun yang Menunggu** di bagian atas. Alurnya:

| Step | Isi |
|---|---|
| 1 | Login Google, melewati verifikasi email pemulihan / 2FA |
| 2 | Penautan kartu bebas pajak + paket gratis lapisan pertama 12 bulan (US$0.00) |
| 3 | Menumpuk lapisan kedua 6 bulan (US$0.00 → 18 bulan) |
| 4 | Menumpuk lapisan ketiga 6 bulan (US$0.00 → batas 24 bulan) |
| 5 | Membatalkan perpanjangan otomatis di Google Play dan mengambil tangkapan layar bukti |

**Memulai dari langkah tertentu:** pilih langkah di dropdown pada baris akun (atau di dropdown atas untuk semua akun), lalu klik tombol jalankan. Berguna jika proses terhenti di tengah, misalnya "Dari Step 4" bila Step 1 sampai 3 sudah selesai. Kartu wajib terisi untuk Step 1 sampai 4.

**Tombol lain per akun:** 🌐 *Browser* membuka jendela Chrome khusus akun itu secara manual, tombol reset mengembalikan status ke menunggu, tombol hapus menghapus akun, dan *Salin* menyalin informasi akun. Klik kode 2FA untuk menyalinnya.

**Verifikasi manusia (reCAPTCHA):** jika muncul saat menautkan kartu, status berubah menjadi *"Menunggu verifikasi manusia"*. Centang kotaknya di jendela Chrome, dan proses berlanjut otomatis.

**Hasil:** tanggal kedaluwarsa tampil di tabel, dan tangkapan layar bukti tersimpan di folder `screenshots/` (klik **🖼 Lihat**).

## 6. Proxy

Kosongkan **Templat Proxy** untuk memakai jaringan perangkat Anda (disarankan memakai VPN dengan server AS). Jika ingin proxy, format yang didukung:

```text
http://user:pass@host:port
socks5://user:pass@host:port
user:pass@host:port
host:port:user:pass
host:port
```

- Placeholder `{country}`, `{COUNTRY}`, `{session}`, dan `{SESSION}` diganti otomatis per akun.
- Teks 24 karakter atau lebih **tanpa** `:` dan `@` dianggap **API key FloppyData**; kredensial diambil otomatis.
- Opsional: tambahkan `"floppy_api_key": "..."` di `config.json` agar sisa kuota tampil saat menekan **🔍 Uji Konektivitas Proxy**.
- Proxy bisa juga diisi per akun saat impor (kolom proxy).
- Hindari proxy gratis dari daftar publik: IP-nya sering sudah ditandai Google, dan login serta data kartu Anda melewati proxy itu.

## 7. Struktur proyek

```text
.
├── app.py                       # Server FastAPI + API konsol
├── automation_engine.py         # Mesin otomasi Playwright (Step 1-5)
├── templates/index.html         # Antarmuka web
├── config.example.json          # Contoh konfigurasi (aman diunggah)
├── config.json                  # Konfigurasi Anda (dibuat otomatis, TIDAK diunggah)
├── requirements.txt             # fastapi, uvicorn, playwright, pydantic
├── 1_install_dan_jalankan.bat   # Windows: instal + jalankan
├── 2_jalankan_konsol.bat        # Windows: jalankan
├── install_and_run.sh           # Ubuntu/Linux: instal + jalankan
├── run.sh                       # Ubuntu/Linux: jalankan
├── profiles/                    # Profil Chrome per akun (dibuat otomatis)
└── screenshots/                 # Tangkapan layar bukti (dibuat otomatis)
```

Port yang dipakai: `8765` (konsol), `9320-9334` (debug Chrome per akun), `9520-9534` dan `9600-9649` (jembatan proxy lokal).

## 8. Keamanan data

- `config.json` menyimpan **email, kata sandi, kunci 2FA, dan data kartu dalam teks biasa**. Batasi aksesnya:
  ```bash
  chmod 600 config.json
  ```
- `config.json`, `profiles/` (berisi sesi login Chrome), dan `screenshots/` sudah ada di `.gitignore`. **Jangan** mengunggahnya, dan periksa dengan `git status` sebelum `git push`.
- Jika data sempat terunggah, ganti kata sandi akun dan **ganti/blokir kartu** Anda, karena riwayat Git tetap menyimpannya.
- Jalankan sebagai pengguna biasa, bukan root.

## 9. Pemecahan masalah

| Gejala | Penyebab dan solusi |
|---|---|
| `.venv/bin/activate: No such file or directory` | Pembuatan venv sebelumnya gagal. Pasang `sudo apt install python3-venv`, lalu jalankan ulang `./install_and_run.sh` (venv rusak dibuat ulang otomatis). |
| `address already in use` pada port 8765 | Server sudah berjalan. Buka saja http://127.0.0.1:8765, atau hentikan dengan `Ctrl+C` di terminalnya. |
| Chrome tidak ditemukan | Instal Chrome atau Chromium, atau isi `CHROME_PATH=/path/ke/chrome`. |
| `Tunnel connection failed: 402 Payment Required` | Penyedia proxy menolak karena kuota atau paket habis. Periksa dasbor penyedia, atau kosongkan templat proxy. |
| Dropdown langkah awal tertutup sendiri | Sudah diperbaiki. Muat ulang halaman dengan `Ctrl+Shift+R`. |
| Kartu belum diisi | Isi data kartu lalu simpan konfigurasi. Validasi berlaku untuk Step 1 sampai 4. |
| Proses berhenti di tengah | Reset akun, lalu mulai dari langkah terakhir yang berhasil lewat dropdown langkah awal. |
| Selector Google tidak cocok | Tampilan Google berubah. Bagian ini bergantung pada teks halaman berbahasa Mandarin (`hl=zh-CN`), jadi jangan ubah bahasanya. |
| Akun terkena verifikasi tambahan atau diblokir | Itu tindakan Google. Hindari IP data center, jangan ganti IP di tengah sesi login. |

## 10. Kredit

Proyek ini adalah **hasil terjemahan** dari repositori asli:

- **Sumber:** https://github.com/worldonlyu/Google_AI_Pro_2Year_ZeroCost_Auto (penulis: `worldonlyu`)

Perubahan dibanding repositori asli:

| Area | Perubahan |
|---|---|
| Bahasa | Antarmuka web, log, pesan error, komentar, dan README diterjemahkan ke bahasa Indonesia |
| Dipertahankan | Pencocok teks halaman Google (selector, regex, `hl=zh-CN`) tetap berbahasa Mandarin agar otomasi berfungsi |
| Ubuntu / Linux | Deteksi Chrome/Chromium, penghentian proses dan port lintas platform, serta skrip `install_and_run.sh` dan `run.sh` |
| Windows | File `.bat` diganti nama (`1_install_dan_jalankan.bat`, `2_jalankan_konsol.bat`), memakai `chcp 65001`, dan mirror pip Tsinghua dihapus |
| Perbaikan | Dropdown langkah awal di tabel akun tidak lagi tertutup sendiri saat halaman memperbarui data |
| Keamanan data | `config.example.json` ditambahkan, `config.json` dan data pribadi dikeluarkan dari repositori lewat `.gitignore` |

Informasi promosi dari sumber asli:

```text
# 卡网：https://faka.cdkey.si
# 博客：https://blog.caowo.de
# TG群：@Hello_Florence
```

**Lisensi:** repositori asli tidak menyertakan berkas lisensi (per 5 November 2026), sehingga hak distribusi ulang tidak jelas. Hubungi penulis asli atau periksa halaman repositorinya sebelum menerbitkan terjemahan ini secara publik.
