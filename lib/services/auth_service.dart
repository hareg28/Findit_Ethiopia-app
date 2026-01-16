import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
    String? name,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name if provided
      if (name != null && name.isNotEmpty) {
        await result.user?.updateDisplayName(name);
      }

      // Create user document in Firestore
      if (result.user != null) {
        await _firestore.collection('users').doc(result.user!.uid).set({
          'email': email,
          'name': name ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow. On web the google_sign_in_web
      // package asserts when no web client ID is provided. Catch that
      // assertion and surface a clearer error message so the app doesn't
      // crash with an internal assertion stack trace.
      GoogleSignInAccount? googleUser;
      try {
        googleUser = await _googleSignIn.signIn();
      } on AssertionError {
        throw Exception(
          'Google Sign-In (web) failed: ClientID not set. Add a meta tag '
          '<meta name="google-signin-client_id" content="YOUR_WEB_CLIENT_ID.apps.googleusercontent.com" /> '
          'to web/index.html, or pass the clientId when creating GoogleSignIn.',
        );
      }

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential result = await _auth.signInWithCredential(credential);

      // Create or update user document in Firestore
      if (result.user != null) {
        await _firestore.collection('users').doc(result.user!.uid).set({
          'email': result.user!.email ?? '',
          'name': result.user!.displayName ?? '',
          'photoUrl': result.user!.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}
