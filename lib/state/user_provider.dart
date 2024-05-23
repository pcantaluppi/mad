// user_provider.dart
import 'package:flutter/material.dart';
import 'models/user_model.dart';

/// A provider class for managing user data.
/// This class extends the [ChangeNotifier] class from the Flutter framework,
/// allowing it to notify listeners when the user data changes.
class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  /// Sets the user data and notifies listeners.
  ///
  /// This method sets the provided [user] as the current user and notifies
  /// any registered listeners that the user data has changed.
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
}
