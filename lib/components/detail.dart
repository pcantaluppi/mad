// detail.dart
import 'package:flutter/material.dart';
import '/components/common/page_header.dart';
import 'home.dart';

class DetailPage extends StatelessWidget {
  final int trainId;

  const DetailPage({super.key, required this.trainId});

  @override
  Widget build(BuildContext context) {
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
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                        maxHeight: 300,
                      ),
                      child: Image.asset(
                        'assets/images/wagon.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Transport: $trainId',
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text('UN 1202 Dieselkraftstoffe',
                              style: TextStyle(fontSize: 18)),
                          const SizedBox(height: 8),
                          // Data Table
                          DataTable(
                            columns: const [
                              DataColumn(label: Text('Key')),
                              DataColumn(label: Text('Value')),
                            ],
                            rows: const [
                              DataRow(cells: [
                                DataCell(Text('Operator')),
                                DataCell(Text('SBB'))
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Origin')),
                                DataCell(Text('Karlsruhe'))
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Destination')),
                                DataCell(Text('Ludwigshafen'))
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Departure')),
                                DataCell(Text('Datetime'))
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Arrival')),
                                DataCell(Text('Datetime'))
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Location')),
                                DataCell(Text('Latitude, Longitude'))
                              ]),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Navigation Button to Map Page
                          ElevatedButton.icon(
                            icon: const Icon(Icons.map),
                            label: const Text('View Map'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                            ),
                          ),
                        ],
                      ),
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
}
