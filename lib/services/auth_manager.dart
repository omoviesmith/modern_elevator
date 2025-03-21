import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthManager {
  // Singleton instance
  static final AuthManager _instance = AuthManager._internal();
  
  factory AuthManager() {
    return _instance;
  }
  
  AuthManager._internal();
  
  // Current user data
  Map<String, dynamic>? _currentUser;
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await ApiService.isLoggedIn();
  }
  
  // Get current user data
  Future<Map<String, dynamic>?> getCurrentUser() async {
    if (_currentUser != null) {
      return _currentUser;
    }
    
    _currentUser = await ApiService.getCurrentUser();
    return _currentUser;
  }
  
  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await ApiService.login(email, password);
    _currentUser = response['data']['user'];
    return response;
  }
  
  // Register
  Future<Map<String, dynamic>> register(
      String firstName,
      String lastName,
      String email,
      String password,
      String role,
      {String? phoneNumber}) async {
    return await ApiService.register(
      firstName, 
      lastName, 
      email, 
      password, 
      role,
      phoneNumber: phoneNumber
    );
  }
  
  // Verify email
  Future<Map<String, dynamic>> verifyEmail(String email, String code) async {
    return await ApiService.verifyEmail(email, code);
  }
  
  // Forgot password
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    return await ApiService.forgotPassword(email);
  }
  
  // Reset password
  Future<Map<String, dynamic>> resetPassword(String token, String newPassword) async {
    return await ApiService.resetPassword(token, newPassword);
  }
  
  // Logout
  Future<void> logout() async {
    await ApiService.logout();
    _currentUser = null;
  }
  
  // Save temporary registration data for verification
  Future<void> saveRegistrationData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tempRegistration', jsonEncode(data));
  }
  
  // Get temporary registration data
  Future<Map<String, dynamic>?> getRegistrationData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('tempRegistration');
    
    if (data != null) {
      return jsonDecode(data);
    }
    
    return null;
  }
  
  // Clear temporary registration data
  Future<void> clearRegistrationData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('tempRegistration');
  }
}