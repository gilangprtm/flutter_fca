import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fca/data/datasource/network/service/auth_service.dart';
import '../helpers/test_helpers.dart';
import '../mocks/mock_services.dart';

// Contoh provider untuk login
class LoginProvider extends ChangeNotifier {
  final AuthService _authService;
  bool isLoading = false;
  String? errorMessage;

  LoginProvider(this._authService);

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _authService.login(email, password);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}

// Contoh login screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              key: const Key('email_field'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              key: const Key('password_field'),
            ),
            const SizedBox(height: 16),
            if (provider.isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () {
                  provider.login(
                    _emailController.text,
                    _passwordController.text,
                  );
                },
                child: const Text('Login'),
                key: const Key('login_button'),
              ),
            if (provider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  provider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  key: const Key('error_text'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    TestHelpers.setupServiceLocatorForTesting();
    mockAuthService = TestHelpers.getService<AuthService>() as MockAuthService;
  });

  tearDown(() {
    TestHelpers.unregisterAll();
  });

  Widget createTestableWidget() {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => LoginProvider(mockAuthService),
        child: const LoginScreen(),
      ),
    );
  }

  group('LoginScreen', () {
    testWidgets('should display login form', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestableWidget());

      // Assert
      expect(find.text('Login'), findsNWidgets(2)); // AppBar and button
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);
    });

    testWidgets('should show loading indicator when login is in progress',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthService.login(any(), any()))
          .thenAnswer((_) => Future.delayed(const Duration(seconds: 1)));

      await tester.pumpWidget(createTestableWidget());

      // Act
      await tester.enterText(
          find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('password_field')), 'password123');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump(); // Rebuild after tap

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsNothing);
    });

    testWidgets('should show error message when login fails',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthService.login(any(), any()))
          .thenThrow(Exception('Invalid credentials'));

      await tester.pumpWidget(createTestableWidget());

      // Act
      await tester.enterText(
          find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('password_field')), 'password123');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump(); // Rebuild after tap

      // Assert
      expect(find.byKey(const Key('error_text')), findsOneWidget);
      expect(find.text('Exception: Invalid credentials'), findsOneWidget);
    });
  });
}
