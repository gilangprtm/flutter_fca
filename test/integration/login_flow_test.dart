import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_fca/main.dart' as app;
import 'package:provider/provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Flow Test', () {
    testWidgets('Complete login flow and navigation to home screen',
        (WidgetTester tester) async {
      // Start app
      app.main();

      // Wait for app to fully load
      await tester.pumpAndSettle();

      // Verify we're on the login screen (look for login form elements)
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);

      // Enter credentials
      await tester.enterText(
          find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('password_field')), 'password123');

      // Tap login button
      await tester.tap(find.byKey(const Key('login_button')));

      // Wait for login process and navigation
      await tester.pumpAndSettle();

      // Verify we're on the home screen (look for home screen elements)
      // This will depend on what elements are on your home screen
      expect(find.text('Home'), findsOneWidget);

      // Test navigation within the app
      // This will depend on your app's navigation structure
      final profileButton = find.byIcon(Icons.person);
      expect(profileButton, findsOneWidget);

      // Navigate to profile
      await tester.tap(profileButton);
      await tester.pumpAndSettle();

      // Verify profile screen
      expect(find.text('Profile'), findsOneWidget);

      // Test logout
      final logoutButton = find.text('Logout');
      expect(logoutButton, findsOneWidget);

      await tester.tap(logoutButton);
      await tester.pumpAndSettle();

      // Verify we're back on login screen
      expect(find.byKey(const Key('login_button')), findsOneWidget);
    });

    testWidgets('Failed login shows error message',
        (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      // Find form elements
      final emailField = find.byKey(const Key('email_field'));
      final passwordField = find.byKey(const Key('password_field'));
      final loginButton = find.byKey(const Key('login_button'));

      // Enter invalid credentials
      await tester.enterText(emailField, 'invalid@example.com');
      await tester.enterText(passwordField, 'wrongpassword');

      // Tap login button
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.byKey(const Key('error_text')), findsOneWidget);

      // Verify we're still on login screen
      expect(find.byKey(const Key('login_button')), findsOneWidget);
    });
  });
}
