// lib/data/api_scenes_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../features/scenes/scene_model.dart';
import '../features/scenes/scenes_repository.dart';
import '../shared/utils/token_storage.dart';

class ApiScenesRepository implements ScenesRepository {
  final String baseUrl;

  ApiScenesRepository({required this.baseUrl});

  // Helper method to get the JWT token
  Future<String?> _getToken() async {
    return await TokenStorage.retrieveToken(); // Read the token from secure storage
  }

  @override
  Future<List<Scene>> fetchScenes() async {
    final token = await _getToken(); // Get the token

    final response = await http.get(
      Uri.parse('$baseUrl/scenes'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token', // Add Authorization header
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((scene) => Scene.fromJson(scene)).toList();
    } else {
      throw Exception('Failed to fetch scenes');
    }
  }

  @override
  Future<void> saveScene(Scene scene) async {
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
  Future<void> deleteScene(int id) async {
    final token = await _getToken(); // Get the token

    final response = await http.delete(
      Uri.parse('$baseUrl/scenes/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token', // Add Authorization header
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete scene');
    }
  }
}
