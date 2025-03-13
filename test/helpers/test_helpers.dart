import 'package:flutter_fca/core/di/service_locator.dart';
import 'package:flutter_fca/core/mahas/services/logger_service.dart';
import 'package:flutter_fca/core/mahas/services/performance_service.dart';
import 'package:flutter_fca/core/mahas/services/storage_service.dart';
import 'package:flutter_fca/data/datasource/network/db/dio_service.dart';
import 'package:flutter_fca/data/datasource/network/repository/home_repository.dart';
import 'package:flutter_fca/data/datasource/network/repository/user_repository.dart';
import 'package:flutter_fca/data/datasource/network/service/auth_service.dart';
import 'package:flutter_fca/data/datasource/network/service/home_service.dart';
import 'package:get_it/get_it.dart';
import '../mocks/mock_services.dart';

/// Helper class untuk setup testing
class TestHelpers {
  /// Setup service locator untuk testing
  static void setupServiceLocatorForTesting() {
    // Reset service locator
    serviceLocator.reset();

    // Register mocks
    _setupCoreMocks();
    _setupRepositoryMocks();
    _setupServiceMocks();
  }

  /// Setup core service mocks
  static void _setupCoreMocks() {
    // Core services
    serviceLocator.registerSingleton<LoggerService>(MockLoggerService());
    serviceLocator
        .registerSingleton<PerformanceService>(MockPerformanceService());
    serviceLocator.registerSingleton<StorageService>(MockStorageService());
    serviceLocator.registerSingleton<DioService>(MockDioService());
  }

  /// Setup repository mocks
  static void _setupRepositoryMocks() {
    // Repositories
    serviceLocator.registerSingleton<UserRepository>(MockUserRepository());
    serviceLocator.registerSingleton<HomeRepository>(MockHomeRepository());
  }

  /// Setup service mocks
  static void _setupServiceMocks() {
    // Services
    serviceLocator.registerSingleton<AuthService>(MockAuthService());
    serviceLocator.registerSingleton<HomeService>(MockHomeService());
  }

  /// Unregister semua mocks
  static void unregisterAll() {
    serviceLocator.reset();
  }

  /// Get mock instance
  static T getService<T extends Object>() {
    return serviceLocator<T>();
  }
}
