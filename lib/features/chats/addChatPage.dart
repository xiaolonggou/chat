import 'package:flutter/material.dart';
import 'package:chat/features/scenes/scenes_controller.dart';
import 'package:chat/features/chatters/chatters_controller.dart';
import 'package:chat/features/scenes/scene_model.dart';
import 'package:chat/features/chatters/chatters_model.dart';
import 'package:chat/features/chats/local_chatter_model.dart'; // Import LocalChatter model

class AddChatPage extends StatefulWidget {
  final ScenesController scenesController;
  final ChattersController chattersController;

  const AddChatPage({
    Key? key,
    required this.scenesController,
    required this.chattersController,
  }) : super(key: key);

  @override
  _AddChatPageState createState() => _AddChatPageState();
}

class _AddChatPageState extends State<AddChatPage> {
  late Future<List<Scene>> _scenesFuture;
  late Future<List<Chatter>> _chattersFuture;
  List<LocalChatter> selectedChatters = []; // List to hold selected LocalChatters
  Scene? selectedScene;

  @override
  void initState() {
    super.initState();
    // Initialize the Futures by calling the fetch methods from the controllers
    _scenesFuture = widget.scenesController.repository.fetchScenes(); 
    _chattersFuture = widget.chattersController.repository.fetchChatters();
  }

  // Function to handle adding a new chatter to the list
  void _addLocalChatter(Chatter chatter) {
    final localChatter = LocalChatter(
      id: chatter.id,
      name: chatter.name,
      gender: chatter.gender,
      job: chatter.job,
      personality: chatter.personality,
      objective: '', // Set dynamic properties like objective and mood
      mood: '',
    );

    setState(() {
      selectedChatters.add(localChatter); // Add to the list of selected chatters
    });
  }

  // Function to handle updating a chatter's dynamic properties
  void _updateLocalChatter(LocalChatter chatter, String objective, String mood) {
    final updatedChatter = chatter.copyWith(objective: objective, mood: mood);
    
    setState(() {
      int index = selectedChatters.indexOf(chatter);
      if (index != -1) {
        selectedChatters[index] = updatedChatter; // Update the selected chatter
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Chat'),
      ),
      body: FutureBuilder<List<Scene>>(
        future: _scenesFuture,
        builder: (context, scenesSnapshot) {
          if (scenesSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (scenesSnapshot.hasError) {
            return Center(child: Text('Error: ${scenesSnapshot.error}'));
          } else if (!scenesSnapshot.hasData || scenesSnapshot.data!.isEmpty) {
            return Center(child: Text('No scenes available'));
          }

          return FutureBuilder<List<Chatter>>(
            future: _chattersFuture,
            builder: (context, chattersSnapshot) {
              if (chattersSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (chattersSnapshot.hasError) {
                return Center(child: Text('Error: ${chattersSnapshot.error}'));
              } else if (!chattersSnapshot.hasData || chattersSnapshot.data!.isEmpty) {
                return Center(child: Text('No chatters available'));
              }

              // Once both Futures have data, build the UI for selecting a scene and chatter
              final scenes = scenesSnapshot.data!;
              final chatters = chattersSnapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButton<Scene>(
                      hint: Text('Select Scene'),
                      onChanged: (Scene? selected) {
                        setState(() {
                          selectedScene = selected;
                        });
                      },
                      value: selectedScene,
                      items: scenes.map((scene) {
                        return DropdownMenuItem<Scene>(
                          value: scene,
                          child: Text(scene.name ?? 'Unknown'),
                        );
                      }).toList(),
                    ),
                    DropdownButton<Chatter>(
                      hint: Text('Select Chatter'),
                      onChanged: (Chatter? selectedChatter) {
                        if (selectedChatter != null) {
                          _addLocalChatter(selectedChatter); // Add to selected chatters
                        }
                      },
                      items: chatters.map((chatter) {
                        return DropdownMenuItem<Chatter>(
                          value: chatter,
                          child: Text(chatter.name),
                        );
                      }).toList(),
                    ),
                    // Display selected chatters with options to modify their properties
                    Expanded(
                      child: ListView.builder(
                        itemCount: selectedChatters.length,
                        itemBuilder: (context, index) {
                          final localChatter = selectedChatters[index];
                          return ListTile(
                            title: Text(localChatter.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Objective: ${localChatter.objective ?? "Not set"}'),
                                Text('Mood: ${localChatter.mood ?? "Not set"}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Open dialog to update objective and mood
                                _showEditDialog(localChatter);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle chat creation logic here
                        // Pass the selected scene and localChatters to create a new chat
                      },
                      child: Text('Create Chat'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Show dialog to update objective and mood
  void _showEditDialog(LocalChatter chatter) {
    final TextEditingController objectiveController = TextEditingController(text: chatter.objective);
    final TextEditingController moodController = TextEditingController(text: chatter.mood);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Chatter: ${chatter.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: objectiveController,
                decoration: InputDecoration(labelText: 'Objective'),
              ),
              TextField(
                controller: moodController,
                decoration: InputDecoration(labelText: 'Mood'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Update the chatter's properties and close the dialog
                _updateLocalChatter(chatter, objectiveController.text, moodController.text);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
