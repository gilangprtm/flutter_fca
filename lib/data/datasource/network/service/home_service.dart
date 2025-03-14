import 'dart:io';

import '../../../../core/mahas/services/logger_service.dart';
import '../../../../core/mahas/services/performance_service.dart';
import '../repository/home_repository.dart';

/// Service untuk mengelola logika bisnis terkait home screen
class HomeService {
  final HomeRepository _homeRepository = HomeRepository();
  final LoggerService _logger = LoggerService.instance;
  final PerformanceService _performanceService = PerformanceService.instance;

  /// Mendapatkan data untuk home screen, termasuk banners dan featured products
  Future<Map<String, dynamic>> getHomeScreenData() async {
    return _performanceService.measureAsync('HomeService.getHomeScreenData',
        () async {
      try {
        _logger.d('HomeService: Fetching data for home screen', tag: 'Home');

        // Ambil data dari berbagai endpoint secara paralel untuk optimasi kinerja
        final results = await Future.wait([
          _homeRepository.getBanners(),
          _homeRepository.getFeaturedProducts(),
          _homeRepository.getRecentItems(),
        ]);

        // Susun data untuk UI
        final Map<String, dynamic> homeData = {
          'banners': results[0],
          'featuredProducts': results[1],
          'recentItems': results[2],
          'lastUpdated': DateTime.now().toIso8601String(),
        };

        _logger.d('HomeService: Successfully fetched home screen data',
            tag: 'Home');
        return homeData;
      } on SocketException catch (e, stackTrace) {
        _logger.e('HomeService: Network error occurred',
            error: e, stackTrace: stackTrace, tag: 'Home');
        throw Exception(
            'No internet connection. Please check your connection and try again.');
      } catch (e, stackTrace) {
        _logger.e('HomeService: Unexpected error fetching home data',
            error: e, stackTrace: stackTrace, tag: 'Home');
        throw Exception('Failed to load home data: ${e.toString()}');
      }
    });
  }

  /// Get banner data with business logic applied
  Future<List<Map<String, dynamic>>> getBanners() async {
    return _performanceService.measureAsync('HomeService.getBanners', () async {
      try {
        final banners = await _homeRepository.getBanners();

        // Terapkan logika bisnis
        // Misalnya: Filter banner yang aktif saja, urutkan berdasarkan prioritas, dll.
        final activeBanners = banners.where((banner) {
          // Contoh logika: hanya tampilkan banner yang aktif
          return banner['isActive'] == true;
        }).toList();

        // Urutkan berdasarkan prioritas atau urutan tertentu
        activeBanners.sort((a, b) =>
            (a['order'] as int? ?? 0).compareTo(b['order'] as int? ?? 0));

        return activeBanners;
      } catch (e, stackTrace) {
        _logger.e('HomeService: Error fetching banners',
            error: e, stackTrace: stackTrace, tag: 'Home');
        rethrow;
      }
    });
  }

  /// Get featured products with business logic applied
  Future<List<Map<String, dynamic>>> getFeaturedProducts() async {
    return _performanceService.measureAsync('HomeService.getFeaturedProducts',
        () async {
      try {
        final products = await _homeRepository.getFeaturedProducts();

        // Terapkan logika bisnis
        // Misalnya: Filter produk dengan stok tersedia, tambahkan flag diskon, dll.
        final availableProducts = products.where((product) {
          // Contoh logika: hanya tampilkan produk dengan stok > 0
          return (product['stock'] as int? ?? 0) > 0;
        }).toList();

        // Tambahkan informasi tambahan yang diperlukan UI
        for (var product in availableProducts) {
          // Contoh: hitung diskon
          final price = product['price'] as double? ?? 0.0;
          final originalPrice = product['originalPrice'] as double? ?? price;

          if (originalPrice > price) {
            final discountPercentage =
                ((originalPrice - price) / originalPrice * 100).round();
            product['discountPercentage'] = discountPercentage;
            product['hasDiscount'] = true;
          } else {
            product['hasDiscount'] = false;
          }
        }

        return availableProducts;
      } catch (e, stackTrace) {
        _logger.e('HomeService: Error fetching featured products',
            error: e, stackTrace: stackTrace, tag: 'Home');
        rethrow;
      }
    });
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  @override
  String toString() => message;
}
