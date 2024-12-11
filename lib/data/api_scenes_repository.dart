import 'dart:convert';
import 'package:chat/data/ApiClient.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../features/scenes/scene_model.dart';
import '../features/scenes/scenes_repository.dart';
import '../shared/utils/token_storage.dart';

class ApiScenesRepository implements ScenesRepository {
  // Private constructor
  ApiScenesRepository._internal({required this.baseUrl});

  // Singleton instance
  static ApiScenesRepository? _instance;

  // Factory constructor for creating/accessing the singleton instance
  factory ApiScenesRepository({required String baseUrl}) {
    _instance ??= ApiScenesRepository._internal(baseUrl: baseUrl);
    return _instance!;
  }

  // Base URL for API calls
  final String baseUrl;

  // Private helper method to get the JWT token
  Future<String?> _getToken() async {
    return await TokenStorage
        .retrieveToken(); // Retrieve the token from secure storage
  }

  Future<List<Scene>> fetchScenes(BuildContext context) async {
    final token = await TokenStorage.retrieveToken(); // Get the token
    final client = ApiClient(baseUrl: baseUrl, context: context);

    try {
      final response = await client.get(
        'scenes',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((scene) => Scene.fromJson(scene)).toList();
      } else {
        throw Exception('Failed to fetch scenes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching scenes: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveScene(Scene scene, BuildContext context) async {
    final token = await _getToken(); // Get the token
    final Uri url = scene.id != null
        ? Uri.parse('$baseUrl/scenes/${scene.id}') // For existing scene
        : Uri.parse('$baseUrl/scenes'); // For new scene (POST)

    final response = await (scene.id != null
        ? http.put(
            url,
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: jsonEncode(scene.toJson()),
          )
        : http.post(
            url,
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: jsonEncode(scene.toJson()..remove('id')),
          ));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to save scene');
    }
  }

  @override
  Future<void> deleteScene(int id, BuildContext context) async {
    final token = await _getToken(); // Get the token

    final response = await http.delete(
      Uri.parse('$baseUrl/scenes/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null)
          'Authorization': 'Bearer $token', // Add Authorization header
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete scene');
    }
  }
}
