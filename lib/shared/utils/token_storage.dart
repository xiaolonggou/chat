import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static final _storage = FlutterSecureStorage();

  // Store the token
  static Future<void> storeToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // Retrieve the token
  static Future<String?> retrieveToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Remove the token
  static Future<void> removeToken() async {
    await _storage.delete(key: 'jwt_token');
  }
}
