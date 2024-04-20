// // main.dart
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'components/splash.dart';
// import 'components/login.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   try {
//     await dotenv.load(fileName: ".env");
//   } catch (e) {
//     // ignore: avoid_print
//     print('!!!! Failed to load env variables: $e');
//   }

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // Initialize Supabase
//   Future<void> initializeSupabase() async {
//     final String supabaseUrl = dotenv.env['URL'] ?? '';
//     final String supabaseAnonKey = dotenv.env['KEY'] ?? '';
//     await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: FutureBuilder(
//         // Initialize Supabase
//         future: Future.wait([
//           initializeSupabase(),
//           // Timer for splash screen
//           Future.delayed(const Duration(seconds: 4)),
//         ]),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return const LoginPage();
//           } else {
//             return const SplashScreen();
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:train_tracker/loeschmich.dart';
import 'firebase_options.dart'; // Your Firebase configuration file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Example',
      home: MyHomePage(),
    );
  }
}
