// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:train_tracker/components/login.dart';

// class AuthProvider with ChangeNotifier {
//   Session? _session;

//   AuthProvider() {
//     _checkCurrentSession();
//   }

//   Session? get session => _session;

//   void _checkCurrentSession() {
//     _session = Supabase.instance.client.auth.currentSession;
//     notifyListeners();
//   }

//   void logout(BuildContext context) async {
//     await Supabase.instance.client.auth.signOut();
//     _session = null;
//     notifyListeners();
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => const LoginPage()),
//     );
//   }
// }
