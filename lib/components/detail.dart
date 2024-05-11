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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Train $trainId',
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text('UN 1202 Dieselkraftstoffe',
                              style: TextStyle(fontSize: 18)),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0), // Leichter Einzug links
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 200,
                          maxHeight: 100,
                        ),
                        child: Image.asset(
                          'assets/images/wagon.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16), // Abstand nach dem Bild
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Data Table without header
                          DataTable(
                            headingRowHeight: 0, // Removes header space
                            dataRowHeight: 40, // Adjusts row height
                            columns: const [
                              DataColumn(label: Text('')), // Empty labels
                              DataColumn(label: Text('')),
                            ],
                            rows: [
                              const DataRow(cells: [
                                DataCell(Text('Operator')),
                                DataCell(Text('SBB Int'))
                              ]),
                              const DataRow(cells: [
                                DataCell(Text('Origin')),
                                DataCell(Text('Karlsruhe'))
                              ]),
                              const DataRow(cells: [
                                DataCell(Text('Destination')),
                                DataCell(Text('Ludwigshafen'))
                              ]),
                              const DataRow(cells: [
                                DataCell(Text('Departure')),
                                DataCell(Text('10.05.2024'))
                              ]),
                              const DataRow(cells: [
                                DataCell(Text('Arrival')),
                                DataCell(Text('11.05.2024'))
                              ]),
                              DataRow(cells: [
                                DataCell(const Text('Location',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                const DataCell(Text('49.9123')),
                              ]),
                              DataRow(cells: [
                                DataCell(Text(
                                    '')), // Leer, um die Zeile mit der ersten Koordinate auszurichten
                                const DataCell(Text('8.4948',
                                    textAlign: TextAlign.center)),
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
                              backgroundColor:
                                  const Color.fromARGB(255, 160, 188, 211),
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
