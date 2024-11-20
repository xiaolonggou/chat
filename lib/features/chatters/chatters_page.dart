import 'package:flutter/material.dart';
import 'edit_chatter_page.dart';
import 'chatters_model.dart';
import 'chatters_controller.dart';
import '../../data/mock_chatters_repository.dart';

class ChattersPage extends StatelessWidget {
  final controller = ChattersController(repository: MockChattersRepository());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chatters')),
      body: FutureBuilder(
        future: controller.getChatters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final chatters = snapshot.data as List<String>;
            return ListView.builder(
              itemCount: chatters.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(chatters[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                    onPressed: () {
                      // Navigate to the EditChatterPage with mock data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditChatterPage(
                            chatter: Chatter(
                              name: chatters[index], // Replace with actual chatter data
                              gender: 'Unknown',
                              yearOfBirth: 1990,
                              job: 'Unknown',
                              personality: 'Neutral',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
