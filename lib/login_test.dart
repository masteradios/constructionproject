import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hiten/screens/auth/auth.dart'; // Import the Flutter Login package

void main() {
  testWidgets('Login Page UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(MaterialApp(
      home:
          LoginScreen(), // Replace LoginScreen with your actual login screen widget
    ));

    // Find the email and password fields by type
    final Finder emailFieldFinder = find.byKey(const Key('login-field-email'));
    final Finder passwordFieldFinder =
        find.byKey(const Key('login-field-password'));

    // Verify that email and password fields are initially empty
    expect(
        find.text(''),
        findsNWidgets(
            2)); // Change the number if there are other text widgets initially

    // Enter text into the email and password fields
    await tester.enterText(emailFieldFinder, 'test@example.com');
    await tester.enterText(passwordFieldFinder, 'password123');

    // Verify that the entered text appears correctly in the fields
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('password123'), findsOneWidget);

    // Tap the login button
    final Finder loginButtonFinder = find.text('LOGIN');
    await tester.tap(loginButtonFinder);

    // Rebuild the widget after the state has changed
    await tester.pump();

    // Verify that the Welcome message appears on the home screen
    expect(find.text('Welcome'), findsOneWidget);
  });
}
