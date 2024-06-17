// login.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:train_tracker/components/common/custom_snackbar.dart';
import '/components/home.dart';
import '/components/reset.dart';
import '/components/common/custom_input_field.dart';
import '/components/common/page_header_login.dart';
import '/components/common/custom_form_button.dart';
import '../state/user_provider.dart';
import '../state/models/user_model.dart';

/// Page for user login.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// The state of the [LoginPage].
class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _emailController.text = '';
    _passwordController.text = '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _logLandingPageVisit();
    Size size = MediaQuery.of(context).size;
    final double paddingValue = size.width > 600 ? 100 : 25;
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
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _loginFormKey,
                    child: Container(
                      padding: EdgeInsets.all(paddingValue),
                      child: Column(
                        children: [
                          CustomInputField(
                            controller: _emailController,
                            labelText: 'Email',
                            hintText: 'Email',
                            validator: (textValue) {
                              if (textValue == null || textValue.isEmpty) {
                                return 'Email is required';
                              }
                              if (!EmailValidator.validate(textValue)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            suffixIcon: false,
                            obscureText: false,
                            icon: Icon(Icons.account_circle, color: Theme.of(context).primaryColor),
                          ),
                          const SizedBox(height: 16),
                          CustomInputField(
                            controller: _passwordController,
                            labelText: 'Password',
                            hintText: 'Password',
                            obscureText: true,
                            suffixIcon: true,
                            validator: (textValue) {
                              if (textValue == null || textValue.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                            icon: Icon(Icons.lock, color: Theme.of(context).primaryColor),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            width: size.width * 0.80,
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PasswordReset(
                                      firebaseAuth: FirebaseAuth.instance,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: Color(0xff939393),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomFormButton(
                            innerText: 'Login',
                            onPressed: () => _handleLoginUser(context),
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
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

  /// Logs the landing page visit event.
  void _logLandingPageVisit() {
    analytics.logEvent(name: 'home_page_visit', parameters: {
      'visit_time': DateTime.now().toIso8601String(),
    }).then((_) {
      //logger.i('Landing page visit logged.');
    }).catchError((error) {
      logger.e('Failed to log landing page visit: $error');
    });
  }

  /// Handles the login process for the user.
  void _handleLoginUser(BuildContext context) async {
    if (_loginFormKey.currentState!.validate()) {
      CustomSnackbar.showLoading(context, "Logging in");

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (userCredential.user != null) {
          // Fetch company data from Firestore
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('customers')
              .where('users', arrayContains: _emailController.text)
              .get();

          if (mounted) {
            String company = '';
            String logo = '';
            if (querySnapshot.docs.isNotEmpty) {
              company = querySnapshot.docs.first['name'];
              logo = querySnapshot.docs.first['logo'];
            }

            if (context.mounted) {
              // Set user email and company in provider
              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              userProvider.setUser(UserModel(
                  email: _emailController.text, logo: logo, company: company));

              // Navigate to home page
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            }
          }
        } else {
          throw Exception('No user found');
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          String errorMessage = 'Login failed. Please try again.';
          if (e.code == 'user-not-found') {
            errorMessage = 'No user found for that email.';
          } else if (e.code == 'wrong-password') {
            errorMessage = 'Wrong password provided.';
          }

          if (context.mounted) {
            CustomSnackbar.showLoading(context, errorMessage);
          }
        }
      } catch (e) {
        if (context.mounted) {
          CustomSnackbar.show(context, 'Unexpected error occurred.');
        }
      } finally {
        if (context.mounted) {
          CustomSnackbar.hide(context);
        }
      }
    }
  }
}
