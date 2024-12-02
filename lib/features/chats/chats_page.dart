import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/features/chats/chat_controller.dart';
import 'package:chat/features/chats/addChatPage.dart';
import 'package:chat/features/scenes/scenes_controller.dart';
import 'package:chat/features/chatters/chatters_controller.dart';

class ChatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the ChatController, ScenesController, and ChattersController using Provider
    final chatController = Provider.of<ChatController>(context);
    final scenesController = Provider.of<ScenesController>(context);
    final chattersController = Provider.of<ChattersController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: FutureBuilder<void>(
        future: chatController.loadChats(), // Load chats from the database
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (chatController.chats.isEmpty) {
            return const Center(child: Text('No chats available'));
          }

          return ListView.builder(
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
                      // Example: Navigator.push(...);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddChatPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddChatPage(
                scenesController: scenesController,
                chattersController: chattersController,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
