// user_provider.dart

import 'package:flutter/material.dart';
import 'models/user_model.dart';

/// A provider class for managing user data.
/// This class extends the [ChangeNotifier] class from the Flutter framework,
/// allowing it to notify listeners when the user data changes.
class UserProvider with ChangeNotifier {
  // Private field to hold the current user object
  UserModel? _user;

  // Getter to retrieve the current user object
  UserModel? get user => _user;

  /// Sets the user data and notifies listeners.
  /// This method sets the provided [user] as the current user and notifies
  /// any registered listeners that the user data has changed.
  void setUser(UserModel user) {
    // Update the private user field with the new user object
    _user = user;
    // Notify all listeners that the user state has changed
    notifyListeners();
  }
}
