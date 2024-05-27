// user_model.dart

// Define the UserModel class which represents the structure of user data
class UserModel {
  // Field to store the user's email
  String email;

  // Field to store the user's logo URL or path
  String logo;

  // Field to store the user's company name, which is optional (nullable)
  final String? company;

  // Constructor to initialize a UserModel object
  // The email field is required, while logo and company have default values if not provided
  UserModel({required this.email, this.logo = '', this.company = ''});
}
