import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  String? _token;
  final String _baseUrl = 'http://192.168.0.20:3000';

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      body: json.encode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if(response.statusCode == 200) {
      _token = json.decode(response.body)['access_token'];
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String username, String password, String password2) async {
    if(password != password2) return false;

    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      body: json.encode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if(response.statusCode >= 200 && response.statusCode < 300) {
      _token = json.decode(response.body)['access_token'];
      return true;
    } else {
      return false;
    }
  }

  String? get token => _token;
}