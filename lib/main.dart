// main.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'components/splash.dart';
import 'components/login.dart';
import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Initialize Supabase asynchronously
  Future<void> initializeSupabase() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        // Initialize Supabase and wait for completion
        future: Future.wait([
          initializeSupabase(),
          Future.delayed(const Duration(seconds: 4)), // Timer for splash screen
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Once Supabase is initialized and timer is done, return LoginPage
            return const LoginPage();
          } else {
            // Show SplashScreen while waiting
            return const SplashScreen();
          }
        },
      ),
    );
  }
}
