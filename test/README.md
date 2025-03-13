# Testing Guide

This document provides information on how to run the various tests in the Flutter FCA project.

## Test Types

The project includes several types of tests:

1. **Unit Tests**: Test individual functions, methods, or classes
2. **Widget Tests**: Test UI components in isolation
3. **Integration Tests**: Test the app as a whole, simulating user interactions

## Running Tests

### Unit Tests

Run all unit tests with:

```bash
flutter test test/unit/
```

Or run specific test files:

```bash
flutter test test/unit/data/repository/user_repository_test.dart
flutter test test/unit/data/service/auth_service_test.dart
```

### Widget Tests

Run all widget tests with:

```bash
flutter test test/widget/
```

Or run specific widget tests:

```bash
flutter test test/widget/login_screen_test.dart
```

### Integration Tests

Integration tests require a connected device or emulator.

Run all integration tests with:

```bash
flutter test integration_test
```

Or run specific integration tests:

```bash
flutter test integration_test/app_test.dart
flutter test integration_test/login_flow_test.dart
flutter test integration_test/performance_test.dart
```

To collect performance metrics, use:

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/performance_test.dart \
  --profile
```

## Test Structure

- `test/unit/`: Contains unit tests for repositories, services, etc.
- `test/widget/`: Contains widget tests for UI components
- `test/integration/`: Contains integration tests for end-to-end flows
- `test/mocks/`: Contains mock classes for testing
- `test/helpers/`: Contains helper functions for testing

## Writing New Tests

### Unit Tests

1. Create a new file in the appropriate directory under `test/unit/`
2. Use the `test_helpers.dart` to set up service locator and mocks
3. Follow the existing test patterns

### Widget Tests

1. Create a new file in `test/widget/`
2. Use `testWidgets` to define widget tests
3. Follow the existing test patterns

### Integration Tests

1. Create a new file in `test/integration/`
2. Use `IntegrationTestWidgetsFlutterBinding.ensureInitialized()`
3. Follow the existing test patterns

## Best Practices

1. Keep tests focused and small
2. Use descriptive test names
3. Use `group` to organize related tests
4. Mock external dependencies
5. Clean up after tests using `tearDown`
6. Use `setUp` for common test initialization
7. Test both success and failure cases
