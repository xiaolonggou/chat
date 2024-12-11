// lib/features/scenes/scenes_repository.dart

import 'package:flutter/material.dart';

import 'scene_model.dart';

abstract class ScenesRepository {
  Future<List<Scene>> fetchScenes(BuildContext buildContext);
  Future<void> saveScene(Scene scene, BuildContext context);
  Future<void> deleteScene(int id, BuildContext context);
}
