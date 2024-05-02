// detail.dart
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String trainId;

  const DetailPage({super.key, required this.trainId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Center(
        child: Text('id: $trainId'),
      ),
    );
  }
}
