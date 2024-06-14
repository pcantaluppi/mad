// detail.dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:train_tracker/components/common/custom_appbar.dart';
import 'package:train_tracker/components/common/custom_snackbar.dart';
import 'package:train_tracker/components/map.dart';
import 'package:train_tracker/state/location_provider.dart';
import 'package:train_tracker/state/models/location_model.dart';
import 'package:train_tracker/state/user_provider.dart';
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
    final user = Provider.of<UserProvider>(context, listen: false).user;
    _logDetailPageVisit(trainId);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Transport $trainId',
        actionsStreamBuilder:
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('user_favorites')
              .where(FieldPath.documentId, isEqualTo: user?.email)
              .snapshots(),
          builder: (context, snapshot) {
            // Check if the bookmark is already set
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            bool isBookmarked = false;
            if (snapshot.data!.docs.isEmpty) {
              FirebaseFirestore.instance
                  .collection('user_favorites')
                  .doc('${user?.email}')
                  .set({'transport_ids': []});
            }
            isBookmarked =
                (snapshot.data?.docs.first.data()['transport_ids'] as List)
                    .whereType<int>()
                    .toList()
                    .contains(trainId);
            return IconButton(
              iconSize: 30,
              icon: Icon(isBookmarked
                  ? Icons.bookmark_added_rounded
                  : Icons.bookmark_add_outlined),
              onPressed: () {
                if (user != null) {
                  if (isBookmarked) {
                    updateBookmark(context, isBookmarked);
                  } else {
                    updateBookmark(context, isBookmarked);
                  }
                }
              },
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const PageHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('transports')
                        .doc(trainId.toString())
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Center(child: Text('No data found'));
                      }
                      var data = snapshot.data!.data() as Map<String, dynamic>?;
                      if (data == null) {
                        return const Center(child: Text('No data found'));
                      }
                      //logger.i('Transport data: $data');

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(data['title'] ?? 'No title',
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(data['un'] ?? 'No un number',
                                style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 8),
                            Container(
                              constraints: const BoxConstraints(
                                  maxWidth: 150, maxHeight: 75),
                              child: CachedNetworkImage(
                                imageUrl: data['image'] ?? '',
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            const SizedBox(height: 20),
                            FutureBuilder<List<DocumentSnapshot>>(
                              future: fetchLocationData(trainId, context),
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

                                return Center(
                                  child: Column(
                                    children: [
                                      dataTable(data, highestLocation, context),
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
                                          foregroundColor: Theme.of(context)
                                              .primaryColorLight,
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
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

  Future<void> isTrainFavorite(BuildContext context) async {
    try {
      var currentUser = Provider.of<UserProvider>(context, listen: false).user;
      if (currentUser == null) {
        logger.e('User cannot be found!');
        throw Exception();
      }
      await FirebaseFirestore.instance
          .collection('user_favorites')
          .doc(currentUser.email)
          .update({
        'transport_ids': FieldValue.arrayUnion([trainId])
      });

      logger.i('Document written successfully!');
    } catch (e) {
      logger.i('Error writing document: $e');
    }
  }

  Future<void> updateBookmark(BuildContext context, bool remove) async {
    try {
      var currentUser = Provider.of<UserProvider>(context, listen: false).user;
      if (currentUser == null) {
        logger.e('User cannot be found!');
        throw Exception();
      }

      if (remove) {
        await FirebaseFirestore.instance
            .collection('user_favorites')
            .doc(currentUser.email)
            .update({
          'transport_ids': FieldValue.arrayRemove([trainId])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('user_favorites')
            .doc(currentUser.email)
            .update({
          'transport_ids': FieldValue.arrayUnion([trainId])
        });
      }

      if (context.mounted) {
        CustomSnackbar.show(
            context, remove ? "Bookmark removed" : "Bookmark saved");
      }

      logger.i('Document updated successfully!');
    } catch (e) {
      logger.i('Error updating document: $e');
      if (context.mounted) {
        CustomSnackbar.show(context, "Could not update Bookmark");
      }
    }
  }

  /// Fetches location data for a given id
  Future<List<DocumentSnapshot>> fetchLocationData(
      int trainId, BuildContext context) async {
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

      // Log each stop
      for (var doc in stopsSnapshot.docs) {
        var data = doc.data();
        logger.i('Stop Data: $data');
      }

      // Additional filtering
      var filteredStops = stopsSnapshot.docs.where((doc) {
        var data = doc.data();
        return data['transport'] == trainId;
      }).toList();

      logger.i('Filtered Stops Count: ${filteredStops.length}');

      if (filteredStops.isEmpty) {
        logger.i('No stops found after filtering for transport: $trainId');
        return [];
      }

      // Save the list of locations to the provider
      List<LocationModel> locations = [];
      for (var stopDoc in filteredStops) {
        var stopData = stopDoc.data();
        var locationId = stopData['location'].toString();

        var locationSnapshot = await FirebaseFirestore.instance
            .collection('locations')
            .doc(locationId)
            .get();

        if (locationSnapshot.exists) {
          var locationData = locationSnapshot.data();
          var location = LocationModel(
            trainId: trainId,
            location: locationData?['location'] ?? '',
            latitude: locationData?['latitude'] ?? 0,
            longitude: locationData?['longitude'] ?? 0,
          );
          locations.add(location);
        }
      }

      logger.i('Data for state: ${locations.map((e) => e.toMap()).toList()}');

      if (context.mounted) {
        final locationProvider =
            Provider.of<LocationProvider>(context, listen: false);
        locationProvider.setLocations(locations);
      }

      // Get the stop with the highest id
      var highestStopDoc = filteredStops.last;
      var highestStopData = highestStopDoc.data();
      var highestStopId = highestStopDoc.id;
      var locationId = highestStopData['location'].toString();
      logger.i('Highest stop id: $highestStopId');
      logger.i('Location id: $locationId');

      // Fetch the location data for the stop with the highest id
      var highestLocationSnapshot = await FirebaseFirestore.instance
          .collection('locations')
          .doc(locationId)
          .get();

      if (!highestLocationSnapshot.exists) {
        logger.i('No location data found for location id: $locationId');
        return [];
      }

      var highestLocationData = highestLocationSnapshot.data();
      logger.i('Highest location fetched: $highestLocationData');

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
  DataTable dataTable(Map<String, dynamic> data,
      Map<String, dynamic>? highestLocation, BuildContext context) {
    return DataTable(
      headingRowHeight: 0,
      dataTextStyle:
          TextStyle(color: Theme.of(context).primaryColor, fontSize: 15),
      headingTextStyle: TextStyle(color: Theme.of(context).primaryColor),
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
