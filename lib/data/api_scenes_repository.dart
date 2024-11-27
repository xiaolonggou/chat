// lib/data/api_scenes_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../features/scenes/scene_model.dart';
import '../features/scenes/scenes_repository.dart';

class ApiScenesRepository implements ScenesRepository {
  final String baseUrl;

  ApiScenesRepository({required this.baseUrl});

  @override
  Future<List<Scene>> fetchScenes() async {
    final response = await http.get(Uri.parse('$baseUrl/scenes'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((scene) => Scene.fromJson(scene)).toList();
    } else {
      throw Exception('Failed to fetch scenes');
    }
  }

  @override
  Future<void> saveScene(Scene scene) async {
    final Uri url = scene.id != null
        ? Uri.parse('$baseUrl/scenes/${scene.id}') // For existing scene
        : Uri.parse('$baseUrl/scenes'); // For new scene (POST)

    final response = await (scene.id != null
        ? http.put(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(scene.toJson()),
          )
        : http.post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(scene.toJson()..remove('id')),
          ));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to save scene');
    }
  }

  @override
  Future<void> deleteScene(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/scenes/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete scene');
    }
  }
}
