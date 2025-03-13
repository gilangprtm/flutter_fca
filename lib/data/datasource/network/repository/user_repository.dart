import '../db/dio_service.dart';
import '../../../../core/mahas/services/logger_service.dart';
import 'base_repository.dart';

/// UserRepository yang bertanggung jawab untuk semua endpoint terkait user
class UserRepository extends BaseRepository {
  UserRepository({
    required DioService dioService,
    required LoggerService logger,
  }) : super(dioService: dioService, logger: logger);

  /// Get user by ID
  Future<Map<String, dynamic>> getUserById(int userId) async {
    logDebug('Getting user with ID: $userId');
    try {
      final response = await dioService.get<Map<String, dynamic>>(
        '/users/$userId',
        strategy: CacheStrategy.cacheFirst,
        cacheDuration: const Duration(minutes: 5),
      );
      logDebug('Successfully retrieved user with ID: $userId');
      return response;
    } catch (e, stackTrace) {
      logError('Failed to get user with ID: $userId',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Get all users with optional pagination
  Future<List<Map<String, dynamic>>> getUsers(
      {int page = 1, int perPage = 10}) async {
    logDebug('Getting users (page: $page, perPage: $perPage)');
    try {
      final response = await dioService.get<Map<String, dynamic>>(
        '/users',
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
        strategy: CacheStrategy.cacheFirst,
        cacheDuration: const Duration(minutes: 5),
      );

      final List<dynamic> data = response['data'] as List<dynamic>;
      final users = data.map((user) => user as Map<String, dynamic>).toList();

      logDebug('Successfully retrieved ${users.length} users');
      return users;
    } catch (e, stackTrace) {
      logError('Failed to get users list', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Create new user
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    logDebug('Creating new user');
    try {
      final response = await dioService.post<Map<String, dynamic>>(
        '/users',
        data: userData,
      );
      logDebug('Successfully created user');
      return response;
    } catch (e, stackTrace) {
      logError('Failed to create user', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Update existing user
  Future<Map<String, dynamic>> updateUser(
      int userId, Map<String, dynamic> userData) async {
    logDebug('Updating user with ID: $userId');
    try {
      final response = await dioService.put<Map<String, dynamic>>(
        '/users/$userId',
        data: userData,
      );
      logDebug('Successfully updated user with ID: $userId');
      return response;
    } catch (e, stackTrace) {
      logError('Failed to update user with ID: $userId',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Delete user
  Future<void> deleteUser(int userId) async {
    logDebug('Deleting user with ID: $userId');
    try {
      await dioService.delete<Map<String, dynamic>>(
        '/users/$userId',
      );
      logDebug('Successfully deleted user with ID: $userId');
    } catch (e, stackTrace) {
      logError('Failed to delete user with ID: $userId',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Login user
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    logDebug('Logging in user with email: $email');
    try {
      final response = await dioService.post<Map<String, dynamic>>(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      logDebug('User login successful for email: $email');
      return response;
    } catch (e, stackTrace) {
      logError('Login failed for email: $email',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
