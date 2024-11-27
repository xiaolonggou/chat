// lib/features/scenes/scenes_repository.dart

import 'scene_model.dart';

abstract class ScenesRepository {
  Future<List<Scene>> fetchScenes();
  Future<void> saveScene(Scene scene);
  Future<void> deleteScene(int id);
}
