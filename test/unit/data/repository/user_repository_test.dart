import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_fca/data/datasource/network/repository/user_repository.dart';
import 'package:flutter_fca/data/datasource/network/db/dio_service.dart';
import 'package:flutter_fca/core/mahas/services/logger_service.dart';
import '../../../helpers/test_helpers.dart';
import '../../../mocks/mock_services.dart';

void main() {
  late UserRepository userRepository;
  late MockDioService mockDioService;
  late MockLoggerService mockLoggerService;

  setUp(() {
    TestHelpers.setupServiceLocatorForTesting();
    mockDioService = TestHelpers.getService<DioService>() as MockDioService;
    mockLoggerService =
        TestHelpers.getService<LoggerService>() as MockLoggerService;

    userRepository = UserRepository(
      dioService: mockDioService,
      logger: mockLoggerService,
    );
  });

  tearDown(() {
    TestHelpers.unregisterAll();
  });

  group('UserRepository', () {
    final userId = 1;
    final mockUserData = {
      'id': userId,
      'email': 'test@example.com',
      'first_name': 'Test',
      'last_name': 'User',
      'avatar': 'https://example.com/avatar.jpg',
    };

    test('getUserById should return user data when successful', () async {
      // Arrange
      when(() => mockDioService.get<Map<String, dynamic>>(
            '/users/$userId',
            strategy: any(named: 'strategy'),
            cacheDuration: any(named: 'cacheDuration'),
          )).thenAnswer((_) async => mockUserData);

      // Act
      final result = await userRepository.getUserById(userId);

      // Assert
      expect(result, equals(mockUserData));
      verify(() => mockDioService.get<Map<String, dynamic>>(
            '/users/$userId',
            strategy: any(named: 'strategy'),
            cacheDuration: any(named: 'cacheDuration'),
          )).called(1);
    });

    test('getUserById should throw exception when API call fails', () async {
      // Arrange
      final exception = Exception('API Error');
      when(() => mockDioService.get<Map<String, dynamic>>(
            '/users/$userId',
            strategy: any(named: 'strategy'),
            cacheDuration: any(named: 'cacheDuration'),
          )).thenThrow(exception);

      // Act & Assert
      expect(() => userRepository.getUserById(userId), throwsException);
      verify(() => mockLoggerService.e(
            any(),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
            tag: any(named: 'tag'),
          )).called(1);
    });

    test('getUsers should return list of users when successful', () async {
      // Arrange
      final mockResponse = {
        'data': [mockUserData, mockUserData],
        'page': 1,
        'per_page': 10,
        'total': 2,
      };

      when(() => mockDioService.get<Map<String, dynamic>>(
            '/users',
            queryParameters: any(named: 'queryParameters'),
            strategy: any(named: 'strategy'),
            cacheDuration: any(named: 'cacheDuration'),
          )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await userRepository.getUsers(page: 1, perPage: 10);

      // Assert
      expect(result.length, equals(2));
      expect(result[0], equals(mockUserData));
      verify(() => mockDioService.get<Map<String, dynamic>>(
            '/users',
            queryParameters: any(named: 'queryParameters'),
            strategy: any(named: 'strategy'),
            cacheDuration: any(named: 'cacheDuration'),
          )).called(1);
    });
  });
}
