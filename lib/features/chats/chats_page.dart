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
      appBar: AppBar(title: const Text('Chats')),
      body: ListView.builder(
        itemCount: chatController.chatters.length,
        itemBuilder: (context, index) {
          final chatter = chatController.chatters[index];
          return ListTile(
            title: Text(chatter.name),
            subtitle: Text(chatter.objective ?? 'No objective'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Navigate to edit page (implement your own edit page if needed)
              },
            ),
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
