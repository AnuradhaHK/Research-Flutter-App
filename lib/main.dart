import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // For desktop platforms
import 'package:path_provider/path_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database for different platforms
  if (kIsWeb) {
    // Web specific code (optional, if you're using a web-compatible solution)
    // Example: You may use an in-memory database or `idb_sqflite` for web
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Initialize sqflite_common_ffi for desktop platforms
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  } else {
    // Mobile platforms (iOS, Android) already use sqflite by default
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Research Project Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.green, // Updated to match the new green theme
      ),
      home: const SplashScreen(),
    );
  }
}
