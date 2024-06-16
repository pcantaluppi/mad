import 'package:flutter/material.dart';

class PageHeaderLogin extends StatelessWidget {
  const PageHeaderLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const tabletBreakpoint = 600.0;

    return Container(
      color: Colors.white, // Set white background for the Container
      child: SizedBox(
        child: Image.asset(
          screenWidth > tabletBreakpoint
              ? 'assets/images/login-header-horizontal.png'
              : 'assets/images/login-header.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
