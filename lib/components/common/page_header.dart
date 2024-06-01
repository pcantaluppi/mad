//page_header.dart
import 'package:flutter/material.dart';

/// A common header widget for pages.
/// This widget is used to display a header at the top of a page.
/// It is typically used to provide a consistent look and feel across multiple pages.
class PageHeader extends StatelessWidget {
  const PageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: 20,
    );
  }
}
