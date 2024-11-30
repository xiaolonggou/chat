import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../shared/utils/token_storage.dart';

class AuthService {
  final String baseUrl;

  AuthService({required this.baseUrl});

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String token = data['token'];

      // Store the token securely
      await TokenStorage.storeToken(token);

      return true;
    } else {
      return false;
    }
  }

  // Logout by removing the token
  Future<void> logout() async {
    await TokenStorage.removeToken();
  }
}
