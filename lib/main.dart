import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Handle Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
  };
  
  // Try to initialize Firebase, but don't block if it fails
  try {
    await Firebase.initializeApp();
    debugPrint('Firebase initialized successfully');
    
    // Try to add user data, but don't block if it fails
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'name': 'haregeweyn',
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      // Silently fail - Firebase might not be configured yet
      debugPrint('Firestore operation failed: $e');
    }
  } catch (e) {
    // If Firebase initialization fails, still run the app
    debugPrint('Firebase initialization failed: $e');
    debugPrint('App will continue without Firebase features');
  }

  runApp(const FindItEthiopiaApp());
}

class FindItEthiopiaApp extends StatelessWidget {
  const FindItEthiopiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FindIt Ethiopia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
