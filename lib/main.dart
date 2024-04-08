// import 'package:flutter/material.dart';
// import 'splash.dart';

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: SplashScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'components/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Initialize Supabase asynchronously
  Future<void> initializeSupabase() async {
    await Supabase.initialize(
      url: 'YOUR_SUPABASE_URL',
      anonKey: 'YOUR_SUPABASE_ANON_KEY',
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize Supabase and wait for completion
      future: initializeSupabase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Once Supabase is initialized, return MaterialApp
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: LoginPage(),
          );
        } else {
          // Show loading indicator while Supabase is initializing
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
