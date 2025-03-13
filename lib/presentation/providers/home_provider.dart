import 'package:flutter/material.dart';
import '../../core/base/base_provider.dart';
import '../../core/mahas/services/error_handler_service.dart';
import '../../core/mahas/services/logger_service.dart';
import '../../data/datasource/network/service/home_service.dart';

class HomeProvider extends BaseProvider {
  final HomeService homeService;
  final LoggerService _logger;
  final ErrorHandlerService _errorHandler;

  final int _count = 0;

  HomeProvider({
    required this.homeService,
    required LoggerService logger,
    required ErrorHandlerService errorHandler,
  })  : _logger = logger,
        _errorHandler = errorHandler;

  int get count => _count;

  @override
  void onInit() {
    super.onInit();
    _logger.i('HomeProvider: onInit called', tag: 'HOME');
    // Initialize data or setup listeners here
  }

  @override
  void onReady() {
    super.onReady();
    _logger.i('HomeProvider: onReady called', tag: 'HOME');
    // Perform tasks after the UI is built
    // For example, fetch initial data
    fetchInitialData();
  }

  @override
  void onClose() {
    _logger.i('HomeProvider: onClose called - cleaning up resources',
        tag: 'HOME');
    // Clean up resources when this provider is no longer needed
    // For example, cancel timers, listeners, or subscriptions
    super.onClose();
  }

  void incrementCount() {
    try {
      // Contoh penggunaan log
      _logger.d('Increment count called', tag: 'HOME');

      // Contoh pemanggilan service dengan error handling
      homeService.getFeaturedProducts();
    } catch (e, stackTrace) {
      // Tangani error
      _logger.e('Error in incrementCount',
          error: e, stackTrace: stackTrace, tag: 'HOME');

      // Tampilkan error UI jika konteks tersedia
      if (context != null) {
        _errorHandler.handleAsyncError(e, stackTrace, context);
      }
    }
  }

  Future<void> fetchInitialData() async {
    // Contoh penggunaan error handler untuk fungsi async
    return _errorHandler.guardAsync(() async {
      _logger.i('Fetching initial data', tag: 'HOME');

      try {
        await homeService.getFeaturedProducts();
        _logger.i('Initial data fetched successfully', tag: 'HOME');
      } catch (e) {
        _logger.e('Error fetching initial data', error: e, tag: 'HOME');
        rethrow; // Rethrow to be caught by guardAsync
      }
    }, context);
  }
}
