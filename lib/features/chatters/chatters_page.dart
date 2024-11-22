import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_chatter_page.dart';
import 'chatters_model.dart';
import 'chatters_controller.dart';
import '../../data/mock_chatters_repository.dart';

class ChattersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChattersController(repository: MockChattersRepository()),
      child: Scaffold(
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
            // Instead of passing null, pass a new Chatter object with default values
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditChatterPage(chatter: Chatter(
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
      ),
    );
  }
}
