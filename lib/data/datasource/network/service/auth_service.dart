import 'dart:io';

import '../../../../core/mahas/services/logger_service.dart';
import '../../../../core/mahas/services/storage_service.dart';
import '../../../../core/mahas/services/performance_service.dart';
import '../repository/user_repository.dart';

/// Service for authentication related business logic
class AuthService {
  final UserRepository _userRepository;
  final LoggerService _logger;
  final StorageService _storageService;
  final PerformanceService _performanceService;

  // Constants
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'current_user';

  AuthService({
    required UserRepository userRepository,
    required LoggerService logger,
    required StorageService storageService,
    required PerformanceService performanceService,
  })  : _userRepository = userRepository,
        _logger = logger,
        _storageService = storageService,
        _performanceService = performanceService;

  /// Login a user and handle token storage
  Future<Map<String, dynamic>> login(String email, String password) async {
    return _performanceService.measureAsync('AuthService.login', () async {
      try {
        _logger.d('AuthService: Login attempt for user $email', tag: 'Auth');

        // Use the repository to call the login API
        final loginResponse = await _userRepository.loginUser(email, password);

        // Extract token
        final token = loginResponse['token'] as String?;
        if (token == null || token.isEmpty) {
          throw Exception('Invalid token received');
        }

        // Store token securely
        await _storageService.saveData(_tokenKey, token);

        // Get user details using the token
        final user = await getCurrentUser();

        // Store user data
        await _storageService.saveData(_userKey, user.toString());

        return user;
      } catch (e, stackTrace) {
        _logger.e('AuthService: Login failed',
            error: e, stackTrace: stackTrace, tag: 'Auth');
        if (e is SocketException) {
          throw Exception('No internet connection. Please try again later.');
        }
        throw Exception('Login failed: ${e.toString()}');
      }
    });
  }

  /// Get the current authenticated user
  Future<Map<String, dynamic>> getCurrentUser() async {
    return _performanceService.measureAsync('AuthService.getCurrentUser',
        () async {
      try {
        _logger.d('AuthService: Getting current user', tag: 'Auth');

        // Check if we have a cached user
        final cachedUser = await _storageService.getData(_userKey);
        if (cachedUser != null && cachedUser.toString().isNotEmpty) {
          // In real app, parse this string to a Map
          // This is just placeholder logic
          _logger.d('AuthService: Returning cached user', tag: 'Auth');
          return {'id': 1, 'name': 'Cached User'};
        }

        // If no cached user, fetch from API
        // Note: In a real app, you would use the token from storage to authenticate this request
        // and the repository would include the token in the API call
        final userId = 1; // In a real app, get this from the token
        final user = await _userRepository.getUserById(userId);

        // Cache the user
        await _storageService.saveData(_userKey, user.toString());

        return user;
      } catch (e, stackTrace) {
        _logger.e('AuthService: Failed to get current user',
            error: e, stackTrace: stackTrace, tag: 'Auth');
        throw Exception('Failed to get user information: ${e.toString()}');
      }
    });
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storageService.getData(_tokenKey);
    return token != null && token.toString().isNotEmpty;
  }

  /// Logout user
  Future<void> logout() async {
    _logger.d('AuthService: Logging out user', tag: 'Auth');
    await _storageService.removeData(_tokenKey);
    await _storageService.removeData(_userKey);
  }
}
