// location_provider.dart

import 'package:flutter/material.dart';
import 'models/location_model.dart';

class LocationProvider with ChangeNotifier {
  List<LocationModel> _locations = [];

  List<LocationModel> get locations => _locations;

  void setLocations(List<LocationModel> locations) {
    _locations = locations;
    notifyListeners();
  }
}
