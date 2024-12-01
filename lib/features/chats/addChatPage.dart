import 'package:flutter/material.dart';
import 'package:chat/features/scenes/scenes_controller.dart';
import 'package:chat/features/chatters/chatters_controller.dart';
import 'package:chat/features/scenes/scene_model.dart';
import 'package:chat/features/chatters/chatters_model.dart';
import 'package:chat/features/chats/local_chatter_model.dart';

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
  List<LocalChatter> selectedChatters = [];
  Scene? selectedScene;

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController meetingReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scenesFuture = widget.scenesController.repository.fetchScenes();
    _chattersFuture = widget.chattersController.repository.fetchChatters();
  }

  void _addLocalChatter(Chatter chatter) {
    final localChatter = LocalChatter(
      id: chatter.id,
      name: chatter.name,
      gender: chatter.gender,
      job: chatter.job,
      personality: chatter.personality,
      objective: '',
      mood: '',
    );

    setState(() {
      selectedChatters.add(localChatter);
    });
  }

  void _updateLocalChatter(LocalChatter chatter, String objective, String mood) {
    final updatedChatter = chatter.copyWith(objective: objective, mood: mood);

    setState(() {
      int index = selectedChatters.indexOf(chatter);
      if (index != -1) {
        selectedChatters[index] = updatedChatter;
      }
    });
  }

  bool _isFormValid() {
    return subjectController.text.isNotEmpty &&
        meetingReasonController.text.isNotEmpty &&
        selectedScene != null &&
        selectedChatters.isNotEmpty;
  }

  void _createChat() {
    if (_isFormValid()) {
      print('Chat created with subject: ${subjectController.text} and reason: ${meetingReasonController.text}');
    } else {
      print('Please fill out all fields.');
    }
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
            return const Center(child: CircularProgressIndicator());
          } else if (scenesSnapshot.hasError) {
            return Center(child: Text('Error: ${scenesSnapshot.error}'));
          } else if (!scenesSnapshot.hasData || scenesSnapshot.data!.isEmpty) {
            return const Center(child: Text('No scenes available'));
          }

          return FutureBuilder<List<Chatter>>(
            future: _chattersFuture,
            builder: (context, chattersSnapshot) {
              if (chattersSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (chattersSnapshot.hasError) {
                return Center(child: Text('Error: ${chattersSnapshot.error}'));
              } else if (!chattersSnapshot.hasData || chattersSnapshot.data!.isEmpty) {
                return const Center(child: Text('No chatters available'));
              }

              final scenes = scenesSnapshot.data!;
              final chatters = chattersSnapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        hintText: 'Enter the subject of the chat',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: meetingReasonController,
                      decoration: const InputDecoration(
                        labelText: 'Reason for Meeting',
                        hintText: 'Enter the reason for the meeting',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<Scene>(
                      decoration: const InputDecoration(
                        labelText: 'Select Scene',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedScene,
                      onChanged: (Scene? newValue) {
                        setState(() {
                          selectedScene = newValue;
                        });
                      },
                      items: scenes.map((scene) {
                        return DropdownMenuItem<Scene>(
                          value: scene,
                          child: Text(scene.name ?? 'Unknown'),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<Chatter>(
                      decoration: const InputDecoration(
                        labelText: 'Select Chatter',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (Chatter? selectedChatter) {
                        if (selectedChatter != null) {
                          _addLocalChatter(selectedChatter);
                        }
                      },
                      items: chatters.map((chatter) {
                        return DropdownMenuItem<Chatter>(
                          value: chatter,
                          child: Text(chatter.name),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: selectedChatters.length,
                        itemBuilder: (context, index) {
                          final localChatter = selectedChatters[index];
                          return ListTile(
                            title: Text(localChatter.name),
                            subtitle: Text(
                              'Objective: ${localChatter.objective!.isEmpty ? "Not set" : localChatter.objective}, Mood: ${localChatter.mood!.isEmpty ? "Not set" : localChatter.mood}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showEditDialog(localChatter),
                            ),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _createChat,
                      child: const Text('Create Chat'),
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
   void _showEditDialog(LocalChatter chatter) {
    final objectiveController = TextEditingController(text: chatter.objective);
    final moodController = TextEditingController(text: chatter.mood);

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
                decoration: const InputDecoration(labelText: 'Objective'),
              ),
              TextField(
                controller: moodController,
                decoration: const InputDecoration(labelText: 'Mood'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _updateLocalChatter(chatter, objectiveController.text, moodController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}