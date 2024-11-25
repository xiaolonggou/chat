import 'package:flutter/material.dart';
import 'package:chat/features/chats/chat_model.dart';
import 'package:chat/features/chats/chat_page.dart';
// Mock Data for Chats
class Chat {
  final String id;
  final String scene;
  final List<String> participants;
  final String lastMessage;

  Chat({
    required this.id,
    required this.scene,
    required this.participants,
    required this.lastMessage,
  });
}

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final List<Chat> chats = [
    Chat(
      id: '1',
      scene: 'Business Meeting',
      participants: ['You', 'Alice', 'Bob'],
      lastMessage: 'Let\'s finalize the project details by next week.',
    ),
    Chat(
      id: '2',
      scene: 'Casual Chat',
      participants: ['You', 'Charlie', 'Eve'],
      lastMessage: 'Are you free this weekend for hiking?',
    ),
    Chat(
      id: '3',
      scene: 'Team Discussion',
      participants: ['You', 'Dave', 'Eve'],
      lastMessage: 'I will send the updated report shortly.',
    ),
  ];

  void _addNewChat(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Adding a new chat...'),
      ),
    );
  }

  void _deleteChat(Chat chat) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete the chat: ${chat.scene}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  chats.remove(chat);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chat deleted successfully.')),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return Dismissible(
            key: Key(chat.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              _deleteChat(chat);
              return false; // Prevent automatic dismissal after swipe
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                title: Text(
                  chat.scene,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.participants.join(', '),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chat.lastMessage,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                onTap: () {
                    final mockMessages = [
                      Message(id:'1', sender: 'You', content: 'Hello, everyone!', timestamp: DateTime.now().subtract(const Duration(hours: 3))),
                      Message(id:'2', sender: chat.participants[1], content: 'Hi! How are you?', timestamp: DateTime.now().subtract(const Duration(hours: 3))),
                      Message(id:'3', sender: chat.participants[2], content: 'Good to see you here.', timestamp: DateTime.now().subtract(const Duration(hours: 3))),
                      Message(id:'4', sender: 'You', content: 'I’m great, thanks for asking.', timestamp: DateTime.now().subtract(const Duration(hours: 3))),
                    ];

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    scene: chat.scene,
                    participants: chat.participants,
                    messages: mockMessages,
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
        onPressed: () => _addNewChat(context),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
