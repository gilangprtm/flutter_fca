import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_fca/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Performance Tests', () {
    testWidgets('Measure app startup time', (WidgetTester tester) async {
      final binding = IntegrationTestWidgetsFlutterBinding.instance;

      // Start performance timing
      await binding.traceAction(() async {
        // Start app
        app.main();

        // Wait for app to fully load
        await tester.pumpAndSettle();

        // Verify app has loaded by checking for a key element
        expect(find.byKey(const Key('email_field')), findsOneWidget);
      }, reportKey: 'startup_time');
    });

    testWidgets('Measure login performance', (WidgetTester tester) async {
      final binding = IntegrationTestWidgetsFlutterBinding.instance;

      // Start app
      app.main();
      await tester.pumpAndSettle();

      // Measure login performance
      await binding.traceAction(() async {
        // Enter credentials
        await tester.enterText(
            find.byKey(const Key('email_field')), 'test@example.com');
        await tester.enterText(
            find.byKey(const Key('password_field')), 'password123');

        // Tap login button
        await tester.tap(find.byKey(const Key('login_button')));

        // Wait for login process and navigation
        await tester.pumpAndSettle();

        // Verify we're on the home screen
        expect(find.text('Home'), findsOneWidget);
      }, reportKey: 'login_performance');
    });

    testWidgets('Measure navigation performance', (WidgetTester tester) async {
      final binding = IntegrationTestWidgetsFlutterBinding.instance;

      // Start app and login
      app.main();
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(
          find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('password_field')), 'password123');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Measure navigation performance
      await binding.traceAction(() async {
        // Navigate to profile
        final profileButton = find.byIcon(Icons.person);
        await tester.tap(profileButton);
        await tester.pumpAndSettle();

        // Verify profile screen
        expect(find.text('Profile'), findsOneWidget);

        // Navigate back to home
        final backButton = find.byIcon(Icons.arrow_back);
        await tester.tap(backButton);
        await tester.pumpAndSettle();

        // Verify back on home screen
        expect(find.text('Home'), findsOneWidget);
      }, reportKey: 'navigation_performance');
    });

    testWidgets('Measure scrolling performance', (WidgetTester tester) async {
      final binding = IntegrationTestWidgetsFlutterBinding.instance;

      // Start app and login
      app.main();
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(
          find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('password_field')), 'password123');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Find a scrollable list
      final listFinder = find.byType(ListView);
      expect(listFinder, findsOneWidget);

      // Measure scrolling performance
      await binding.traceAction(() async {
        // Scroll down
        await tester.fling(listFinder, const Offset(0, -500), 1000);
        await tester.pumpAndSettle();

        // Scroll up
        await tester.fling(listFinder, const Offset(0, 500), 1000);
        await tester.pumpAndSettle();
      }, reportKey: 'scrolling_performance');
    });
  });
}
