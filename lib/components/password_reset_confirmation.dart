// password_reset_confirmation.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:train_tracker/components/login.dart';
import 'package:train_tracker/components/password_reset.dart';
import 'common/custom_form_button.dart';
import 'common/page_header_login.dart';
import 'common/page_heading.dart';

class PasswordResetConfirmation extends StatefulWidget {
  const PasswordResetConfirmation({super.key});

  @override
  State<PasswordResetConfirmation> createState() => _PasswordResetConfirmationState();
}

class _PasswordResetConfirmationState extends State<PasswordResetConfirmation> {
  final _passwordResetConfirmationFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: Column(
          children: [
            const PageHeaderLogin(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _passwordResetConfirmationFormKey,
                    child: Column(
                      children: [
                        const PageHeading(
                          // TODO: Pass email to this page
                          title: 'A Reset Link was sent to ****',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomFormButton(
                          innerText: 'Back to Login',
                          onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()))
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const PasswordReset()))
                            },
                            child: const Text(
                              'Wrong Email?',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff939393),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
