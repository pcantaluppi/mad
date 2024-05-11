// main.dart
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'state/user_provider.dart';
import 'components/firebase/options.dart';
import 'components/splash.dart';
import 'components/login.dart';
import 'components/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final logger = Logger();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    logger.e('Failed to load env variables: $e');
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Initialize Firebase
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        // Initialize Supabase
        future: Future.wait([
          initializeFirebase(),
          // Timer for splash screen
          Future.delayed(const Duration(seconds: 4)),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //return const LoginPage();

            User? user = snapshot.data![0] as User?;
            if (user == null) {
              return const LoginPage();
            }
            return const HomePage();
          } else {
            return const SplashScreen();
          }
        },
      ),
    );
  }
}
