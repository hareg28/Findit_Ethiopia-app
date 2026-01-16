import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return desktop;
      default:
        return web; // Fallback to web for others
    }
  }

  // Web configuration
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAZBR0tS6UMXqVpSdoJ4eQhrbB1V_X0IU8',
    appId: '1:1066462249856:web:eb66168d096dab6737b765',
    messagingSenderId: '1066462249856',
    projectId: 'findit-ethiopia',
    authDomain: 'findit-ethiopia.firebaseapp.com',
    storageBucket: 'findit-ethiopia.firebasestorage.app',
    measurementId: 'G-WHJQVRTXJ5',
  );

  // Android configuration
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDNwvcH5X_YwBvNQzCuHZHH8Ksh6mM15BE',
    appId: '1:1066462249856:android:9730e5e64301ba3337b765',
    messagingSenderId: '1066462249856',
    projectId: 'findit-ethiopia',
    storageBucket: 'findit-ethiopia.firebasestorage.app',
  );

  // iOS configuration (Using Android project info as placeholder baseline)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDNwvcH5X_YwBvNQzCuHZHH8Ksh6mM15BE',
    appId: '1:1066462249856:ios:eb66168d096dab6737b765',
    messagingSenderId: '1066462249856',
    projectId: 'findit-ethiopia',
    storageBucket: 'findit-ethiopia.firebasestorage.app',
    iosClientId: '1066462249856-6ioi6fv43a9et4hejp4mrqpmv9146qvi.apps.googleusercontent.com',
    iosBundleId: 'com.example.finditEthiopia',
  );

  // macOS (often same as iOS)
  static const FirebaseOptions macos = ios;

  // Desktop placeholder (Windows/Linux)
  static const FirebaseOptions desktop = web; // Just use web config for desktop too
}
