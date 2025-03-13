# Environment Setup

Flutter Provider Kit mendukung beberapa environment untuk memfasilitasi development, testing, dan production. Dokumen ini menjelaskan cara menggunakan dan mengonfigurasi environment yang berbeda.

## Environment yang Tersedia

Aplikasi mendukung tiga environment:

1. **Development**: Untuk pengembangan lokal, dengan fitur debugging lengkap.
2. **Staging**: Untuk testing pre-production, dengan konfigurasi yang mirip production.
3. **Production**: Untuk aplikasi yang dirilis ke pengguna akhir, dioptimalkan untuk performa.

## Perilaku Berbasis Environment

Beberapa perilaku aplikasi berubah berdasarkan environment:

### Development

- Logging detail diaktifkan (semua level log)
- Debug banner ditampilkan
- Log viewer tersedia
- Maksimum 1000 entri log disimpan dalam memori

### Staging

- Logging level info dan di atasnya
- Debug banner ditampilkan
- Maksimum 500 entri log disimpan dalam memori

### Production

- Hanya error dan fatal error yang dicatat
- Debug banner disembunyikan
- Log viewer tidak tersedia
- Hanya 100 entri log disimpan (untuk error reporting)

## Cara Menggunakan Environment

Environment ditentukan saat aplikasi diinisialisasi di `main.dart`:

```dart
void main() async {
  // Tentukan environment berdasarkan flag compile/build
  final environment = _determineEnvironment();

  // Inisialisasi dengan environment yang ditentukan
  await MahasService.init(environment: environment);

  // ...
}
```

## Menjalankan Aplikasi dengan Environment Tertentu

### 1. Development

```bash
flutter run --debug
```

### 2. Staging

```bash
flutter run --profile
```

### 3. Production

```bash
flutter run --release
```

## Cara Mengganti Konfigurasi Environment

Konfigurasi untuk setiap environment dapat diubah di `lib/core/env/app_environment.dart`:

```dart
void _loadConfig() {
  switch (_environment) {
    case Environment.development:
      _config.addAll({
        'apiUrl': 'https://dev-api.example.com',
        'enableDetailedLogs': true,
        'logLevel': 'debug',
        'maxLogHistory': 1000,
      });
      break;
    // ... konfigurasi lain
  }
}
```

## Mengakses Pengaturan Environment di Kode

Anda dapat menggunakan `AppEnvironment` untuk:

1. **Memeriksa Environment Aktif**:

```dart
if (AppEnvironment.instance.isDevelopment) {
  // Kode khusus development
}
```

2. **Mengakses Nilai Konfigurasi**:

```dart
final apiUrl = AppEnvironment.instance.get<String>('apiUrl');
```

## Praktik Terbaik

1. **Jangan menggunakan hardcoded URL** - Selalu ambil URL dari konfigurasi environment.
2. **Jadikan aplikasi production-ready** - Pastikan logging berlebihan dinonaktifkan di production.
3. **Tambahkan fitur debug khusus development** - Seperti log viewer, hanya di environment development.
4. **Gunakan error reporting di production** - Firebase Crashlytics atau layanan serupa.
