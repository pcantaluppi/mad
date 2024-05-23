// user_model.dart

/// Represents a user in the application.
class UserModel {
  String email;
  String logo;
  final String? company;

  /// Constructs a new instance of [UserModel].
  /// The [email] parameter is required and represents the user's email address.
  /// The [logo] parameter represents the user's logo, and defaults to an empty string.
  /// The [company] parameter represents the user's company, and defaults to an empty string.
  UserModel({required this.email, this.logo = '', this.company = ''});
}
