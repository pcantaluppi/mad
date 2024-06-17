import 'package:flutter/material.dart';
import 'models/location_model.dart';

/// A provider class to manage and notify listeners about location data updates.
class LocationProvider with ChangeNotifier {
  /// A private list to store the locations.
  List<LocationModel> _locations = [];

  /// A getter to access the list of locations.
  List<LocationModel> get locations => _locations;

  /// A method to update the list of locations and notify listeners.
  ///
  /// This method sets the new list of locations and calls `notifyListeners()`
  /// to update any widgets that are listening to this provider.
  ///
  /// [locations] - The new list of locations to set.
  void setLocations(List<LocationModel> locations) {
    _locations = locations;
    notifyListeners();
  }
}
