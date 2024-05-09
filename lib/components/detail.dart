// detail.dart
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final int trainId;

  const DetailPage({super.key, required this.trainId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/wagon.png',
                width: MediaQuery.of(context).size.width),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('id: $trainId', style: const TextStyle(fontSize: 24)),
            ),
          ],
        ),
      ),
    );
  }
}
