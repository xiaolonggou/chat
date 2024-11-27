import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'scenes_controller.dart';
import 'edit_scene_page.dart';
import 'scene_model.dart';

class ScenesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Scenes'),
            AddSceneButton(),
          ],
        ),
      ),
      body: Consumer<ScenesController>(
        builder: (context, controller, child) {
          // Check if scenes are loading
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } 
          // Check if there's an error
          else if (controller.errorMessage != null) {
            return Center(child: Text('Error: ${controller.errorMessage}'));
          } 
          // Display list of scenes
          else {
            return ScenesList(scenes: controller.scenes);
          }
        },
      ),
    );
  }
}

class AddSceneButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton.small(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditScenePage(
              scene: Scene(
                id: null,
                userId: 1,
                name: '',
                description: '',
                mood: '',
                topic: '',
                language: 'en',
              ),
            ),
          ),
        ).then((_) => Provider.of<ScenesController>(context, listen: false).fetchScenes());
      },
      backgroundColor: theme.colorScheme.inversePrimary,
      elevation: 0,
      child: const Icon(Icons.add),
    );
  }
}

class ScenesList extends StatelessWidget {
  final List<Scene> scenes;

  const ScenesList({Key? key, required this.scenes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: scenes.length,
      itemBuilder: (context, index) {
        return SceneListItem(scene: scenes[index], isEven: index % 2 == 0);
      },
    );
  }
}

class SceneListItem extends StatelessWidget {
  final Scene scene;
  final bool isEven;

  const SceneListItem({Key? key, required this.scene, required this.isEven}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ScenesController>(context, listen: false);
    final theme = Theme.of(context);
    final backgroundColor = isEven
        ? theme.colorScheme.inversePrimary.withOpacity(0.1)
        : theme.colorScheme.inversePrimary.withOpacity(0.3);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Dismissible(
        key: Key(scene.id?.toString() ?? 'scene-${scene.name}'),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          if (scene.id != null) {
            controller.deleteScene(scene.id!);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${scene.name} deleted')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cannot delete scene with null ID')),
            );
          }
        },
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8.0),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16.0),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            title: Text(scene.name),
            subtitle: Text(scene.description),
            trailing: IconButton(
              icon: Icon(Icons.edit, color: theme.colorScheme.primary),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditScenePage(scene: scene),
                  ),
                ).then((_) => controller.fetchScenes());
              },
            ),
          ),
        ),
      ),
    );
  }
}
