import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'edit_chatter_page.dart';
import 'chatters_model.dart';
import 'chatters_controller.dart';

class ChattersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chatters')),
      body: Consumer<ChattersController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.error != null) {
            return Center(child: Text('Error: ${controller.error}'));
          } else {
            final chatters = controller.chatters;
            return ListView.builder(
              itemCount: chatters.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(chatters[index].name),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditChatterPage(chatter: chatters[index]),
                        ),
                      ).then((_) => controller.fetchChatters());
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Pass a new, empty Chatter object to the EditChatterPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditChatterPage(chatter: Chatter(
                id: 0,
                name: '', // Empty name for new chatter
                gender: 'Unknown',
                yearOfBirth: 2000,
                job: 'Unknown',
                personality: 'Neutral',
              )),
            ),
          ).then((_) => Provider.of<ChattersController>(context, listen: false).fetchChatters());
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}
