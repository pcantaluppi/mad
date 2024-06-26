import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:train_tracker/state/location_provider.dart';
import 'state/user_provider.dart';
import 'components/firebase/options.dart';
import 'components/splash.dart';
import 'components/login.dart';
import 'components/home.dart';

/// The entry point of the application.
/// Initializes the logger, loads environment variables from a .env file,
/// and runs the app with the necessary providers.
void main() async {
  FlutterError.onError = (details) => FlutterError.dumpErrorToConsole(details);

  final logger = Logger();
  WidgetsFlutterBinding.ensureInitialized();
  await _loadEnvironmentVariables();

  runZonedGuarded(() {
    runApp(
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
        child: const MyApp(),
      ),
    );
  }, (error, stackTrace) {
    logger.e('Unhandled exception caught: $error');
  });
}

Future<void> _loadEnvironmentVariables() async {
  final logger = Logger();
  try {
    await dotenv.load(fileName: ".env");
  } catch (error) {
    logger.e('Failed to load env variables: $error');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This function is responsible for initializing Firebase.
  // It uses the default options for the current platform.
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Main widget of the application.
  @override
  Widget build(BuildContext context) {
    // Define your desired background color

    return ChangeNotifierProvider<LocationProvider>(
      create: (context) => LocationProvider(),
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: const Color.fromARGB(255, 1, 11, 50),
            primaryColorLight: const Color.fromARGB(255, 236, 247, 248)),
        // This disables the debug banner that appears in the top right corner of the app in debug mode.
        debugShowCheckedModeBanner: false,
        builder: (context, child) => _buildAppScaffold(context, child),
        home: FutureBuilder(
          // This FutureBuilder is used to perform some async operations before the app is fully loaded.
          // It waits for two futures: one to initialize Firebase and another to display a splash screen for 4 seconds.
          future: Future.wait([
            initializeFirebase(),
            Future.delayed(const Duration(seconds: 4)),
          ]),
          builder: (context, snapshot) => _buildHomeScreen(snapshot),
        ),
      ),
    );
  }


Widget _buildAppScaffold(BuildContext context, Widget? child) {
  Color headerColor = Theme.of(context).primaryColorLight;
  Color footerColor = Colors.white;

  return MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: const TextScaler.linear(1.0)),
    child: Scaffold(
      backgroundColor: headerColor,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: headerColor,
      ),
      bottomNavigationBar: Container(
        color: footerColor,
        height: 0, 
        child: const BottomAppBar(
        ),
      ),
      body: SafeArea(child: child!),
    ),
  );
}

  Widget _buildHomeScreen(AsyncSnapshot snapshot) {
    // Once both futures are complete, the builder is called.
    // If the connection state is 'done', it means both futures have completed.
    if (snapshot.connectionState == ConnectionState.done) {
      // The first future returns a User object, which is retrieved here.
      User? user = snapshot.data![0] as User?;
      // If the user is null, it means the user is not logged in, so the LoginPage is shown.
      if (user == null) {
        return const LoginPage();
      }
      // If the user is not null, it means the user is logged in, so the HomePage is shown.
      return const HomePage();
    } else {
      // If the futures are not complete, the SplashScreen is shown.
      return const SplashScreen();
    }
  }
}
