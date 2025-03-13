import '../db/dio_service.dart';
import '../../../../core/mahas/services/logger_service.dart';
import 'base_repository.dart';

/// HomeRepository yang bertanggung jawab untuk semua endpoint terkait home screen
class HomeRepository extends BaseRepository {
  HomeRepository({
    required DioService dioService,
    required LoggerService logger,
  }) : super(dioService: dioService, logger: logger);

  /// Get home data including banners, featured items, etc.
  Future<Map<String, dynamic>> getHomeData() async {
    logDebug('Getting home data');
    try {
      final response = await dioService.get<Map<String, dynamic>>(
        '/home',
        strategy: CacheStrategy.cacheFirst,
        cacheDuration: const Duration(minutes: 5),
      );
      logDebug('Successfully retrieved home data');
      return response;
    } catch (e, stackTrace) {
      logError('Failed to get home data', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Get featured banners
  Future<List<Map<String, dynamic>>> getBanners() async {
    logDebug('Getting banners');
    try {
      final response = await dioService.get<Map<String, dynamic>>(
        '/banners',
        strategy: CacheStrategy.cacheFirst,
        cacheDuration: const Duration(minutes: 10),
      );

      final List<dynamic> data = response['data'] as List<dynamic>;
      final banners =
          data.map((banner) => banner as Map<String, dynamic>).toList();

      logDebug('Successfully retrieved ${banners.length} banners');
      return banners;
    } catch (e, stackTrace) {
      logError('Failed to get banners', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Get featured products
  Future<List<Map<String, dynamic>>> getFeaturedProducts() async {
    logDebug('Getting featured products');
    try {
      final response = await dioService.get<Map<String, dynamic>>(
        '/products/featured',
        strategy: CacheStrategy.cacheFirst,
        cacheDuration: const Duration(minutes: 15),
      );

      final List<dynamic> data = response['data'] as List<dynamic>;
      final products =
          data.map((product) => product as Map<String, dynamic>).toList();

      logDebug('Successfully retrieved ${products.length} featured products');
      return products;
    } catch (e, stackTrace) {
      logError('Failed to get featured products',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Get recent items
  Future<List<Map<String, dynamic>>> getRecentItems() async {
    logDebug('Getting recent items');
    try {
      final response = await dioService.get<Map<String, dynamic>>(
        '/items/recent',
        strategy:
            CacheStrategy.networkFirst, // Always try to get fresh data first
        cacheDuration: const Duration(minutes: 5),
      );

      final List<dynamic> data = response['data'] as List<dynamic>;
      final items = data.map((item) => item as Map<String, dynamic>).toList();

      logDebug('Successfully retrieved ${items.length} recent items');
      return items;
    } catch (e, stackTrace) {
      logError('Failed to get recent items', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
