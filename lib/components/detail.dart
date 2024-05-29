// detail.dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:logger/logger.dart';
import 'package:train_tracker/components/map.dart';
import '/components/common/page_header.dart';

/// This file contains the implementation of the `DetailPage` class,
/// which is a stateless widget representing the detail page of a train transport.
class DetailPage extends StatelessWidget {
  final int trainId;
  final Logger logger;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  DetailPage({super.key, required this.trainId}) : logger = Logger();

  @override
  Widget build(BuildContext context) {
    _logDetailPageVisit(trainId);
    return Scaffold(
      backgroundColor: const Color(0xffEEF1F3),
      appBar: AppBar(
        title: Text('Transport $trainId',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                            snapshot.data!.data() as Map<String, dynamic>?;
                        if (data == null) {
                          return const Center(child: Text('No data found'));
                        }
                        //logger.i('Transport data: $data');

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
                                  // child: Image.asset(
                                  //     'assets/images/wagon.png', // todo: dynamic image
                                  //     fit: BoxFit.contain),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://firebasestorage.googleapis.com/v0/b/api-project-1005616374074.appspot.com/o/wagon.png?alt=media&token=a43df46a-eefe-4892-9942-1ed4a955b0d5',
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              FutureBuilder<List<DocumentSnapshot>>(
                                future: fetchLocationData(trainId),
                                builder: (context, locationSnapshot) {
                                  if (locationSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  Map<String, dynamic>? highestLocation;

                                  if (locationSnapshot.hasData &&
                                      locationSnapshot.data!.isNotEmpty) {
                                    var locationData = locationSnapshot.data!;
                                    highestLocation = locationData.last.data()
                                        as Map<String, dynamic>?;
                                  }

                                  return Column(
                                    children: [
                                      dataTable(data, highestLocation),
                                      const SizedBox(height: 16),
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.map),
                                        label: const Text('View Map'),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MapPage(trainId: trainId)),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: const Color.fromARGB(
                                              255, 160, 188, 211),
                                        ),
                                      ),
                                    ],
                                  );
                                },
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

  /// Logs the visit of the detail page for a specific train.
  void _logDetailPageVisit(int trainId) {
    analytics.logEvent(name: 'detail_page_visit', parameters: {
      'train_id': trainId,
      'visit_time': DateTime.now().toIso8601String(),
    }).then((_) {
      //logger.i('Visit of detail page $trainId logged.');
    }).catchError((error) {
      logger.e('Failed to log detail page visit: $error');
    });
  }

  /// Fetches location data for a given train ID.
  Future<List<DocumentSnapshot>> fetchLocationData(int trainId) async {
    try {
      // Fetch stops for the given trainId
      var stopsSnapshot = await FirebaseFirestore.instance
          .collection('stops')
          .where('transport', isEqualTo: trainId)
          .orderBy('id')
          .get();

      if (stopsSnapshot.docs.isEmpty) {
        logger.i('No stops found for transport: $trainId');
        return [];
      }

      // Log stop data
      var stopsData = stopsSnapshot.docs.map((doc) {
        var data = doc.data();
        logger.i('Stop Data: $data');
        return data;
      }).toList();

      // Additional filtering
      var filteredStops = stopsSnapshot.docs.where((doc) {
        var data = doc.data();
        return data['transport'] == trainId;
      }).toList();

      logger.i('Filtered Stops Count: ${filteredStops.length}');

      if (filteredStops.isEmpty) {
        logger.i('No stops found after filtering for transport $trainId');
        return [];
      }

      // Get the stop with the highest id
      var highestStopId = filteredStops.last.id;
      logger.i('Highest stop id: $highestStopId');

      // Fetch the location data
      var highestLocationSnapshot = await FirebaseFirestore.instance
          .collection('locations')
          .doc(highestStopId)
          .get();

      var highestLocationData = highestLocationSnapshot.data();

      if (highestLocationData == null) {
        logger.i('No location data found for stop $highestStopId');
        return [];
      }

      logger.i('Highest location fetched $highestLocationData');

      return [highestLocationSnapshot];
    } catch (e) {
      logger.e('Error fetching location data: $e');
      return [];
    }
  }

  /// Creates a DataTable widget with the provided data and highestLocation.
  /// The [data] parameter is a map containing the details of the flight, such as
  /// the operator, origin, destination, departure, and arrival.
  /// The [highestLocation] parameter is an optional map containing the latitude
  /// and longitude of the highest location.
  /// Returns a DataTable widget displaying the flight details in a tabular format.
  DataTable dataTable(
      Map<String, dynamic> data, Map<String, dynamic>? highestLocation) {
    return DataTable(
      headingRowHeight: 0,
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
          DataCell(Text(highestLocation != null
              ? highestLocation['latitude']?.toString() ?? 'N/A'
              : 'N/A'))
        ]),
        DataRow(cells: [
          const DataCell(Text('Longitude')),
          DataCell(Text(highestLocation != null
              ? highestLocation['longitude']?.toString() ?? 'N/A'
              : 'N/A'))
        ]),
      ],
    );
  }
}
