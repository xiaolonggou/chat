// lib/features/scenes/edit_scene_page.dart

import 'package:flutter/material.dart';
import 'scene_model.dart'; // Import the Scene model
import '../../data/mock_scenes_repository.dart'; // Import the MockScenesRepository

class EditScenePage extends StatefulWidget {
  final Scene scene; // The scene to be edited

  const EditScenePage({super.key, required this.scene});

  @override
  _EditScenePageState createState() => _EditScenePageState();
}

class _EditScenePageState extends State<EditScenePage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _moodController;
  late TextEditingController _topicController;
  late TextEditingController _languageController; // New controller for language

  @override
  void initState() {
    super.initState();

    // Initialize controllers with current scene data
    _nameController = TextEditingController(text: widget.scene.name);
    _descriptionController = TextEditingController(text: widget.scene.description);
    _moodController = TextEditingController(text: widget.scene.mood);
    _topicController = TextEditingController(text: widget.scene.topic);
    _languageController = TextEditingController(text: widget.scene.language); // Initialize with language
  }

  @override
  void dispose() {
    // Dispose controllers when the page is disposed
    _nameController.dispose();
    _descriptionController.dispose();
    _moodController.dispose();
    _topicController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Scene'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Scene Name'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Scene Description'),
              ),
              TextFormField(
                controller: _moodController,
                decoration: InputDecoration(labelText: 'Mood'),
              ),
              TextFormField(
                controller: _topicController,
                decoration: InputDecoration(labelText: 'Topic'),
              ),
              TextFormField(
                controller: _languageController,
                decoration: InputDecoration(labelText: 'Language'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveScene,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to save the updated scene
  void _saveScene() {
    final updatedScene = Scene(
      id: widget.scene.id, // Keep the same ID
      name: _nameController.text,
      description: _descriptionController.text,
      mood: _moodController.text,
      topic: _topicController.text,
      language: _languageController.text, 
      userId: widget.scene.userId,  // Updated language
    );

    // Update the scene using the MockScenesRepository
    final repository = MockScenesRepository();
    repository.updateScene(updatedScene);

    // Navigate back to the previous page
    Navigator.pop(context);
  }
}
