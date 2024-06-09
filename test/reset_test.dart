// reset_test.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:train_tracker/components/reset.dart';
import 'package:train_tracker/state/user_provider.dart';

import 'reset_test.mocks.dart';

@GenerateMocks([FirebaseAuth])
void main() {
  late MockFirebaseAuth mockFirebaseAuth;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
  });

  Future<void> pumpPasswordResetWidget(
      WidgetTester tester, MockFirebaseAuth mockAuth) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: MaterialApp(
          home: PasswordReset(firebaseAuth: mockAuth),
        ),
      ),
    );
  }

  group('PasswordReset Widget Tests', () {
    testWidgets('Displays required validation error for empty email field',
        (WidgetTester tester) async {
      await pumpPasswordResetWidget(tester, mockFirebaseAuth);

      // Tap the submit button without entering an email
      await tester.tap(find.text('Submit'));
      await tester.pump();

      // Check for validation error message
      expect(find.text('Email is required!'), findsOneWidget);
    });

    testWidgets('Displays email validation error for invalid email',
        (WidgetTester tester) async {
      await pumpPasswordResetWidget(tester, mockFirebaseAuth);

      // Enter an invalid email
      await tester.enterText(find.byType(TextFormField), 'invalid-email');
      await tester.tap(find.text('Submit'));
      await tester.pump();

      // Check for validation error message
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('Sends password reset email for valid email',
        (WidgetTester tester) async {
      when(mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')))
          .thenAnswer((_) async {});

      await pumpPasswordResetWidget(tester, mockFirebaseAuth);

      // Enter a valid email
      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      await tester.tap(find.text('Submit'));
      await tester.pump();

      // Verify that the email validation is correct
      expect(find.text('Please enter a valid email'), findsNothing);
      expect(find.text('Email is required!'), findsNothing);

      // Verify that FirebaseAuth.sendPasswordResetEmail was called
      verify(mockFirebaseAuth.sendPasswordResetEmail(email: 'test@example.com'))
          .called(1);

      // Advance the timer and pump the widget to simulate navigation
      await tester.pumpAndSettle();

      // Verify that PasswordResetConfirmation is displayed
      expect(find.text('A Reset Link was sent to test@example.com'),
          findsOneWidget);
    });
  });
}
