// detail.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:train_tracker/components/map.dart';
import '/components/common/page_header.dart';

class DetailPage extends StatelessWidget {
  final int trainId;

  const DetailPage({super.key, required this.trainId});

  @override
  Widget build(BuildContext context) {
    final logger = Logger();

    return Scaffold(
      backgroundColor: const Color(0xffEEF1F3),
      appBar: AppBar(
        title: Text('Transport $trainId',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PageHeader(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('transports')
                          .doc(trainId.toString())
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return const Center(child: Text('No data found'));
                        }

                        var data =
                            snapshot.data!.data() as Map<String, dynamic>;

                        logger.i('Item: $data');

                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['title'] ?? 'No title',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(data['un'] ?? 'No un number',
                                  style: const TextStyle(fontSize: 18)),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  constraints: const BoxConstraints(
                                      maxWidth: 150, maxHeight: 75),
                                  child: Image.asset(
                                      'assets/images/wagon.png', // todo: dynamic image
                                      fit: BoxFit.contain),
                                ),
                              ),
                              const SizedBox(height: 20),
                              dataTable(data),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.map),
                                label: const Text('View Map'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MapPage()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      const Color.fromARGB(255, 160, 188, 211),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataTable dataTable(Map<String, dynamic> data) {
    return DataTable(
      headingRowHeight: 0,
      //dataRowHeight: 40,
      columns: const [
        DataColumn(label: Text('')),
        DataColumn(label: Text('')),
      ],
      rows: [
        DataRow(cells: [
          const DataCell(Text('Operator')),
          DataCell(Text(data['operator'] ?? 'N/A'))
        ]),
        DataRow(cells: [
          const DataCell(Text('Origin')),
          DataCell(Text(data['origin'] ?? 'N/A'))
        ]),
        DataRow(cells: [
          const DataCell(Text('Destination')),
          DataCell(Text(data['destination'] ?? 'N/A'))
        ]),
        DataRow(cells: [
          const DataCell(Text('Departure')),
          DataCell(Text(data['departure'] ?? 'N/A'))
        ]),
        DataRow(cells: [
          const DataCell(Text('Arrival')),
          DataCell(Text(data['arrival'] ?? 'N/A'))
        ]),
        const DataRow(cells: [
          DataCell(
              Text('Location', style: TextStyle(fontWeight: FontWeight.bold))),
          DataCell(Text(''))
        ]),
        DataRow(cells: [
          const DataCell(Text('Latitude')),
          DataCell(Text(data['latitude'] ?? 'N/A'))
        ]),
        DataRow(cells: [
          const DataCell(Text('Longitude')),
          DataCell(Text(data['longitude'] ?? 'N/A'))
        ]),
      ],
    );
  }
}
