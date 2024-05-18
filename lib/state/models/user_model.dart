// user_model.dart
class UserModel {
  String email;
  String logo;
  final String? company;
  UserModel({required this.email, this.logo = '', this.company = ''});
}
