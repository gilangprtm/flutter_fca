import 'package:mocktail/mocktail.dart';
import 'package:flutter_fca/data/datasource/network/db/dio_service.dart';
import 'package:flutter_fca/core/mahas/services/logger_service.dart';
import 'package:flutter_fca/core/mahas/services/storage_service.dart';
import 'package:flutter_fca/core/mahas/services/performance_service.dart';
import 'package:flutter_fca/data/datasource/network/repository/user_repository.dart';
import 'package:flutter_fca/data/datasource/network/repository/home_repository.dart';
import 'package:flutter_fca/data/datasource/network/service/auth_service.dart';
import 'package:flutter_fca/data/datasource/network/service/home_service.dart';

// Mocks untuk core services
class MockDioService extends Mock implements DioService {}

class MockLoggerService extends Mock implements LoggerService {}

class MockStorageService extends Mock implements StorageService {}

class MockPerformanceService extends Mock implements PerformanceService {}

// Mocks untuk repositories
class MockUserRepository extends Mock implements UserRepository {}

class MockHomeRepository extends Mock implements HomeRepository {}

// Mocks untuk services
class MockAuthService extends Mock implements AuthService {}

class MockHomeService extends Mock implements HomeService {}
