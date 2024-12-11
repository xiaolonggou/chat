import 'dart:convert';
import 'package:chat/shared/utils/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final BuildContext context;

  ApiClient({required this.baseUrl, required this.context});

  /// Handles requests with error management
  Future<http.Response> _handleRequest(
      Future<http.Response> Function() request) async {
    try {
      final response = await request();

      if (response.statusCode == 401) {
        // Token expired or unauthorized
        await _handleUnauthorized();
      }

      return response;
    } catch (e) {
      print('HTTP Request error: $e');
      rethrow;
    }
  }

  /// Handles unauthorized responses (e.g., token expiration)
  Future<void> _handleUnauthorized() async {
    // Remove the stored token
    await TokenStorage.removeToken();

    // Show a session expired message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session expired. Please log in again.')),
    );

    // Navigate to login page
    Navigator.pushReplacementNamed(context, '/login');
  }

  /// Performs a GET request
  Future<http.Response> get(String endpoint,
      {Map<String, String>? headers}) async {
    return _handleRequest(() => http.get(
          Uri.parse('$baseUrl/$endpoint'),
          headers: headers,
        ));
  }

  /// Performs a POST request
  Future<http.Response> post(String endpoint, dynamic body,
      {Map<String, String>? headers}) async {
    return _handleRequest(() => http.post(
          Uri.parse('$baseUrl/$endpoint'),
          headers: headers ?? {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        ));
  }

  /// Performs a PUT request
  Future<http.Response> put(String endpoint, dynamic body,
      {Map<String, String>? headers}) async {
    return _handleRequest(() => http.put(
          Uri.parse('$baseUrl/$endpoint'),
          headers: headers ?? {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        ));
  }

  /// Performs a DELETE request
  Future<http.Response> delete(String endpoint,
      {Map<String, String>? headers}) async {
    return _handleRequest(() => http.delete(
          Uri.parse('$baseUrl/$endpoint'),
          headers: headers,
        ));
  }

  /// Optionally add PATCH request
  Future<http.Response> patch(String endpoint, dynamic body,
      {Map<String, String>? headers}) async {
    return _handleRequest(() => http.patch(
          Uri.parse('$baseUrl/$endpoint'),
          headers: headers ?? {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        ));
  }
}
