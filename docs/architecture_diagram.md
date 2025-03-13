# Arsitektur Diagram: Repository dan Service Pattern

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│                 │     │                 │     │                 │     │                 │
│       UI        │     │     Provider    │     │     Service     │     │    Repository   │
│    (Widget)     │◄────┤   (State Mgmt)  │◄────┤  (Business Logic)◄────┤   (Data Access) │
│                 │     │                 │     │                 │     │                 │
└─────────────────┘     └─────────────────┘     └─────────────────┘     └─────────────────┘
                                                                               │
                                                                               │
                                                                               ▼
                                                                        ┌─────────────────┐
                                                                        │                 │
                                                                        │   DioService    │
                                                                        │   (HTTP Client) │
                                                                        │                 │
                                                                        └───────┬─────────┘
                                                                               │
                                                                               │
                                                                               ▼
                                                ┌───────────────────────────────────────────────────┐
                                                │                                                   │
                                                │                  Multiple APIs                    │
                                                │                                                   │
                                                │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │
                                                │  │ Main API    │  │ Auth API    │  │ Other API   │  │
                                                │  └─────────────┘  └─────────────┘  └─────────────┘  │
                                                │                                                   │
                                                └───────────────────────────────────────────────────┘
```

## Tanggung Jawab Tiap Komponen

### UI (Widget)

- Menampilkan antarmuka pengguna
- Menangkap input pengguna
- Memperbarui UI berdasarkan perubahan state

### Provider (State Management)

- Mengelola state aplikasi
- Menghubungkan UI dengan Service
- Menangani state loading, error, success

### Service (Business Logic)

- Mengimplementasikan logika bisnis
- Memanipulasi dan memformat data untuk UI
- Menggabungkan data dari berbagai Repository
- Menangani error level bisnis

### Repository (Data Access)

- Bertanggung jawab untuk akses data
- Mengelola caching pada level repository
- Memetakan data mentah ke model domain
- Menangani error level jaringan

### DioService (HTTP Client)

- Melakukan request HTTP
- Mengelola headers, timeout, interceptors
- Mengelola caching tingkat rendah
- Menangani error level HTTP
- **Menangani multiple endpoints** dengan satu instance
- **Menentukan URL yang tepat** berdasarkan UrlType

## Pendekatan Multiple Endpoints

DioService dirancang untuk menangani beberapa API berbeda dalam satu service:

1. **Enum UrlType**: Mendefinisikan berbagai jenis endpoint

   ```dart
   enum UrlType {
     baseUrl,
     authApi,
     paymentApi,
     // dll
   }
   ```

2. **URL Selection**: Memilih URL yang sesuai berdasarkan tipe

   ```dart
   static String getBaseUrl(UrlType urlType) {
     switch (urlType) {
       case UrlType.baseUrl: return "https://api.example.com";
       case UrlType.authApi: return "https://auth.example.com";
       // ...
     }
   }
   ```

3. **Penggunaan dalam Request**:
   ```dart
   Future<T> get<T>(String path, {UrlType urlType = UrlType.baseUrl, ...}) {
     var url = getBaseUrl(urlType) + path;
     // implementasi request
   }
   ```

Pendekatan ini memberikan fleksibilitas tinggi untuk aplikasi yang perlu berkomunikasi dengan beberapa backend berbeda.

## Aliran Data

### Contoh: User Login

1. **UI**: User memasukkan username dan password, menekan tombol login
2. **Provider**: `LoginProvider.login(username, password)` dipanggil
3. **Service**: `AuthService.login(username, password)` dipanggil
   - Validasi input
   - Menerapkan logika bisnis autentikasi
4. **Repository**: `UserRepository.loginUser(username, password)` dipanggil
   - Format data untuk request API
5. **DioService**:
   - Menentukan endpoint yang tepat (misal, `UrlType.authApi`)
   - Melakukan HTTP POST ke endpoint login
6. **API**: Memproses login dan mengembalikan response

### Data Kembali

1. **DioService**: Menerima response API, cek status HTTP, kembalikan data
2. **Repository**: Memetakan response ke model domain (User)
3. **Service**: Menerapkan logika bisnis tambahan (simpan token, dll)
4. **Provider**: Memperbarui state (isLoggedIn, userData, dll)
5. **UI**: Rebuild UI berdasarkan state yang diperbarui

## Keuntungan dari Layer Separation

- **Testability**: Setiap layer dapat diuji secara independen
- **Maintainability**: Perubahan di satu layer tidak mempengaruhi layer lain
- **Reusability**: Repository dan DioService dapat digunakan kembali
- **Separation of Concerns**: Setiap layer memiliki tanggung jawab yang jelas
- **Flexibility**: Kemampuan menangani berbagai endpoint dan API berbeda
