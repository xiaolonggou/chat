// lib/features/scenes/mock_scenes_repository.dart

import 'package:chat/features/scenes/scenes_repository.dart';
import 'package:flutter/material.dart';
import '../features/scenes/scene_model.dart';

class MockScenesRepository implements ScenesRepository {
  final List<Scene> _scenes = [
    Scene(
      id: 1,
      name: 'Living Room Chat',
      description: 'A cozy conversation in the living room.',
      mood: 'Relaxed',
      topic: 'Movies',
      language: 'en',
    ),
    Scene(
      id: 2,
      name: 'Office Meeting',
      description: 'A discussion during a business meeting.',
      mood: 'Professional',
      topic: 'Work Projects',
      language: 'de',
    ),
  ];

  @override
  Future<List<Scene>> fetchScenes(BuildContext buildContext) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
    return List<Scene>.from(
        _scenes); // Return a copy to avoid direct modification
  }

  @override
  Future<void> saveScene(Scene scene, BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
    final index = _scenes.indexWhere((s) => s.id == scene.id);
    if (index != -1) {
      // Update existing scene
      _scenes[index] = scene;
    } else {
      // Add new scene
      final newId = _scenes.isNotEmpty
          ? _scenes.map((s) => s.id).reduce((a, b) => a! > b! ? a : b)! + 1
          : 1;
      _scenes.add(scene.copyWith(id: newId));
    }
  }

  @override
  Future<void> deleteScene(int id, BuildContext context) async {
    // Fixed method signature here
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
    _scenes.removeWhere((scene) => scene.id == id);
  }

  Future<List<Scene>> getScenesByUserId(int userId) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
    return _scenes;
  }

  void updateScene(Scene updatedScene) {
    final index = _scenes.indexWhere((s) => s.id == updatedScene.id);
    if (index != -1) {
      _scenes[index] = updatedScene;
    }
  }
}
