//page_heading.dart
import 'package:flutter/material.dart';

/// A widget that displays a heading for a page.
/// The [PageHeading] widget takes a [title] parameter, which is the text to be displayed as the heading.
/// It is typically used to provide a title for a specific section or page in an application.
class PageHeading extends StatelessWidget {
  final String title;
  const PageHeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 25),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
      ),
    );
  }
}
