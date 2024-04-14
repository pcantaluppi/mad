// login.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginModel with ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;

  void setEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  void setPassword(String newPassword) {
    _password = newPassword;
    notifyListeners();
  }

  void setIsLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> loginUser(BuildContext context) async {
    try {
      setIsLoading(true);
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: _email,
        password: _password,
      );
      setIsLoading(false);

      if (!mounted) return;

      if (response.user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Login failed. Please check your credentials.')),
        );
      }
    } catch (error) {
      setIsLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Unexpected error occurred. Please try again.')),
      );
    }
  }
}
