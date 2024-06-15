// location_provider.dart

import 'package:flutter/material.dart';
import 'models/location_model.dart';

/// A provider class for managing and notifying listeners about location data.
class LocationProvider with ChangeNotifier {
  /// A private list to store location data.
  List<LocationModel> _locations = [];

  /// A getter to access the list of locations.
  List<LocationModel> get locations => _locations;

  /// Sets the list of locations and notifies listeners about the change.
  ///
  /// [locations] is the new list of locations to be set.
  void setLocations(List<LocationModel> locations) {
    _locations = locations;
    notifyListeners();
  }
}
