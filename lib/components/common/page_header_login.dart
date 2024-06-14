//page_header_login.dart
import 'package:flutter/material.dart';

/// A widget that represents the header of a login page.
class PageHeaderLogin extends StatelessWidget {
  const PageHeaderLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Image.asset('assets/images/login-header.png'),
    );
  }
}
