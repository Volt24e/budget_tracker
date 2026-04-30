import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_config.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  String get userId => _user?.id ?? '';
  String get userEmail => _user?.email ?? '';
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _checkAuth();
  }

  void _checkAuth() {
    _user = SupabaseConfig.client.auth.currentUser;
    notifyListeners();
    
    SupabaseConfig.client.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      _errorMessage = null;
      notifyListeners();
    });
  }

  Future<bool> signUp(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      print('Attempting signup for: $email');
      
      final response = await SupabaseConfig.client.auth.signUp(
        email: email.trim().toLowerCase(),
        password: password,
      );
      
      if (response.user != null) {
        _user = response.user;
        
        // Create profile entry
        try {
          await SupabaseConfig.client.from('profiles').insert({
            'id': _user!.id,
            'email': email.trim().toLowerCase(),
          });
          print('Profile created successfully');
        } catch (profileError) {
          print('Profile creation error (may already exist): $profileError');
          // Profile might already exist, that's fine
        }
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Signup failed. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
    } catch (e) {
      print('SignUp Error: $e');
      
      if (e.toString().contains('rate limit')) {
        _errorMessage = 'Too many attempts. Please wait 5 minutes and try again.';
      } else if (e.toString().contains('already registered')) {
        _errorMessage = 'Email already registered. Please login instead.';
      } else {
        _errorMessage = 'Signup failed: ${e.toString()}';
      }
      
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      print('Attempting login for: $email');
      
      final response = await SupabaseConfig.client.auth.signInWithPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      
      if (response.user != null) {
        _user = response.user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
    } catch (e) {
      print('Login Error: $e');
      _errorMessage = 'Login failed: Invalid email or password';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await SupabaseConfig.client.auth.signOut();
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
