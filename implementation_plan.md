# Sinkronisasi Pengaturan Notifikasi ke Backend & Admin

Saat ini, pengaturan notifikasi hanya tersimpan di memori lokal HP pengguna (menggunakan `SharedPreferences`). Untuk memastikan pengaturan pengguna tidak hilang ketika mereka mengganti HP atau menginstal ulang aplikasi, kita perlu merencanakan integrasi pengaturan ini ke **Backend (Laravel)** dan menampilkannya di **Admin Panel**.

Berikut adalah rencana implementasinya:

## Proposed Changes

### 1. Database (Backend)
Kita akan menambahkan kolom baru pada tabel `users` untuk menyimpan preferensi notifikasi secara permanen.

#### [NEW] Migration: `add_notification_settings_to_users_table`
- Membuat file migrasi baru menggunakan `php artisan make:migration`.
- Menambahkan kolom `notification_settings` dengan tipe data `json` pada tabel `users`. Kolom ini akan menyimpan status true/false untuk setiap jenis notifikasi:
  ```json
  {
    "pause_all": false,
    "news": true,
    "weather": true,
    "shop": true,
    "system": true
  }
  ```

### 2. Model (Backend)

#### [MODIFY] `app/Models/User.php`
- Menambahkan `notification_settings` ke dalam property `$fillable`.
- Menambahkan *casting* array untuk mempermudah akses data JSON:
  ```php
  protected $casts = [
      'notification_settings' => 'array',
  ];
  ```

### 3. API & Controller (Backend)

#### [MODIFY] `routes/api.php`
- Menambahkan rute API baru untuk memperbarui pengaturan notifikasi:
  `Route::post('/user/notification-settings', [UserController::class, 'updateNotificationSettings']);`

#### [MODIFY] `app/Http/Controllers/UserController.php`
- (Atau controller terkait user profile yang sudah ada).
- Membuat metode `updateNotificationSettings(Request $request)` yang menerima payload JSON dari aplikasi Flutter dan menyimpannya ke database `users`.

### 4. Admin Panel (Backend)

#### [MODIFY] `resources/views/admin/users/index.blade.php` (Atau halaman detail user)
- Menambahkan indikator kecil (badge) atau informasi di tabel/detail profil petani untuk melihat preferensi notifikasinya (misal: apakah mereka menerima notifikasi cuaca/promo). Hal ini berguna untuk tim marketing jika ingin menyasar push notification khusus.

### 5. Aplikasi (Frontend - Flutter)

#### [MODIFY] `lib/screens/notification_settings_screen.dart`
- Mengubah fungsi `_savePreference` agar selain menyimpan di `SharedPreferences`, aplikasi juga akan melakukan HTTP POST/PUT ke endpoint backend `/api/user/notification-settings`.
- Mengubah fungsi `_loadPreferences` agar mengambil pengaturan terbaru dari profil user di server saat halaman pertama kali dibuka (jika ada internet).

---

## User Review Required

> [!IMPORTANT]
> **Keputusan Implementasi:**
> 1. Apakah Anda ingin pengaturan ini ditampilkan di sisi **Admin Panel** (misalnya di menu Daftar Pengguna)?
> 2. Apakah struktur data *JSON* seperti yang saya tawarkan di atas sudah sesuai dengan kebutuhan aplikasi?

Silakan setujui rencana ini jika Anda ingin saya langsung mengerjakan sisi backend, database, dan pembaruan API-nya.
