//page_header_login.dart
import 'package:flutter/material.dart';

/// A widget that represents the header of a login page.
class PageHeaderLogin extends StatelessWidget {
  const PageHeaderLogin({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.3,
      child: Image.asset('assets/images/logo.png'),
    );
  }
}
