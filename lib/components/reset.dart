// reset.dart
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:train_tracker/components/common/custom_snackbar.dart';
import 'package:train_tracker/components/confirmation.dart';
import 'package:train_tracker/state/models/user_model.dart';
import 'package:train_tracker/state/user_provider.dart';
import 'common/custom_form_button.dart';
import 'common/custom_input_field.dart';
import 'common/page_header_login.dart';
import 'common/page_heading.dart';
import 'login.dart';

/// The stateful widget for the password reset screen.
class PasswordReset extends StatefulWidget {
  final FirebaseAuth firebaseAuth;

  const PasswordReset({super.key, required this.firebaseAuth});

  @override
  PasswordResetState createState() => PasswordResetState();
}

/// The state class for the password reset screen.
class PasswordResetState extends State<PasswordReset> {
  final TextEditingController _emailController = TextEditingController();
  final _passwordResetFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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
                    key: _passwordResetFormKey,
                    child: Column(
                      children: [
                        const PageHeading(
                          title: 'Reset password',
                        ),
                        CustomInputField(
                            controller: _emailController,
                            labelText: 'Email',
                            hintText: 'Email',
                            isDense: true,
                            icon: Icon(Icons.account_circle, color: Theme.of(context).primaryColor),
                            validator: (textValue) {
                              if (textValue == null || textValue.isEmpty) {
                                return 'Email is required!';
                              }
                              if (!EmailValidator.validate(textValue)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomFormButton(
                          innerText: 'Submit',
                          onPressed: _handlePasswordReset,
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
                                      builder: (context) => const LoginPage()))
                            },
                            child: const Text(
                              'Back to login',
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

  /// Handles the password reset process.
  Future<void> _handlePasswordReset() async {
    if (_passwordResetFormKey.currentState!.validate()) {
      CustomSnackbar.showLoading(context, 'Submitting data..');

      try {
        await widget.firebaseAuth
            .sendPasswordResetEmail(email: _emailController.text);

        if (mounted) {
          Provider.of<UserProvider>(context, listen: false)
              .setUser(UserModel(email: _emailController.text));

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const PasswordResetConfirmation()));
        }
      } catch (e) {
        if (mounted) {
          CustomSnackbar.show(context, 'Unexpected error occurred.');
        }
      } finally {
        if (mounted) {
          CustomSnackbar.hide(context);
        }
      }
    }
  }
}
