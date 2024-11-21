import 'package:flutter/material.dart';

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

class ChatsPage extends StatelessWidget {
  ChatsPage({super.key});

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
      participants: ['You', 'Charlie'],
      lastMessage: 'Are you free this weekend for hiking?',
    ),
    Chat(
      id: '3',
      scene: 'Team Discussion',
      participants: ['You', 'Dave', 'Eve'],
      lastMessage: 'I will send the updated report shortly.',
    ),
    // Add more mock chats as needed
  ];

  void _addNewChat(BuildContext context) {
    // For now, just showing a snackbar indicating a new chat is being added
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Adding a new chat...'),
      ),
    );

    // Add logic for creating a new chat here, e.g., navigate to a new chat creation page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text(
                chat.scene,
                style: Theme.of(context).textTheme.titleMedium, // Updated style here
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.participants.join(', '),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(height: 4),
                  Text(
                    chat.lastMessage,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              
              onTap: () {
                // Handle chat thread click here (not yet defined)
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewChat(context), // Handle adding new chat
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
