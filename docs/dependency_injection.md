# Dependency Injection

Dokumen ini menjelaskan cara menggunakan dan mengelola dependency injection di dalam proyek Flutter Provider Kit.

## Pendahuluan

Dependency Injection (DI) adalah pola desain yang membuat kode lebih terstruktur, testable, dan maintainable. Dengan DI, kita menyuntikkan dependensi dari luar ke dalam kelas yang membutuhkannya, alih-alih kelas tersebut membuat atau mencari dependensinya sendiri.

Dalam proyek ini, kita menggunakan GetIt sebagai Service Locator untuk mengimplementasikan DI.

## Komponen Utama

### 1. Service Locator (GetIt)

GetIt adalah library ringan untuk mengimplementasikan Service Locator pattern. Service Locator adalah global point untuk mengakses semua service yang terdaftar.

### 2. Setup Dependencies

Setup dependensi dilakukan di `lib/core/di/service_locator.dart`. Semua pendaftaran service dan repository dilakukan di sini.

### 3. Provider dengan DI

Provider tidak lagi membuat dependensinya sendiri, melainkan menerimanya melalui konstruktor.

## Cara Penggunaan

### 1. Mendaftarkan Dependensi

Untuk mendaftarkan dependensi baru, tambahkan di `service_locator.dart`:

```dart
// Singleton (hanya dibuat sekali)
serviceLocator.registerLazySingleton<MyService>(() => MyServiceImpl());

// Factory (dibuat baru setiap dipanggil)
serviceLocator.registerFactory<MyService>(() => MyServiceImpl());
```

### 2. Membuat Provider dengan DI

Provider harus menerima dependensinya melalui konstruktor:

```dart
class MyProvider extends BaseProvider {
  final MyService myService;

  MyProvider({required this.myService});

  // Methods...
}
```

### 3. Mendaftarkan Provider dengan DI

Di `app_providers.dart`, daftarkan provider dengan dependensinya:

```dart
ChangeNotifierProvider(
  create: (_) => MyProvider(
    myService: serviceLocator(),
  ),
),
```

### 4. Mengakses Dependensi Langsung

Untuk mengakses dependensi secara langsung, gunakan `Mahas.find<T>()` atau `serviceLocator<T>()`:

```dart
final myService = Mahas.find<MyService>();
// atau
final myService = serviceLocator<MyService>();
```

## Tipe Registrasi di GetIt

1. **Singleton**: Dibuat saat pertama kali diminta dan digunakan kembali untuk semua permintaan berikutnya.

   ```dart
   serviceLocator.registerSingleton<MyService>(MyServiceImpl());
   ```

2. **Lazy Singleton**: Mirip dengan singleton, tetapi dibuat hanya saat diperlukan pertama kali.

   ```dart
   serviceLocator.registerLazySingleton<MyService>(() => MyServiceImpl());
   ```

3. **Factory**: Membuat instance baru setiap kali diminta.
   ```dart
   serviceLocator.registerFactory<MyService>(() => MyServiceImpl());
   ```

## Keuntungan Pendekatan Ini

1. **Testability**: Memudahkan unit testing dengan mocking dependencies.

   ```dart
   testWidgets('MyWidget test', (tester) async {
     // Register mock for testing
     serviceLocator.registerSingleton<MyService>(MockMyService());

     // Test code...
   });
   ```

2. **Loose Coupling**: Mengurangi ketergantungan langsung antar komponen.

3. **Reusability**: Service dapat digunakan di berbagai bagian aplikasi tanpa duplikasi.

4. **Maintainability**: Perubahan implementasi tidak mempengaruhi kode klien.

## Contoh Implementasi

### Service

```dart
// Interface
abstract class UserService {
  Future<User> getUser(int id);
}

// Implementation
class UserServiceImpl implements UserService {
  @override
  Future<User> getUser(int id) async {
    // Implementation...
  }
}
```

### Provider

```dart
class UserProvider extends BaseProvider {
  final UserService userService;

  UserProvider({required this.userService});

  Future<void> loadUser(int id) async {
    // Use userService...
  }
}
```

### Registration

```dart
// Service registration
serviceLocator.registerLazySingleton<UserService>(() => UserServiceImpl());

// Provider registration
ChangeNotifierProvider(
  create: (_) => UserProvider(
    userService: serviceLocator(),
  ),
),
```

Dengan implementasi DI ini, kita telah meningkatkan arsitektur aplikasi dengan memisahkan tanggung jawab dan mengurangi coupling, sehingga kode lebih mudah di-test dan di-maintain.
