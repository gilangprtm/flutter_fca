import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'dart:convert';

import '../../../../core/helper/dialog_helper.dart';
import '../../../../core/env/app_environment.dart';
import '../../../../core/mahas/services/logger_service.dart';
import '../../../../core/di/service_locator.dart';

/// Enum untuk berbagai tipe URL/endpoint yang digunakan aplikasi
/// Ini memungkinkan aplikasi untuk menghubungi beberapa API berbeda
enum UrlType {
  baseUrl,
  // Tambahkan endpoint lain yang dibutuhkan
  // contoh:
  // authApi,
  // paymentApi,
  // notificationApi,
}

/// Strategi caching yang tersedia
enum CacheStrategy {
  /// Tidak menggunakan cache, selalu ambil dari network
  noCache,

  /// Gunakan cache jika ada, jika tidak ambil dari network
  cacheFirst,

  /// Ambil dari network, update cache jika berhasil
  networkFirst,

  /// Gunakan cache jika ada, dan update cache dari network di background
  cacheAndUpdate,
}

/// Class untuk entry cache
class _CacheEntry {
  final dynamic data;
  final DateTime expiry;

  _CacheEntry({required this.data, required this.expiry});

  /// Mengecek apakah entry sudah expired
  bool get isExpired => DateTime.now().isAfter(expiry);
}

/// Service untuk mengelola komunikasi HTTP menggunakan Dio
///
/// Class ini bertanggung jawab untuk:
/// 1. Mengonfigurasi instance Dio untuk berbagai endpoint
/// 2. Mengelola caching untuk permintaan HTTP
/// 3. Menangani error dan retries
///
/// Catatan: DioService membuat dan mengonfigurasi instance Dio-nya sendiri,
/// bukan menerima Dio melalui dependency injection. Hal ini disebabkan oleh
/// kebutuhan untuk menangani berbagai endpoint yang berbeda melalui enum UrlType.
class DioService {
  final Dio _dio;
  final LoggerService _logger;

  // Cache storage
  final Map<String, _CacheEntry> _cache = {};

  // Konfigurasi service
  final Duration _defaultCacheTime;
  final bool _enableCache;

  /// Mendapatkan base URL sesuai dengan tipe yang dipilih
  /// Method static ini memungkinkan fleksibilitas untuk switching antar endpoint
  static String getBaseUrl(UrlType urlType) {
    switch (urlType) {
      case UrlType.baseUrl:
        return "https://reqres.in/api";
      // Tambahkan case untuk endpoint lain sesuai kebutuhan
      // case UrlType.authApi:
      //   return "https://auth.example.com/api";
    }
  }

  /// Constructor DioService yang menginisialisasi dan mengonfigurasi Dio
  /// Tidak menerima Dio sebagai parameter karena menangani konfigurasi sendiri
  /// untuk mendukung multiple endpoint
  DioService({LoggerService? logger})
      : _dio = Dio(),
        _logger = logger ?? serviceLocator<LoggerService>(),
        _enableCache = !AppEnvironment.instance.isProduction ||
            true, // Gunakan cache bahkan di production
        _defaultCacheTime = const Duration(minutes: 10) {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
      },
    );

    _dio.interceptors.addAll([
      PrettyDioLogger(
        request: false,
      ),
      _TokenInterceptor(),
    ]);
  }

  /// Melakukan GET request dengan caching
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    UrlType urlType = UrlType.baseUrl,
    CacheStrategy strategy = CacheStrategy.noCache,
    Duration? cacheDuration,
    String? cacheKey,
  }) async {
    var url = getBaseUrl(urlType) + path;

    // Log request
    _logger.d('API GET request to $url', tag: 'API');

    // Cek apakah menggunakan cache
    final useCache = _enableCache && strategy != CacheStrategy.noCache;

    // Generate cache key
    final effectiveCacheKey =
        cacheKey ?? _generateCacheKey('GET', url, queryParameters);
    final effectiveCacheDuration = cacheDuration ?? _defaultCacheTime;

    // Jika cache first dan cache ada + valid, gunakan cache
    if (useCache && strategy == CacheStrategy.cacheFirst) {
      final cachedData = _getFromCache<T>(effectiveCacheKey);
      if (cachedData != null) {
        _logger.d('Returning cached data for $url', tag: 'API');
        return cachedData;
      }
    }

    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
      );

      // Parse data ke tipe T
      final data = response.data as T;

      // Simpan ke cache jika menggunakan cache
      if (useCache) {
        _saveToCache<T>(effectiveCacheKey, data, effectiveCacheDuration);
      }

      return data;
    } catch (e) {
      // Jika error dan network first tapi ada cache, gunakan cache
      if (useCache && strategy == CacheStrategy.networkFirst) {
        final cachedData = _getFromCache<T>(effectiveCacheKey);
        if (cachedData != null) {
          _logger.w('Network request failed, using cached data for $url',
              data: e, tag: 'API');
          return cachedData;
        }
      }

      throw _handleError(e);
    }
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    UrlType urlType = UrlType.baseUrl,
  }) async {
    try {
      var url = getBaseUrl(urlType) + path;
      _logger.d('API POST request to $url', tag: 'API');

      final response = await _dio.post(url,
          data: data, queryParameters: queryParameters, options: options);

      return response.data as T;
    } catch (e) {
      _logger.e('Error in API POST request', error: e, tag: 'API');
      throw _handleError(e);
    }
  }

  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    UrlType urlType = UrlType.baseUrl,
  }) async {
    try {
      var url = getBaseUrl(urlType) + path;
      _logger.d('API PUT request to $url', tag: 'API');

      final response = await _dio.put(url,
          data: data, queryParameters: queryParameters, options: options);

      return response.data as T;
    } catch (e) {
      _logger.e('Error in API PUT request', error: e, tag: 'API');
      throw _handleError(e);
    }
  }

  Future<T> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    UrlType urlType = UrlType.baseUrl,
  }) async {
    try {
      var url = getBaseUrl(urlType) + path;
      _logger.d('API PATCH request to $url', tag: 'API');

      final response = await _dio.patch(url,
          data: data, queryParameters: queryParameters, options: options);

      return response.data as T;
    } catch (e) {
      _logger.e('Error in API PATCH request', error: e, tag: 'API');
      throw _handleError(e);
    }
  }

  Future<T> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    UrlType urlType = UrlType.baseUrl,
  }) async {
    try {
      var url = getBaseUrl(urlType) + path;
      _logger.d('API DELETE request to $url', tag: 'API');

      final response = await _dio.delete(url,
          queryParameters: queryParameters, options: options);

      return response.data as T;
    } catch (e) {
      _logger.e('Error in API DELETE request', error: e, tag: 'API');
      throw _handleError(e);
    }
  }

  Future<T> postFormData<T>(
    String path,
    FormData formData, {
    UrlType urlType = UrlType.baseUrl,
  }) async {
    try {
      var url = getBaseUrl(urlType) + path;
      _logger.d('API POST FormData request to $url', tag: 'API');

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      return response.data as T;
    } catch (e) {
      _logger.e('Error in API POST FormData request', error: e, tag: 'API');
      throw _handleError(e);
    }
  }

  Future<T> putFormData<T>(
    String path,
    FormData formData, {
    UrlType urlType = UrlType.baseUrl,
  }) async {
    try {
      var url = getBaseUrl(urlType) + path;
      _logger.d('API PUT FormData request to $url', tag: 'API');

      final response = await _dio.put(
        url,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      return response.data as T;
    } catch (e) {
      _logger.e('Error in API PUT FormData request', error: e, tag: 'API');
      throw _handleError(e);
    }
  }

  Future<T> patchFormData<T>(
    String path,
    FormData formData, {
    UrlType urlType = UrlType.baseUrl,
  }) async {
    try {
      var url = getBaseUrl(urlType) + path;
      _logger.d('API PATCH FormData request to $url', tag: 'API');

      final response = await _dio.patch(
        url,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      return response.data as T;
    } catch (e) {
      _logger.e('Error in API PATCH FormData request', error: e, tag: 'API');
      throw _handleError(e);
    }
  }

  /// Membersihkan seluruh cache
  void clearCache() {
    _cache.clear();
    _logger.i('API cache cleared', tag: 'API');
  }

  /// Membersihkan cache berdasarkan key
  void clearCacheForKey(String key) {
    if (_cache.containsKey(key)) {
      _cache.remove(key);
      _logger.d('Cache cleared for key: $key', tag: 'API');
    }
  }

  /// Membersihkan cache berdasarkan endpoint
  void clearCacheForEndpoint(String endpoint) {
    final keysToRemove =
        _cache.keys.where((key) => key.contains(endpoint)).toList();

    for (final key in keysToRemove) {
      _cache.remove(key);
    }

    _logger.d(
        'Cache cleared for endpoint: $endpoint (${keysToRemove.length} entries)',
        tag: 'API');
  }

  /// Generate cache key dari request parameters
  String _generateCacheKey(
      String method, String endpoint, Map<String, dynamic>? queryParams) {
    if (queryParams == null || queryParams.isEmpty) {
      return '$method:$endpoint';
    }

    // Sort query params agar key konsisten
    final sortedParams = queryParams.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Encode params ke JSON string
    final paramsString =
        jsonEncode(sortedParams.map((e) => '${e.key}=${e.value}').toList());

    return '$method:$endpoint:$paramsString';
  }

  /// Ambil data dari cache
  T? _getFromCache<T>(String key) {
    final entry = _cache[key];

    // Jika tidak ada di cache atau expired, return null
    if (entry == null || entry.isExpired) {
      if (entry?.isExpired == true) {
        _logger.d('Cache expired for key: $key', tag: 'API');
      }
      return null;
    }

    return entry.data as T?;
  }

  /// Simpan data ke cache
  void _saveToCache<T>(String key, T data, Duration cacheDuration) {
    final expiry = DateTime.now().add(cacheDuration);
    _cache[key] = _CacheEntry(data: data, expiry: expiry);
    _logger.d('Data cached for key: $key (expires: $expiry)', tag: 'API');
  }

  // Updated error handling with DioException
  DioException _handleError(dynamic error) {
    if (error is DioException) {
      String message = 'Unknown error occurred.';
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          message = 'Connection timeout, please try again later.';
          break;

        case DioExceptionType.badResponse:
          message =
              'Bad response from server, status code: ${error.response?.statusCode}';
          break;

        // DioExceptionType.cancel is no longer directly available
        case DioExceptionType.cancel:
          message = 'Request to API server was cancelled.';
          break;

        // DioExceptionType.other has been replaced with a generic error type
        case DioExceptionType.connectionError:
          message = 'Check your internet, and try again later.';
          break;

        // Handle unknown types
        default:
          message = 'An unknown error occurred';
          break;
      }
      DialogHelper.showErrorDialog(
        message,
      );
      return DioException(
        requestOptions: error.requestOptions,
        error: message,
      );
    } else {
      return DioException(
          requestOptions: RequestOptions(path: ''),
          error: 'Unknown error occurred.');
    }
  }
}

class _TokenInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Add token to the header before the request is sent
    String? token = await _getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Handle token refresh logic here
      String? newToken = await _refreshToken();
      if (newToken != null) {
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        final cloneReq = await Dio().fetch(err.requestOptions);
        return handler.resolve(cloneReq);
      }
    }
    handler.next(err);
  }

  Future<String?> _getToken() async {
    // Fetch the token from local storage or secure storage
    return 'your-token';
  }

  Future<String?> _refreshToken() async {
    // Implement refresh token logic
    return 'new-token';
  }
}
