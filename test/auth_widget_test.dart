import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:findit_ethiopia/controllers/auth_controller.dart';
import 'package:findit_ethiopia/screens/login_screen.dart';
import 'package:findit_ethiopia/screens/sign_up_screen.dart';

// Fake AuthController to bypass Firebase dependencies
class FakeAuthController extends ChangeNotifier implements AuthController {
  @override
  User? get user => null;
  
  @override
  bool get isLoading => false;
  
  @override
  String? get errorMessage => null;
  
  @override
  bool get isAuthenticated => false;

  @override
  Future<bool> signInWithEmail(String email, String password) async {
    return true;
  }

  @override
  Future<bool> signInWithGoogle() async {
    return true;
  }

  @override
  Future<bool> signUpWithEmail(String email, String password, String? name) async {
    return true;
  }

  @override
  Future<void> signOut() async {
    // Do nothing
  }
  
  // We need to implement/override all members if we 'implement' the class.
  // Since we are mocking manually, we just ensure the methods used by LoginScreen are present.
  // If the super class has logic, 'implements' ignores it. 'extends' inherits it.
  // We use 'implements' to avoid specific implementation details like constructor.
  
  // Checking additional methods/properties that might be needed.
  // The interface requires all public members.
  
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('LoginScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthController>(
        create: (_) => FakeAuthController(),
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Verify the presence of email and password fields
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Login'), findsWidgets); // Button and Title
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
  });

  testWidgets('SignUpScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthController>(
        create: (_) => FakeAuthController(),
        child: const MaterialApp(
          home: SignUpScreen(),
        ),
      ),
    );

    // Verify the presence of name, email, password, confirm password fields
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.text('Sign Up'), findsWidgets); // Button and Title
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
  });
}
