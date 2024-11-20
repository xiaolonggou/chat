import '../../data/mock_scenes_repository.dart';

import 'scene_model.dart';

// lib/features/scenes/scenes_controller.dart

import 'scene_model.dart';
import '../../data/mock_scenes_repository.dart';

class ScenesController {
  final MockScenesRepository _repository;

  ScenesController(this._repository);

  // Fetch all scenes
  List<Scene> getScenes() {
    return _repository.getScenes();
  }

  // Update a scene
  void updateScene(Scene scene) {
    _repository.updateScene(scene);
  }

  // Add a new scene
  void addScene(Scene scene) {
    _repository.addScene(scene);
  }

  // Remove a scene
  void removeScene(String sceneId) {
    _repository.deleteScene(sceneId);
  }
}
