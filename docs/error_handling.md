# Error Handling & Logging

Flutter Provider Kit includes a comprehensive error handling and logging system to help you manage errors effectively and debug issues in your application.

## Overview

The error handling system consists of three main components:

1. **ErrorHandlerService**: A centralized service that captures and manages errors across the application.
2. **LoggerService**: A service that provides structured logging with different severity levels.
3. **Error UI Components**: A set of reusable widgets for displaying errors in a consistent manner.

## LoggerService

The `LoggerService` provides structured logging with support for different log levels:

```dart
// Import the service
import '../../core/mahas/services/logger_service.dart';
import '../../core/di/service_locator.dart';

// Get the instance
final logger = serviceLocator<LoggerService>();

// Log at different levels
logger.d('Debug message');
logger.i('Info message', tag: 'AUTH');
logger.w('Warning message');
logger.e('Error message', error: exception, stackTrace: stackTrace);
logger.f('Fatal error', error: error);
```

### Log Levels

- **Debug (d)**: Detailed information, typically useful only when diagnosing problems.
- **Info (i)**: Confirmation that things are working as expected.
- **Warning (w)**: Indication that something unexpected happened, but the application can continue.
- **Error (e)**: Errors that prevented some function from working correctly.
- **Fatal (f)**: Very severe errors that might cause the application to terminate.

### Tags

You can add a tag to your log messages to categorize them:

```dart
logger.i('User profile updated', tag: 'PROFILE');
```

### Log Viewer

A built-in Log Viewer is available for development:

```dart
Navigator.pushNamed(context, '/log-viewer');
```

The Log Viewer allows you to:

- View all logs in the current session
- Filter logs by level
- Search log messages
- Copy logs to the clipboard
- Clear logs

## ErrorHandlerService

The `ErrorHandlerService` provides a centralized way to handle errors in your application:

```dart
// Import the service
import '../../core/mahas/services/error_handler_service.dart';
import '../../core/di/service_locator.dart';

// Get the instance
final errorHandler = serviceLocator<ErrorHandlerService>();

// Handle errors
try {
  // Some code that might throw an error
} catch (e, stackTrace) {
  errorHandler.handleError(e, stackTrace, context);
}

// For async functions, use guardAsync
await errorHandler.guardAsync(() async {
  // Async code that might throw an error
}, context);
```

### Error Reporting

You can configure a custom error reporting function:

```dart
// Setup error reporting (e.g., to Firebase Crashlytics)
errorHandler.setErrorReportingFunction((error, stackTrace, reason) {
  FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: reason);
});
```

### Custom Error UI

You can also configure a custom error UI handler:

```dart
// Setup custom error UI
errorHandler.setErrorUIFunction((context, error, stackTrace) {
  showCustomErrorDialog(context, error);
});
```

## Error UI Components

Flutter Provider Kit includes several reusable widgets for displaying errors:

### ErrorPlaceholderWidget

A simple widget to display an error message:

```dart
ErrorPlaceholderWidget(
  icon: Icons.cloud_off,
  message: 'No internet connection',
)
```

### ErrorWithActionWidget

A widget that displays an error message with an action button:

```dart
ErrorWithActionWidget(
  title: 'Data could not be loaded',
  message: 'There was an issue loading your data',
  actionText: 'Try Again',
  onAction: () {
    // Handle retry
  },
)
```

### ErrorDialog

A dialog that shows error details with options for dismissal or retry:

```dart
// Using the extension method on BuildContext
context.showErrorDialog(
  title: 'Error',
  message: 'Failed to save data',
  technicalDetails: error.toString(),
  onRetry: () {
    // Handle retry
  },
);
```

## Best Practices

1. **Use the right log level**: Reserve error logs for actual errors, and use debug logs for development information.

2. **Add descriptive tags**: Use tags to categorize logs and make them easier to filter and search.

3. **Wrap async operations**: Use `guardAsync` for async operations that might fail.

4. **Provide retry options**: When displaying errors to users, always provide a way to retry the operation when applicable.

5. **Handle network errors gracefully**: Detect and handle network connectivity issues in a user-friendly way.

6. **Include error codes**: When appropriate, include error codes in your error messages to aid in troubleshooting.

7. **Never expose sensitive data**: Ensure error messages don't include sensitive information.

## Integration with Providers

For a Provider-based architecture, integrate error handling as follows:

```dart
class MyProvider extends BaseProvider {
  final ErrorHandlerService _errorHandler;
  final LoggerService _logger;

  MyProvider({
    required ErrorHandlerService errorHandler,
    required LoggerService logger,
  }) : _errorHandler = errorHandler,
       _logger = logger;

  Future<void> loadData() async {
    return _errorHandler.guardAsync(() async {
      _logger.i('Loading data...');
      // Your data loading code
    }, context);
  }
}
```

## Error Handling Architecture

Below is a diagram illustrating the error handling architecture in the Flutter Provider Kit:

```
┌─────────────────────┐     ┌─────────────────────┐
│                     │     │                     │
│    Your App Code    │────►│  ErrorHandlerService│
│                     │     │                     │
└─────────────────────┘     └───────────┬─────────┘
                                        │
                                        ▼
                            ┌─────────────────────┐
                            │                     │
                            │   LoggerService     │
                            │                     │
                            └───────────┬─────────┘
                                        │
                  ┌────────────────────┴─────────────────────┐
                  │                                          │
                  ▼                                          ▼
       ┌─────────────────────┐                   ┌─────────────────────┐
       │                     │                   │                     │
       │  Error UI Components│                   │  Error Reporting    │
       │                     │                   │  (e.g. Crashlytics) │
       └─────────────────────┘                   └─────────────────────┘
```

## Conclusion

With the error handling and logging system in Flutter Provider Kit, you can:

- Capture and handle errors consistently across your app
- Log events at appropriate levels
- Display user-friendly error messages
- Debug issues more effectively
- Report errors to external services

For more details, refer to the API documentation for `ErrorHandlerService`, `LoggerService`, and the error UI components.
