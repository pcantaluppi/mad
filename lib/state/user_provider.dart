// user_provider.dart

// Import necessary Flutter material package
import 'package:flutter/material.dart';
// Import the user model which defines the structure of user data
import 'models/user_model.dart';

// Define a UserProvider class which uses the ChangeNotifier mixin to manage state
class UserProvider with ChangeNotifier {
  // Private field to hold the current user object
  UserModel? _user;

  // Getter to retrieve the current user object
  UserModel? get user => _user;

  // Method to set a new user object and notify listeners about the change
  void setUser(UserModel user) {
    // Update the private user field with the new user object
    _user = user;
    // Notify all listeners that the user state has changed
    notifyListeners();
  }
}
