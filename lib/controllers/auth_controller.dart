import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthController() {
    _init();
  }

  Future<void> _init() async {
    _user = _authService.currentUser;
    notifyListeners();
    
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();
      _user = await _authService.signInWithEmailAndPassword(email, password);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUpWithEmail(String email, String password, String? name) async {
    try {
      _setLoading(true);
      _clearError();
      _user = await _authService.signUpWithEmailAndPassword(email, password, name);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();
      _user = await _authService.signInWithGoogle();
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _authService.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(dynamic error) {
    debugPrint('ANTIGRAVITY_ERROR TYPE: ${error.runtimeType}');
    debugPrint('ANTIGRAVITY_ERROR TOSTRING: $error');
    if (error is Error) {
       debugPrint('ANTIGRAVITY_ERROR STACK: ${error.stackTrace}');
    }
    _errorMessage = 'Error: $error';
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}







