# Refactoring: Konsolidasi ApiService dan DioService

## Latar Belakang

Proyek sebelumnya memiliki dua layanan yang fungsinya tumpang tindih:

1. `ApiService` (di `core/mahas/services/api_service.dart`): Menyediakan abstraksi untuk permintaan API dengan fitur caching.
2. `DioService` (di `data/datasource/network/db/dio_service.dart`): Implementasi HTTP client menggunakan package Dio.

Duplikasi ini menyebabkan beberapa masalah:

- Redundansi kode dan logika
- Kebingungan pengembang tentang layanan mana yang harus digunakan
- Overhead pemeliharaan untuk dua layanan yang serupa
- Tidak konsisten dengan prinsip clean architecture

## Perubahan yang Dilakukan

1. **Penggabungan Layanan**

   - Semua fungsionalitas caching dari `ApiService` telah dipindahkan ke `DioService`
   - `DioService` sekarang mendukung strategi caching yang sama (noCache, cacheFirst, networkFirst, cacheAndUpdate)
   - File `ApiService` telah dihapus dari proyek

2. **Struktur Baru**

   - `DioService` tetap berada di `data/datasource/network/db/dio_service.dart`, yang sesuai dengan prinsip clean architecture
   - Semua referensi ke `ApiService` telah diperbarui untuk menggunakan `DioService`

3. **Perubahan Service Locator**
   - Service locator telah diperbarui untuk mendaftarkan `DioService` dan tidak lagi mendaftarkan `ApiService`
   - Dependensi di `HomeService` dan layanan lain telah diperbarui

## Keuntungan

1. **Kode yang Lebih Bersih**

   - Tidak ada lagi redundansi atau duplikasi kode
   - Jelas bahwa `DioService` adalah layanan jaringan utama

2. **Konsistensi Arsitektur**

   - Semua operasi jaringan sekarang berada di layer data
   - Struktur sesuai dengan prinsip clean architecture

3. **Pemeliharaan yang Lebih Mudah**

   - Hanya satu layanan yang perlu diperbarui dan dipelihara
   - Lebih mudah untuk memahami dan memodifikasi kode jaringan

4. **Efisiensi**
   - Mengurangi ukuran kode dan kompleksitas
   - Mengurangi overhead inisialisasi layanan

## Cara Penggunaan

Untuk menggunakan `DioService` dengan caching:

```dart
// Inject DioService melalui constructor
final DioService _dioService;

// Gunakan caching strategy sesuai kebutuhan
final data = await _dioService.get<Map<String, dynamic>>(
  '/endpoint',
  strategy: CacheStrategy.cacheFirst,
  cacheDuration: const Duration(minutes: 5),
);

// Atau gunakan networkFirst untuk prioritas data realtime
final data = await _dioService.get<Map<String, dynamic>>(
  '/endpoint',
  strategy: CacheStrategy.networkFirst,
);

// Membersihkan cache jika diperlukan
_dioService.clearCache();
// atau
_dioService.clearCacheForEndpoint('/endpoint');
```
