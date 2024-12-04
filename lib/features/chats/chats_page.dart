import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/features/chats/chat_controller.dart';
import 'package:chat/features/chats/addChatPage.dart';
import 'package:chat/features/scenes/scenes_controller.dart';
import 'package:chat/features/chatters/chatters_controller.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    final chatController = Provider.of<ChatController>(context, listen: false);
    try {
      await chatController.loadChats(); // Load chats from the database
    } catch (e) {
      print('Error loading chats: $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatController = Provider.of<ChatController>(context);
    final scenesController = Provider.of<ScenesController>(context);
    final chattersController = Provider.of<ChattersController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : chatController.chats.isEmpty
              ? const Center(child: Text('No chats available'))
              : ListView.builder(
                  itemCount: chatController.chats.length,
                  itemBuilder: (context, index) {
                    final chat = chatController.chats[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        title: Text(chat.subject),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Reason: ${chat.meetingReason}'),
                            const SizedBox(height: 4.0),
                            Text('Scene: ${chat.scene.name}'),
                            const SizedBox(height: 4.0),
                            Text(
                              'Participants: ${chat.participants.map((p) => p.name).join(', ')}',
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Navigate to edit page (implement your own edit page if needed)
                          },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to AddChatPage and wait for a result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddChatPage(
                scenesController: scenesController,
                chattersController: chattersController,
              ),
            ),
          );

          // Reload chats if a new chat was added
          if (result == true) {
            _loadChats();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
