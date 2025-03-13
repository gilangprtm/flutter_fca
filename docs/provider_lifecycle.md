# Provider Lifecycle Management

Dokumen ini menjelaskan cara menggunakan sistem Provider Lifecycle Management yang terinspirasi dari GetX.

## Pendahuluan

Provider Lifecycle Management menambahkan metode lifecycle (`onInit`, `onReady`, dan `onClose`) ke dalam Provider untuk mengelola resource secara efektif dan mengurangi penggunaan memori. Sistem ini memastikan bahwa resource dibersihkan ketika provider tidak lagi digunakan, mirip dengan cara GetX mengelola controller-nya.

## Komponen Utama

### 1. BaseProvider

`BaseProvider` adalah kelas dasar untuk semua provider yang ingin menggunakan sistem lifecycle management. Kelas ini menyediakan metode-metode berikut:

- **onInit()**: Dipanggil saat provider pertama kali diinisialisasi. Tempat ideal untuk menginisialisasi variabel, memuat data awal, atau mengatur listeners.
- **onReady()**: Dipanggil setelah widget berhasil dirender pada layar. Tempat ideal untuk operasi yang membutuhkan konteks yang sudah sepenuhnya dibangun.
- **onClose()**: Dipanggil tepat sebelum provider dihapus dari memori. Tempat ideal untuk membersihkan resources, menutup connections, atau membatalkan streams/timers.

### 2. ProviderWidget dan ProviderPage

`ProviderWidget` dan `ProviderPage` adalah helper widget yang secara otomatis menginisialisasi provider dan memanggil lifecycle methods pada waktu yang tepat.

## Cara Penggunaan

### 1. Membuat Provider

Untuk membuat provider dengan lifecycle management, extend `BaseProvider` dan override metode lifecycle:

```dart
class MyProvider extends BaseProvider {
  // State dan methods anda

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi variabel, setup listeners, dll.
    print('MyProvider initialized');
  }

  @override
  void onReady() {
    super.onReady();
    // Lakukan operasi setelah widget selesai dirender
    fetchInitialData();
  }

  @override
  void onClose() {
    // Bersihkan resources
    print('Cleaning up resources...');
    super.onClose();
  }
}
```

### 2. Mendaftarkan Provider

Daftarkan provider seperti biasa di `ChangeNotifierProvider`:

```dart
ChangeNotifierProvider(
  create: (_) => MyProvider(),
)
```

### 3. Menggunakan ProviderPage di Halaman

Untuk halaman yang menggunakan provider, bungkus dengan `ProviderPage`:

```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderPage<MyProvider>(
      builder: (context, provider) => Scaffold(
        appBar: AppBar(title: Text('My Page')),
        body: Center(
          child: Text(provider.someValue),
        ),
      ),
    );
  }
}
```

### 4. Menggunakan ProviderWidget untuk Bagian dari UI

Untuk widget yang lebih kecil yang membutuhkan akses ke provider:

```dart
ProviderWidget<MyProvider>(
  builder: (context, provider, child) => CustomComponent(
    value: provider.someValue,
    onTap: provider.someMethod,
  ),
)
```

## Keuntungan Menggunakan Provider Lifecycle Management

1. **Pengurangan Memory Leaks**: Resources dibersihkan secara otomatis ketika provider tidak lagi digunakan.
2. **Kode Lebih Terstruktur**: Metode lifecycle memberikan tempat yang jelas untuk inisialisasi dan cleanup.
3. **Transisi Mudah dari GetX**: Bagi developer yang terbiasa dengan GetX, pola lifecycle ini akan terasa familiar.
4. **Pemisahan Concerns**: Pisahkan logika init, ready, dan cleanup untuk meningkatkan keterbacaan kode.

## Contoh Kasus

### Membersihkan Timer saat Halaman Ditutup

```dart
class TimerProvider extends BaseProvider {
  Timer? _timer;
  int _seconds = 0;

  int get seconds => _seconds;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds++;
      notifyListeners();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    print('Timer cancelled');
    super.onClose();
  }
}
```

Dengan contoh di atas, timer akan otomatis dibatalkan ketika halaman ditutup, mencegah memory leak dan penggunaan CPU yang tidak perlu.
