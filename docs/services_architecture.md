# Arsitektur Layanan (Services Architecture)

Dokumen ini menjelaskan arsitektur layanan (services) yang digunakan dalam aplikasi, termasuk bagaimana layanan diinisialisasi dan dikelola.

## Pendahuluan

Aplikasi ini menggunakan pendekatan modular untuk inisialisasi dan pengelolaan berbagai layanan (seperti Firebase, Local Storage, dll). Hal ini membantu menjaga kode tetap terorganisir dan mudah dikelola saat aplikasi berkembang.

## Struktur Layanan

### 1. MahasService

`MahasService` adalah orchestrator pusat yang bertanggung jawab untuk menginisialisasi semua layanan lain saat aplikasi dimulai. Ini berperan sebagai "entry point" untuk inisialisasi aplikasi.

**Lokasi**: `lib/core/mahas/mahas_service.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Semua inisialisasi dilakukan melalui MahasService
  await MahasService.init();

  runApp(...);
}
```

### 2. Layanan Terspesialisasi

Setiap kategori fungsi memiliki layanan khusus sendiri:

#### FirebaseService

Mengelola semua inisialisasi dan fungsi terkait Firebase.

**Lokasi**: `lib/core/mahas/services/firebase_service.dart`

**Fitur**:

- Inisialisasi Firebase App
- Konfigurasi Analytics
- Setup Messaging
- Setup Crashlytics

#### StorageService

Mengelola semua operasi penyimpanan lokal.

**Lokasi**: `lib/core/mahas/services/storage_service.dart`

**Fitur**:

- Inisialisasi Shared Preferences
- Inisialisasi Secure Storage
- Inisialisasi Hive (NoSQL database)
- Operasi CRUD untuk data lokal

### 3. Service Locator

Semua layanan tersebut juga didaftarkan di Service Locator (GetIt) sehingga dapat diakses dari mana saja di aplikasi melalui dependency injection.

**Lokasi**: `lib/core/di/service_locator.dart`

## Cara Penggunaan

### 1. Inisialisasi Layanan

Inisialisasi semua layanan dilakukan secara otomatis saat aplikasi dimulai melalui `MahasService.init()`.

### 2. Mengakses Layanan

Layanan dapat diakses dengan dua cara:

#### Melalui Dependency Injection (Direkomendasikan)

```dart
// Di provider atau kelas lain yang menerima dependensi melalui konstruktor
class MyProvider extends BaseProvider {
  final FirebaseService firebaseService;

  MyProvider({required this.firebaseService});

  void someMethod() {
    // Gunakan firebaseService
  }
}

// Registrasi provider
ChangeNotifierProvider(
  create: (_) => MyProvider(
    firebaseService: serviceLocator(),
  ),
),
```

#### Melalui Service Locator Langsung

```dart
// Menggunakan Mahas utility
final firebaseService = Mahas.find<FirebaseService>();

// Atau langsung dari serviceLocator
final firebaseService = serviceLocator<FirebaseService>();
```

### 3. Menambahkan Layanan Baru

Untuk menambahkan layanan baru:

1. Buat kelas layanan baru di `lib/core/mahas/services/`
2. Implementasikan pola singleton
3. Tambahkan method `init()` untuk inisialisasi
4. Daftarkan di service locator di `setupServiceLocator()`
5. Tambahkan pemanggilan inisialisasi di `MahasService` jika perlu

## Praktik Terbaik

1. **Pemisahan Concern**: Setiap layanan harus fokus pada satu area fungsi
2. **Lazy Initialization**: Inisialisasi layanan hanya ketika diperlukan
3. **Error Handling**: Selalu tangani error selama inisialisasi
4. **Logging**: Gunakan logging untuk memudahkan debugging
5. **Documentation**: Dokumentasikan setiap layanan dan fungsi-fungsinya

## Diagram Arsitektur

```
┌─────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   main.dart │────▶│  MahasService   │────▶│ Service Locator │
└─────────────┘     └─────────────────┘     └─────────┬───────┘
                            │                          │
                            ▼                          ▼
                    ┌───────────────┐         ┌───────────────┐
                    │ Orchestrates  │         │  Provides DI  │
                    └───────┬───────┘         └───────────────┘
                            │
            ┌───────────────┼───────────────┐
            │               │               │
            ▼               ▼               ▼
  ┌─────────────────┐ ┌──────────────┐ ┌────────────────┐
  │ FirebaseService │ │StorageService│ │ Other Services │
  └─────────────────┘ └──────────────┘ └────────────────┘
```

Dengan arsitektur ini, aplikasi dapat dengan mudah menambah atau mengubah layanan tanpa mempengaruhi komponen lain, dan main.dart tetap bersih dan fokus pada tugas utamanya.

# Services Architecture & Repository Pattern

## Arsitektur Umum

Proyek ini mengimplementasikan clean architecture yang memisahkan kode menjadi beberapa layer:

1. **Presentation Layer**: Berisi UI dan state management (providers)
2. **Domain Layer**: Berisi logika bisnis (service)
3. **Data Layer**: Berisi model data, repository, dan data source

## Repository Pattern

### Konsep Dasar

Repository pattern digunakan untuk memisahkan logika akses data dari logika bisnis. Repository bertanggung jawab untuk:

1. Mengambil data dari sumber data (API, database lokal, dll)
2. Memetakan data ke model domain
3. Menyediakan abstraksi yang memudahkan testing

### Struktur

```
data/
  └── datasource/
      └── network/
          ├── db/
          │   └── dio_service.dart      # Implementasi HTTP client
          ├── repository/
          │   ├── base_repository.dart  # Kelas dasar untuk repository
          │   ├── user_repository.dart  # Repository untuk user data
          │   └── home_repository.dart  # Repository untuk home data
          └── service/
              ├── auth_service.dart     # Service untuk autentikasi
              └── home_service.dart     # Service untuk home screen
```

### DioService dan Multiple Endpoints

`DioService` dirancang untuk menangani komunikasi HTTP dengan pendekatan khusus untuk multiple endpoints:

```dart
enum UrlType {
  baseUrl,
  authApi,
  paymentApi,
  // dll
}

class DioService {
  static String getBaseUrl(UrlType urlType) {
    switch (urlType) {
      case UrlType.baseUrl:
        return "https://api.example.com";
      case UrlType.authApi:
        return "https://auth.example.com";
      // ... dll
    }
  }

  // Metode untuk hit endpoint dengan URL yang sesuai
  Future<T> get<T>(
    String path, {
    UrlType urlType = UrlType.baseUrl,
    // parameter lainnya
  }) {
    var url = getBaseUrl(urlType) + path;
    // implementasi...
  }
}
```

**Keuntungan Pendekatan Ini:**

- Dapat menangani beberapa API berbeda dalam satu service
- Fleksibilitas tinggi untuk switching antar environment (dev/staging/prod)
- Konfigurasi URL terpusat di satu tempat
- Kemampuan untuk menentukan jenis endpoint secara dinamis saat runtime

**Catatan:** Karena kebutuhan khusus ini, `DioService` menginisialisasi dan mengonfigurasi instance Dio-nya sendiri, bukan menerima Dio dari service locator.

### Repository

Repository memiliki tanggung jawab utama untuk mengambil data dari sumber eksternal (API):

- Menggunakan `DioService` untuk komunikasi HTTP
- Menangani caching pada level repository
- Memformat response data ke bentuk yang sesuai
- Menangani error network-level

```dart
class UserRepository extends BaseRepository {
  Future<User> getUserById(int id) async {
    final response = await dioService.get<Map<String, dynamic>>(
      '/users/$id',
      strategy: CacheStrategy.cacheFirst,
    );
    return User.fromJson(response);
  }
}
```

### Service

Service memiliki tanggung jawab utama untuk menerapkan logika bisnis:

- Menggunakan repository untuk akses data
- Mengimplementasikan aturan bisnis
- Memformat data untuk presentasi
- Menangani error business-level

```dart
class AuthService {
  final UserRepository _userRepository;

  Future<User> login(String email, String password) async {
    final response = await _userRepository.loginUser(email, password);
    // Apply business logic
    saveToken(response.token);
    return response.user;
  }
}
```

## Keuntungan Pendekatan Ini

1. **Separation of Concerns**:

   - Repository fokus pada akses data
   - Service fokus pada logika bisnis
   - Providers fokus pada state management

2. **Testability**:

   - Repository dapat dengan mudah di-mock untuk testing service
   - Service dapat dengan mudah di-mock untuk testing provider

3. **Reusability**:

   - Repository dapat digunakan oleh berbagai service
   - Menghindari redundansi di kode akses data

4. **Maintainability**:
   - Perubahan di API hanya mempengaruhi repository
   - Perubahan logika bisnis hanya mempengaruhi service

## Dependency Injection

Service dan repository diregister di service locator untuk dependency injection:

```dart
// Register DioService - mengelola instance Dio-nya sendiri
serviceLocator.registerLazySingleton<DioService>(() => DioService(
  logger: serviceLocator<LoggerService>(),
));

// Register repositories
serviceLocator.registerLazySingleton<UserRepository>(() => UserRepository(
  dioService: serviceLocator<DioService>(),
  logger: serviceLocator<LoggerService>(),
));

// Register services
serviceLocator.registerLazySingleton<AuthService>(() => AuthService(
  userRepository: serviceLocator<UserRepository>(),
  logger: serviceLocator<LoggerService>(),
));
```

## Flow Eksekusi

Berikut adalah flow eksekusi tipikal:

1. **UI** (widget) memanggil method di provider
2. **Provider** memanggil method di service
3. **Service** menerapkan logika bisnis dan memanggil repository
4. **Repository** mengambil data dari API atau cache melalui DioService
5. **DioService** menentukan endpoint yang tepat dan melakukan request HTTP
6. Data mengalir kembali: DioService → Repository → Service → Provider → UI
