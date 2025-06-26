import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;

  bool get isAuthenticated => _token != null;
    AuthProvider() {
    _loadToken();
  }
    Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    debugPrint("AuthProvider initialized. Token: $_token");
    notifyListeners();
  }

  Future <void> login(String email, String password) async {
    
    try{
      debugPrint("Login called with email: $email and password: $password");
      final response = await http.post(
        Uri.parse('http://192.168.29.61:3000/candidate/signin'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      
   debugPrint("RESPONSE IS: ${response.body}");
   debugPrint("RESPONSE STATUS CODE IS: ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint("Logged in successfully");
 debugPrint("Data is: $data");
        _token = data['token'];
       final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);

        debugPrint("Logged in and saved Token: $_token"); 
        debugPrint("Token is: $_token");

notifyListeners();
debugPrint("Notify listeners called after login");
      } else if (response.statusCode == 400) {
        throw Exception('Invalid email or password');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid email or password');
      } else {
        throw Exception('Failed to login');
      }
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }


Future<void> logout() async {
  _token = null;

  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');

  notifyListeners();
}

String? get token => _token;
}