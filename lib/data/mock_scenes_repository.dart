// lib/features/scenes/mock_scenes_repository.dart

import '../features/scenes/scene_model.dart'; // Import the Scene model

class MockScenesRepository {
  List<Scene> _scenes = [
    Scene(
      id: '1',
      name: 'Living Room Chat',
      description: 'A cozy conversation in the living room.',
      mood: 'Relaxed',
      topic: 'Movies',
      language: 'English',  // Example language
      userId: 'user123',    // Example user ID
    ),
    Scene(
      id: '2',
      name: 'Office Meeting',
      description: 'A discussion during a business meeting.',
      mood: 'Professional',
      topic: 'Work Projects',
      language: 'English',
      userId: 'user123',
    ),
    Scene(
      id: '3',
      name: 'Café Talk',
      description: 'A casual conversation over coffee.',
      mood: 'Casual',
      topic: 'Travel Plans',
      language: 'English',
      userId: 'user123',
    ),
    // Add more scenes as needed, ensuring you associate a userId with each scene
  ];

  // Method to retrieve all scenes (for a particular user, if needed)
  List<Scene> getScenesByUserId(String userId) {
    return _scenes.where((scene) => scene.userId == userId).toList();
  }

  // Method to add a new scene
  void addScene(Scene scene) {
    _scenes.add(scene);
  }

  // Method to get a scene by its ID (for a particular user, if needed)
  Scene getSceneById(String id, String userId) {
    return _scenes.firstWhere(
      (scene) => scene.id == id && scene.userId == userId,
      orElse: () => throw Exception('Scene not found for the given userId'),
    );
  }

  // Method to update a scene (you can expand this logic as needed)
  void updateScene(Scene updatedScene) {
    final index = _scenes.indexWhere((scene) => scene.id == updatedScene.id);
    if (index != -1) {
      _scenes[index] = updatedScene;
    }
  }

  // Method to remove a scene
  void deleteScene(String id, String userId) {
    _scenes.removeWhere(
      (scene) => scene.id == id && scene.userId == userId,
    );
  }
}
