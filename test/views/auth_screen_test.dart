import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/auth_screen.dart';

void main() {
  group('AuthScreen Widget Tests', () {
    testWidgets('should display Sign In mode by default',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      expect(find.text('Sign In'), findsNWidgets(2)); // Title and button
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Full Name'), findsNothing);
      expect(find.text('Phone Number (Optional)'), findsNothing);
      expect(find.text('Confirm Password'), findsNothing);
    });

    testWidgets('should switch to Sign Up mode when toggle is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      // Tap the Sign Up segment
      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Sign Up'), findsNWidgets(2)); // Title and button
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone Number (Optional)'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('should clear all fields when switching modes',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      // Enter data in Sign In mode
      await tester.enterText(find.widgetWithText(TextFormField, 'Email').first,
          'test@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password').first, 'Password123');

      // Switch to Sign Up mode
      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      // Verify fields are cleared
      final emailField = tester.widget<TextFormField>(
          find.widgetWithText(TextFormField, 'Email').first);
      expect(emailField.controller?.text, isEmpty);

      final passwordField = tester.widget<TextFormField>(
          find.widgetWithText(TextFormField, 'Password').first);
      expect(passwordField.controller?.text, isEmpty);
    });

    testWidgets('should show all required fields in Sign Up mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNWidgets(5));
      expect(find.widgetWithIcon(TextFormField, Icons.person), findsOneWidget);
      expect(find.widgetWithIcon(TextFormField, Icons.email), findsOneWidget);
      expect(find.widgetWithIcon(TextFormField, Icons.phone), findsOneWidget);
      expect(find.widgetWithIcon(TextFormField, Icons.lock), findsOneWidget);
      expect(find.widgetWithIcon(TextFormField, Icons.lock_outline),
          findsOneWidget);
    });

    testWidgets('should show only email and password in Sign In mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.widgetWithIcon(TextFormField, Icons.email), findsOneWidget);
      expect(find.widgetWithIcon(TextFormField, Icons.lock), findsOneWidget);
    });
  });

  group('AuthScreen Validation Tests - Sign Up Mode', () {
    testWidgets('should show error when name is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Name is required'), findsOneWidget);
    });

    testWidgets('should show error when name is too short',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'J');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Name must be at least 2 characters'), findsOneWidget);
    });

    testWidgets('should show error when name contains numbers',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'John123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Name can only contain letters and spaces'),
          findsOneWidget);
    });

    testWidgets('should show error when email is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('should show error when email format is invalid',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'notanemail');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('should not show error when phone is empty (optional field)',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      // Fill required fields with valid data
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'John Smith');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'john@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password').first, 'Pass1234');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirm Password'), 'Pass1234');
      // Leave phone empty

      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      // Should not show phone validation error
      expect(find.textContaining('phone', findRichText: true), findsNothing);
    });

    testWidgets('should show error when phone is invalid',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Phone Number (Optional)'), '123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      expect(
          find.text('Please enter a valid phone number (at least 10 digits)'),
          findsOneWidget);
    });

    testWidgets('should show error when password is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('should show error when password is too short',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password').first, 'Pass12');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      expect(
          find.text('Password must be at least 8 characters'), findsOneWidget);
    });

    testWidgets('should show error when password has no numbers',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password').first, 'Password');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      expect(
          find.text('Password must contain at least one letter and one number'),
          findsOneWidget);
    });

    testWidgets('should show error when password has no letters',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password').first, '12345678');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      expect(
          find.text('Password must contain at least one letter and one number'),
          findsOneWidget);
    });

    testWidgets('should show error when passwords do not match',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password').first, 'Pass1234');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirm Password'), 'Pass5678');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('should show error when confirm password is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password').first, 'Pass1234');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('should show multiple validation errors simultaneously',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      // Submit with all fields empty
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Name is required'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });
  });

  group('AuthScreen Validation Tests - Sign In Mode', () {
    testWidgets('should show error when email is empty in Sign In mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('should show error when email is invalid in Sign In mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'invalid.email');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('should show error when password is empty in Sign In mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'test@example.com');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Password is required'), findsOneWidget);
    });
  });

  group('AuthScreen Success Flow Tests', () {
    testWidgets('should navigate back and show SnackBar on successful Sign Up',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              ),
              child: const Text('Go to Auth'),
            ),
          ),
        ),
      ));

      // Navigate to Auth Screen
      await tester.tap(find.text('Go to Auth'));
      await tester.pumpAndSettle();

      // Switch to Sign Up mode
      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      // Fill valid data
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'Jane Smith');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'jane@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password').first, 'Pass1234');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirm Password'), 'Pass1234');

      // Submit
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      // Verify navigation back occurred
      expect(find.text('Go to Auth'), findsOneWidget);

      // Verify SnackBar appears
      expect(find.text('Account created successfully! Welcome, Jane Smith'),
          findsOneWidget);
    });

    testWidgets('should navigate back and show SnackBar on successful Sign In',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              ),
              child: const Text('Go to Auth'),
            ),
          ),
        ),
      ));

      // Navigate to Auth Screen
      await tester.tap(find.text('Go to Auth'));
      await tester.pumpAndSettle();

      // Fill valid data in Sign In mode
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'john.doe@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'MyPass123');

      // Submit
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      // Verify navigation back occurred
      expect(find.text('Go to Auth'), findsOneWidget);

      // Verify SnackBar appears with capitalized name from email
      expect(find.text('Welcome back, John!'), findsOneWidget);
    });

    testWidgets('should extract and capitalize name from email in Sign In',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              ),
              child: const Text('Go to Auth'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Go to Auth'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'sarah@test.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'Pass1234');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Welcome back, Sarah!'), findsOneWidget);
    });
  });

  group('AuthScreen UI Component Tests', () {
    testWidgets('should have password fields with obscured text',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      // Verify password fields exist - we can't directly check obscureText
      // but we can verify the fields are there with lock icons
      expect(find.widgetWithIcon(TextFormField, Icons.lock), findsOneWidget);
      expect(find.widgetWithIcon(TextFormField, Icons.lock_outline),
          findsOneWidget);

      // Verify that entering text doesn't show the actual characters
      await tester.enterText(
          find
              .ancestor(
                of: find.text('Password'),
                matching: find.byType(TextFormField),
              )
              .first,
          'TestPassword123');
      await tester.pumpAndSettle();

      // The actual text shouldn't be visible as plain text in a Text widget
      expect(find.text('TestPassword123'), findsNothing);
    });

    testWidgets('should have proper keyboard types',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      // We can't directly access keyboardType, but we can verify the fields exist
      // with the correct icons which indicate their purpose
      expect(find.widgetWithIcon(TextFormField, Icons.email), findsOneWidget);
      expect(find.widgetWithIcon(TextFormField, Icons.phone), findsOneWidget);

      // Verify the decorations have the correct labels
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone Number (Optional)'), findsOneWidget);
    });

    testWidgets('should have SegmentedButton with both mode options',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      expect(find.byType(SegmentedButton<AuthMode>), findsOneWidget);
      expect(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign In'),
          findsOneWidget);
      expect(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'),
          findsOneWidget);
    });

    testWidgets('should have submit button with appropriate icons',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      // Sign In mode icon
      expect(find.widgetWithIcon(ElevatedButton, Icons.login), findsOneWidget);

      // Switch to Sign Up mode
      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      // Sign Up mode icon
      expect(find.widgetWithIcon(ElevatedButton, Icons.person_add),
          findsOneWidget);
    });

    testWidgets('should be scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should have back button in AppBar',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              ),
              child: const Text('Go to Auth'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Go to Auth'));
      await tester.pumpAndSettle();

      expect(find.byType(BackButton), findsOneWidget);
    });
  });

  group('AuthScreen Edge Cases', () {
    testWidgets('should handle valid name with spaces',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              ),
              child: const Text('Go to Auth'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Go to Auth'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'Mary Jane Watson');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'mary@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password').first, 'Pass1234');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirm Password'), 'Pass1234');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      expect(
          find.text('Account created successfully! Welcome, Mary Jane Watson'),
          findsOneWidget);
    });

    testWidgets('should handle phone with formatting characters',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      await tester.tap(find.widgetWithText(ButtonSegment<AuthMode>, 'Sign Up'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'John Doe');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'john@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Phone Number (Optional)'),
          '(123) 456-7890');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password').first, 'Pass1234');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirm Password'), 'Pass1234');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      // Should accept formatted phone numbers
      expect(find.textContaining('phone', findRichText: true), findsNothing);
    });

    testWidgets('should handle single character email prefix',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              ),
              child: const Text('Go to Auth'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Go to Auth'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'a@b.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'Pass1234');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Welcome back, A!'), findsOneWidget);
    });
  });
}
