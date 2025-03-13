import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_fca/data/datasource/network/service/auth_service.dart';
import 'package:flutter_fca/data/datasource/network/repository/user_repository.dart';
import 'package:flutter_fca/core/mahas/services/logger_service.dart';
import 'package:flutter_fca/core/mahas/services/storage_service.dart';
import 'package:flutter_fca/core/mahas/services/performance_service.dart';
import '../../../helpers/test_helpers.dart';
import '../../../mocks/mock_services.dart';

void main() {
  late AuthService authService;
  late MockUserRepository mockUserRepository;
  late MockLoggerService mockLoggerService;
  late MockStorageService mockStorageService;
  late MockPerformanceService mockPerformanceService;

  setUp(() {
    TestHelpers.setupServiceLocatorForTesting();
    mockUserRepository =
        TestHelpers.getService<UserRepository>() as MockUserRepository;
    mockLoggerService =
        TestHelpers.getService<LoggerService>() as MockLoggerService;
    mockStorageService =
        TestHelpers.getService<StorageService>() as MockStorageService;
    mockPerformanceService =
        TestHelpers.getService<PerformanceService>() as MockPerformanceService;

    authService = AuthService(
      userRepository: mockUserRepository,
      logger: mockLoggerService,
      storageService: mockStorageService,
      performanceService: mockPerformanceService,
    );
  });

  tearDown(() {
    TestHelpers.unregisterAll();
  });

  group('AuthService', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    final mockLoginResponse = {
      'token': 'test-token-123',
      'user': {'id': 1, 'email': testEmail}
    };
    final mockUserData = {'id': 1, 'name': 'Test User'};

    test('login should return user data when successful', () async {
      // Arrange
      when(() => mockPerformanceService.measureAsync<Map<String, dynamic>>(
            any(),
            any(),
          )).thenAnswer((invocation) {
        final callback = invocation.positionalArguments[1]
            as Future<Map<String, dynamic>> Function();
        return callback();
      });

      when(() => mockUserRepository.loginUser(testEmail, testPassword))
          .thenAnswer((_) async => mockLoginResponse);

      when(() => mockStorageService.saveData(any(), any()))
          .thenAnswer((_) async => null);

      when(() => mockUserRepository.getUserById(any()))
          .thenAnswer((_) async => mockUserData);

      // Act
      final result = await authService.login(testEmail, testPassword);

      // Assert
      expect(result, equals(mockUserData));
      verify(() => mockUserRepository.loginUser(testEmail, testPassword))
          .called(1);
      verify(() => mockStorageService.saveData(any(), any()))
          .called(2); // Token and user data
      verify(() => mockUserRepository.getUserById(any())).called(1);
    });

    test('login should throw exception when login fails', () async {
      // Arrange
      when(() => mockPerformanceService.measureAsync<Map<String, dynamic>>(
            any(),
            any(),
          )).thenAnswer((invocation) {
        final callback = invocation.positionalArguments[1]
            as Future<Map<String, dynamic>> Function();
        return callback();
      });

      final exception = Exception('Login failed');
      when(() => mockUserRepository.loginUser(testEmail, testPassword))
          .thenThrow(exception);

      // Act & Assert
      expect(() => authService.login(testEmail, testPassword), throwsException);
      verify(() => mockLoggerService.e(
            any(),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
            tag: any(named: 'tag'),
          )).called(1);
    });

    test('isLoggedIn should return true when token exists', () async {
      // Arrange
      when(() => mockStorageService.getData(any()))
          .thenAnswer((_) async => 'valid-token');

      // Act
      final result = await authService.isLoggedIn();

      // Assert
      expect(result, isTrue);
      verify(() => mockStorageService.getData(any())).called(1);
    });

    test('isLoggedIn should return false when token does not exist', () async {
      // Arrange
      when(() => mockStorageService.getData(any()))
          .thenAnswer((_) async => null);

      // Act
      final result = await authService.isLoggedIn();

      // Assert
      expect(result, isFalse);
      verify(() => mockStorageService.getData(any())).called(1);
    });

    test('logout should clear token and user data', () async {
      // Arrange
      when(() => mockStorageService.removeData(any()))
          .thenAnswer((_) async => null);

      // Act
      await authService.logout();

      // Assert
      verify(() => mockStorageService.removeData(any()))
          .called(2); // Token and user data
      verify(() => mockLoggerService.d(any(), tag: any(named: 'tag')))
          .called(1);
    });
  });
}
