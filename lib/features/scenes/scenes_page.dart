import 'package:flutter/material.dart';
import 'edit_scene_page.dart';
import '../../data/mock_scenes_repository.dart';
import 'scene_model.dart';

class ScenesPage extends StatefulWidget {
  @override
  _ScenesPageState createState() => _ScenesPageState();
}

class _ScenesPageState extends State<ScenesPage> {
  // Get the scenes from the repository
  late List<Scene> _scenes;

  @override
  void initState() {
    super.initState();
    _scenes = MockScenesRepository().getScenes(); // Load the scenes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Scenes'),
            FloatingActionButton.small(
              onPressed: () {
                // Handle adding a new scene
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Adding a new scene...')),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              elevation: 0,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),

      body: ListView.builder(
        itemCount: _scenes.length,
        itemBuilder: (context, index) {
          final scene = _scenes[index];
          return ListTile(
            title: Text(scene.name),
            subtitle: Text(scene.description),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Navigate to EditScenePage when the edit button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditScenePage(scene: scene),
                  ),
                );
              },
            ),
          );
        },
      ),
      
    );
  }
}