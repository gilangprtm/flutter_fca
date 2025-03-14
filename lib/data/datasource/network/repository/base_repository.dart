import '../db/dio_service.dart';
import '../../../../core/mahas/services/logger_service.dart';

/// Base repository class that provides common functionality for all repositories
abstract class BaseRepository {
  final DioService dioService = DioService();
  final LoggerService logger = LoggerService.instance;

  /// Log repository operations with appropriate tag
  void logInfo(String message) {
    logger.i(message, tag: 'Repository');
  }

  void logError(String message, {dynamic error, StackTrace? stackTrace}) {
    logger.e(message, error: error, stackTrace: stackTrace, tag: 'Repository');
  }

  void logDebug(String message) {
    logger.d(message, tag: 'Repository');
  }
}
