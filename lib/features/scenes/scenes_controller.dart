// lib/features/scenes/scenes_controller.dart

import 'package:flutter/material.dart';
import 'scene_model.dart';
import 'scenes_repository.dart';

class ScenesController with ChangeNotifier {
  final ScenesRepository repository;

    ScenesController({required this.repository}) {
    fetchScenes();
  }

  List<Scene> _scenes = [];
  bool _isLoading = false;
  String? _errorMessage;

  /// Get all scenes
  List<Scene> get scenes => _scenes;

  /// Check if data is being loaded
  bool get isLoading => _isLoading;

  /// Get the current error message, if any
  String? get errorMessage => _errorMessage;

  /// Fetch all scenes and notify listeners
  Future<void> fetchScenes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _scenes = await repository.fetchScenes();
    } catch (e) {
      _errorMessage = 'Failed to fetch scenes: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save a scene (add or update) and refresh the scene list
  Future<void> saveScene(Scene scene) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await repository.saveScene(scene);
      await fetchScenes(); // Refresh the list after saving
    } catch (e) {
      _errorMessage = 'Failed to save scene: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete a scene and refresh the scene list
  Future<void> deleteScene(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await repository.deleteScene(id);
      await fetchScenes(); // Refresh the list after deletion
    } catch (e) {
      _errorMessage = 'Failed to delete scene: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
