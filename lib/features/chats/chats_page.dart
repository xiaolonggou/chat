import 'package:chat/features/chats/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/features/chats/chats_controller.dart';
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
    final chatController = Provider.of<ChatsController>(context, listen: false);
    try {
      await chatController.loadChats(); // Load chats from the database
    } catch (e) {
      print('Error loading chats: $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _deleteChat(String chatId) async {
    final chatController = Provider.of<ChatsController>(context, listen: false);
    try {
      await chatController.deleteChat(chatId); // Call the delete function
      await _loadChats(); // Reload chats after deletion
    } catch (e) {
      print('Error deleting chat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete chat: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatsController = Provider.of<ChatsController>(context);
    final scenesController = Provider.of<ScenesController>(context);
    final chattersController = Provider.of<ChattersController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : chatsController.chats.isEmpty
              ? const Center(child: Text('No chats available'))
              : ListView.builder(
                  itemCount: chatsController.chats.length,
                  itemBuilder: (context, index) {
                    final chat = chatsController.chats[index];

                    return Dismissible(
                      key: Key(chat.id), // Use a unique key for each item
                      direction: DismissDirection.endToStart, // Swipe left to delete
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _deleteChat(chat.id); // Call delete chat function
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${chat.subject} deleted')),
                        );
                      },
                      child: Card(
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
                          onTap: () {
                          // Navigate to ChatPage with chat details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                chat: chat,
                                chatsController: chatsController,
                              ),
                            ),
                          );
                        },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddChatPage(
                scenesController: scenesController,
                chattersController: chattersController,
              ),
            ),
          );

          if (result == true) {
            _loadChats();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
