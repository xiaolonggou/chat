import 'package:chat/shared/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:chat/features/scenes/scenes_controller.dart';
import 'package:chat/features/chatters/chatters_controller.dart';
import 'package:chat/features/scenes/scene_model.dart';
import 'package:chat/features/chatters/chatters_model.dart';
import 'package:chat/features/chats/local_chatter_model.dart';
import 'package:chat/features/chats/chat_model.dart';
import 'package:sqflite/sqflite.dart'; // Import Chat model

class AddChatPage extends StatefulWidget {
  final ScenesController scenesController;
  final ChattersController chattersController;
  final Chat? chat; // Null if creating a new chat

  const AddChatPage({
    Key? key,
    required this.scenesController,
    required this.chattersController,
    this.chat,
  }) : super(key: key);

  @override
  _AddChatPageState createState() => _AddChatPageState();
}

class _AddChatPageState extends State<AddChatPage> {
  late Future<List<Scene>> _scenesFuture;
  late Future<List<Chatter>> _chattersFuture;

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _meetingReasonController =
      TextEditingController();
  final List<LocalChatter> _selectedChatters = [];
  Scene? _selectedScene;

  @override
  void initState() {
    super.initState();

    _scenesFuture = widget.scenesController.repository.fetchScenes(context);
    _chattersFuture = widget.chattersController.repository.fetchChatters();

    if (widget.chat != null) {
      _populateFormWithExistingChat();
    }
  }

  // Populate the form with existing chat data
  void _populateFormWithExistingChat() {
    _subjectController.text = widget.chat!.subject;
    _meetingReasonController.text = widget.chat!.meetingReason;
    _selectedScene = widget.chat!.scene;
    _selectedChatters.addAll(widget.chat!.participants);
  }

  // Check if the form is valid
  bool _isFormValid() {
    return _subjectController.text.isNotEmpty &&
        _meetingReasonController.text.isNotEmpty &&
        _selectedScene != null &&
        _selectedChatters.isNotEmpty;
  }

  // Save or update the chat based on whether it's a new or existing chat
  Future<void> _saveChat() async {
    if (_isFormValid()) {
      final db = await DBHelper().database;

      if (widget.chat == null) {
        await _createChat(db);
      } else {
        await _updateChat(db);
      }

      Navigator.of(context).pop(true);
    } else {
      _showSnackbar('Please fill out all fields');
    }
  }

  // Create a new chat
  Future<void> _createChat(Database db) async {
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
  }

  // Update an existing chat
  Future<void> _updateChat(Database db) async {
    await db.update(
      'chats',
      {
        'subject': _subjectController.text,
        'meetingReason': _meetingReasonController.text,
        'sceneId': _selectedScene!.id,
      },
      where: 'id = ?',
      whereArgs: [widget.chat!.id],
    );

    // Replace participants
    await db.delete('chat_participants',
        where: 'chatId = ?', whereArgs: [widget.chat!.id]);
    for (final chatter in _selectedChatters) {
      await db.insert('chat_participants', {
        'chatId': widget.chat!.id,
        'participantId': chatter.id,
        'objective': chatter.objective,
        'mood': chatter.mood,
      });
    }

    _showSnackbar('Chat updated successfully');
  }

  // Show a snackbar with a message
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Edit chatter's objective and mood
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
                setState(() {
                  chatter.objective = objectiveController.text;
                  chatter.mood = moodController.text;
                });
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
      appBar:
          AppBar(title: Text(widget.chat == null ? 'Add Chat' : 'Edit Chat')),
      body: FutureBuilder<List<Scene>>(
        future: _scenesFuture,
        builder: (context, sceneSnapshot) {
          if (sceneSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (sceneSnapshot.hasError ||
              !sceneSnapshot.hasData ||
              sceneSnapshot.data!.isEmpty) {
            return const Center(child: Text('No scenes available.'));
          }

          return FutureBuilder<List<Chatter>>(
            future: _chattersFuture,
            builder: (context, chatterSnapshot) {
              if (chatterSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (chatterSnapshot.hasError ||
                  !chatterSnapshot.hasData ||
                  chatterSnapshot.data!.isEmpty) {
                return const Center(child: Text('No chatters available.'));
              }

              final scenes = sceneSnapshot.data!;
              final chatters = chatterSnapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildTextField(
                        _subjectController, 'Subject', 'Enter chat subject'),
                    const SizedBox(height: 16),
                    _buildTextField(_meetingReasonController,
                        'Reason for Meeting', 'Enter reason for meeting'),
                    const SizedBox(height: 16),
                    _buildSceneDropdown(scenes),
                    const SizedBox(height: 16),
                    _buildChatterDropdown(chatters),
                    const SizedBox(height: 16),
                    _buildSelectedChattersList(),
                    ElevatedButton(
                      onPressed: _saveChat,
                      child: Text(
                          widget.chat == null ? 'Create Chat' : 'Update Chat'),
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

  // Helper method for text fields
  Widget _buildTextField(
      TextEditingController controller, String label, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
    );
  }

  // Build scene dropdown
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

  // Build chatter dropdown
  Widget _buildChatterDropdown(List<Chatter> chatters) {
    return DropdownButtonFormField<Chatter>(
      decoration: const InputDecoration(
        labelText: 'Select Chatter',
        border: OutlineInputBorder(),
      ),
      onChanged: (Chatter? chatter) {
        if (chatter != null) {
          setState(
              () => _selectedChatters.add(LocalChatter.fromChatter(chatter)));
        }
      },
      items: chatters.map((chatter) {
        return DropdownMenuItem<Chatter>(
          value: chatter,
          child: Text(chatter.name),
        );
      }).toList(),
    );
  }

  // Build selected chatters list
  Widget _buildSelectedChattersList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _selectedChatters.length,
        itemBuilder: (context, index) {
          final chatter = _selectedChatters[index];
          return ListTile(
            title: Text(chatter.name),
            subtitle: Text(
                'Objective: ${chatter.objective ?? "Not set"}, Mood: ${chatter.mood ?? "Not set"}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _showEditDialog(chatter);
              },
            ),
          );
        },
      ),
    );
  }
}
