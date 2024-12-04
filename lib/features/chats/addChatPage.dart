import 'package:chat/shared/utils/db_helper.dart';
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

  final List<LocalChatter> _selectedChatters = [];
  Scene? _selectedScene;

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _meetingReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scenesFuture = widget.scenesController.repository.fetchScenes();
    _chattersFuture = widget.chattersController.repository.fetchChatters();
  }

  void _addChatter(Chatter chatter) {
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
      _selectedChatters.add(localChatter);
    });
  }

  void _editChatter(LocalChatter chatter, String objective, String mood) {
    final updatedChatter = chatter.copyWith(objective: objective, mood: mood);

    setState(() {
      final index = _selectedChatters.indexOf(chatter);
      if (index != -1) {
        _selectedChatters[index] = updatedChatter;
      }
    });
  }

  bool _isFormValid() {
    return _subjectController.text.isNotEmpty &&
        _meetingReasonController.text.isNotEmpty &&
        _selectedScene != null &&
        _selectedChatters.isNotEmpty;
  }

  Future<void> _createChat() async {
    if (_isFormValid()) {
      final db = await DBHelper().database;

      final chatId = DateTime.now().millisecondsSinceEpoch.toString();

      await db.insert('chats', {
        'id': chatId,
        'subject': _subjectController.text,
        'meetingReason': _meetingReasonController.text,
        'sceneId': _selectedScene!.id,
      });

      for (final chatter in _selectedChatters) {
        await db.insert('chat_participants', {
          'chatId': chatId,
          'participantId': chatter.id,
          'objective': chatter.objective,
          'mood': chatter.mood,
        });
      }

      _showSnackbar('Chat created successfully');
      _refreshData();
      Navigator.of(context).pop(true);
    } else {
      _showSnackbar('Please fill out all fields');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildSceneDropdown(List<Scene> scenes) {
    return DropdownButtonFormField<Scene>(
      decoration: const InputDecoration(
        labelText: 'Select Scene',
        border: OutlineInputBorder(),
      ),
      value: _selectedScene,
      onChanged: (Scene? newScene) => setState(() => _selectedScene = newScene),
      items: scenes.map((scene) {
        return DropdownMenuItem<Scene>(
          value: scene,
          child: Text(scene.name ?? 'Unknown'),
        );
      }).toList(),
    );
  }

  Widget _buildChatterDropdown(List<Chatter> chatters) {
    return DropdownButtonFormField<Chatter>(
      decoration: const InputDecoration(
        labelText: 'Select Chatter',
        border: OutlineInputBorder(),
      ),
      onChanged: (Chatter? chatter) {
        if (chatter != null) _addChatter(chatter);
      },
      items: chatters.map((chatter) {
        return DropdownMenuItem<Chatter>(
          value: chatter,
          child: Text(chatter.name),
        );
      }).toList(),
    );
  }

  Widget _buildSelectedChattersList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _selectedChatters.length,
        itemBuilder: (context, index) {
          final chatter = _selectedChatters[index];
          return ListTile(
            title: Text(chatter.name),
            subtitle: Text(
              'Objective: ${chatter.objective!.isEmpty ? "Not set" : chatter.objective}, '
              'Mood: ${chatter.mood!.isEmpty ? "Not set" : chatter.mood}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditDialog(chatter),
            ),
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
                _editChatter(chatter, objectiveController.text, moodController.text);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Chat')),
      body: FutureBuilder<List<Scene>>(
        future: _scenesFuture,
        builder: (context, sceneSnapshot) {
          if (sceneSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (sceneSnapshot.hasError || !sceneSnapshot.hasData || sceneSnapshot.data!.isEmpty) {
            return const Center(child: Text('No scenes available.'));
          }

          return FutureBuilder<List<Chatter>>(
            future: _chattersFuture,
            builder: (context, chatterSnapshot) {
              if (chatterSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (chatterSnapshot.hasError || !chatterSnapshot.hasData || chatterSnapshot.data!.isEmpty) {
                return const Center(child: Text('No chatters available.'));
              }

              final scenes = sceneSnapshot.data!;
              final chatters = chatterSnapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        hintText: 'Enter chat subject',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _meetingReasonController,
                      decoration: const InputDecoration(
                        labelText: 'Reason for Meeting',
                        hintText: 'Enter reason for meeting',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSceneDropdown(scenes),
                    const SizedBox(height: 16),
                    _buildChatterDropdown(chatters),
                    const SizedBox(height: 16),
                    _buildSelectedChattersList(),
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
  
  void _refreshData() {  setState(() {
    // Re-fetch the scenes and chatters from the database
    _scenesFuture = widget.scenesController.repository.fetchScenes();
    _chattersFuture = widget.chattersController.repository.fetchChatters();
    _subjectController.clear();
    _meetingReasonController.clear();
    _selectedChatters.clear();
    _selectedScene = null;
  });}
}
