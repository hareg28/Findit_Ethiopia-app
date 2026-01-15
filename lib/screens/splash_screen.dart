import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'main_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    debugPrint('Splash: start _checkAuthAndNavigate');
    // Wait for splash screen display (minimum 2 seconds)
    await Future.delayed(const Duration(seconds: 2));
    debugPrint('Splash: delay complete');

    if (!mounted) return;

    try {
      // Try to read the current user; on web this can fail if Firebase wasn't
      // initialized correctly — guard it and log any errors to help debugging.
      User? user;
      try {
        user = FirebaseAuth.instance.currentUser;
        debugPrint('Splash: currentUser = $user');
      } catch (e, st) {
        debugPrint('Splash: error getting currentUser: $e\n$st');
        user = null;
      }

      if (user != null) {
        debugPrint('Splash: navigating to MainHomeScreen');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainHomeScreen()),
        );
      } else {
        debugPrint('Splash: navigating to LoginScreen');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e, st) {
      debugPrint('Splash: unexpected error: $e\n$st');
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00695C), Color(0xFF26A69A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // You can replace this with an image asset later
              // Image.asset('assets/images/logo.png', width: 100, height: 100),
              const Icon(Icons.location_on, size: 72, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'FindIt Ethiopia',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
