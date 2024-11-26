import '../../data/mock_scenes_repository.dart';
import 'scene_model.dart';

class ScenesController {
  final MockScenesRepository _repository;

  ScenesController(this._repository);

  // Fetch all scenes for a specific user
  List<Scene> getScenes(String userId) {
    return _repository.getScenesByUserId(userId);
  }

  // Update a scene
  void updateScene(Scene scene) {
    _repository.updateScene(scene);
  }

  // Add a new scene
  void addScene(Scene scene) {
    _repository.addScene(scene);
  }

  // Remove a scene by ID
  void removeScene(String sceneId, String userId) {
    _repository.deleteScene(sceneId,userId);
  }
}
