// user_model.dart

// Define the UserModel class which represents the structure of user data
class UserModel {
  // Field to store the user's email
  String email;

  // Field to store the user's logo URL or path
  String logo;

  // Field to store the user's company name, which is optional (nullable)
  final String? company;

  /// Constructs a new instance of [UserModel].
  /// The [email] parameter is required and represents the user's email address.
  /// The [logo] parameter represents the user's logo, and defaults to an empty string.
  /// The [company] parameter represents the user's company, and defaults to an empty string.
  UserModel({required this.email, this.logo = '', this.company = ''});
}
