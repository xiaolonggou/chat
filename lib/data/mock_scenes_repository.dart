// lib/features/scenes/mock_scenes_repository.dart

import '../features/scenes/scene_model.dart'; // Import the Scene model

class MockScenesRepository {
  List<Scene> _scenes = [
    Scene(
      id: '1',
      name: 'Living Room Chat',
      description: 'A cozy conversation in the living room.',
      mood: 'Relaxed',
      topic: 'Movies',  // Example topic
    ),
    Scene(
      id: '2',
      name: 'Office Meeting',
      description: 'A discussion during a business meeting.',
      mood: 'Professional',
      topic: 'Work Projects', // Example topic
    ),
    Scene(
      id: '3',
      name: 'Café Talk',
      description: 'A casual conversation over coffee.',
      mood: 'Casual',
      topic: 'Travel Plans', // Example topic
    ),
    // Add more scenes as needed
  ];

  // Method to retrieve all scenes
  List<Scene> getScenes() {
    return _scenes;
  }

  // Method to add a new scene
  void addScene(Scene scene) {
    _scenes.add(scene);
  }

  // Method to get a scene by its ID
  Scene getSceneById(String id) {
    return _scenes.firstWhere((scene) => scene.id == id);
  }

  // Method to update a scene (you can expand this logic as needed)
  void updateScene(Scene updatedScene) {
    final index = _scenes.indexWhere((scene) => scene.id == updatedScene.id);
    if (index != -1) {
      _scenes[index] = updatedScene;
    }
  }

  // Method to remove a scene
  void deleteScene(String id) {
    _scenes.removeWhere((scene) => scene.id == id);
  }
}
