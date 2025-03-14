import 'package:flutter/material.dart';
import '../../core/mahas/services/logger_service.dart';
import '../../core/mahas/services/error_handler_service.dart';
import '../../core/di/service_locator.dart';

/// A base class for all providers in the application that extends [ChangeNotifier].
///
/// This class provides lifecycle methods that are called from [BaseWidget] during
/// widget lifecycle events. It also provides access to the [BuildContext] from the widget.
abstract class BaseProvider extends ChangeNotifier {
  BuildContext? _context;

  // Core services made available to all providers
  final LoggerService _logger = serviceLocator<LoggerService>();
  final ErrorHandlerService _errorHandler =
      serviceLocator<ErrorHandlerService>();

  // Expose services to subclasses
  LoggerService get logger => _logger;
  ErrorHandlerService get errorHandler => _errorHandler;

  /// Returns the current [BuildContext] associated with this provider.
  BuildContext? get context => _context;

  /// Gets the tag for logging, uses the class name by default.
  /// Subclasses can override this to provide a custom tag.
  String get logTag => runtimeType.toString();

  /// Sets the [BuildContext] associated with this provider.
  ///
  /// This is called by [BaseWidget] during initialization to provide
  /// context-aware operations in the provider.
  void setContext(BuildContext context) {
    _context = context;
  }

  /// Called when the provider is first created.
  ///
  /// Use this method to initialize state or setup listeners.
  /// This is called by [BaseWidget] during [initState].
  void onInit() {
    _logger.i('onInit called', tag: logTag);
    // To be overridden by subclasses
  }

  /// Called after [onInit] and when the widget is ready.
  ///
  /// Use this method to perform tasks that should happen after the UI is built,
  /// such as fetching initial data.
  void onReady() {
    _logger.i('onReady called', tag: logTag);
    // To be overridden by subclasses
  }

  /// Called when the provider is about to be disposed.
  ///
  /// Use this method to clean up resources such as listeners or subscriptions.
  /// This is called by [BaseWidget] during [dispose].
  @override
  void dispose() {
    onClose();
    super.dispose();
  }

  /// Called before [dispose] to allow cleanup.
  ///
  /// This method is separated from [dispose] to allow subclasses to perform
  /// custom cleanup without needing to call super.dispose().
  void onClose() {
    _logger.i('onClose called - cleaning up resources', tag: logTag);
    // To be overridden by subclasses
  }

  /// Helper method for handling synchronous operations with error handling
  T function<T>(T Function() action, {String? operationName}) {
    try {
      if (operationName != null) {
        _logger.d('Starting operation: $operationName', tag: logTag);
      }
      return action();
    } catch (e, stackTrace) {
      _logger.e(
        'Error in ${operationName ?? 'operation'}',
        error: e,
        stackTrace: stackTrace,
        tag: logTag,
      );

      if (context != null) {
        _errorHandler.handleAsyncError(e, stackTrace, context);
      }
      rethrow;
    } finally {
      _logger.d('Completed operation: $operationName', tag: logTag);
      notifyListeners();
    }
  }

  /// Helper method for handling asynchronous operations with error handling
  Future<T> functionAsync<T>(Future<T> Function() action,
      {String? operationName}) async {
    try {
      if (operationName != null) {
        _logger.d('Starting async operation: $operationName', tag: logTag);
      }
      final result = await action();
      if (operationName != null) {
        _logger.d('Completed async operation: $operationName', tag: logTag);
      }
      return result;
    } catch (e, stackTrace) {
      _logger.e(
        'Error in async ${operationName ?? 'operation'}',
        error: e,
        stackTrace: stackTrace,
        tag: logTag,
      );

      if (context != null) {
        await _errorHandler.handleAsyncError(e, stackTrace, context);
      }
      rethrow;
    } finally {
      _logger.d('Completed async operation: $operationName', tag: logTag);
      notifyListeners();
    }
  }
}
