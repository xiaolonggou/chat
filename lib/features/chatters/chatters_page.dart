import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'edit_chatter_page.dart';
import 'chatters_model.dart';
import 'chatters_controller.dart';

class ChattersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access theme for consistent colors

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Chatters'),
            FloatingActionButton.small(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditChatterPage(
                      chatter: Chatter(
                        id: null,
                        name: '',
                        gender: 'Unknown',
                        yearOfBirth: 2000,
                        job: 'Unknown',
                        personality: 'Neutral',
                      ),
                    ),
                  ),
                ).then((_) => Provider.of<ChattersController>(context, listen: false).fetchChatters());
              },
              backgroundColor: theme.colorScheme.inversePrimary,
              child: const Icon(Icons.add),
              elevation: 0, // Keep flat for app bar style consistency
            ),
          ],
        ),
      ),
      body: Consumer<ChattersController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.error != null) {
            return Center(child: Text('Error: ${controller.error}'));
          } else {
            final chatters = controller.chatters;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0), // Add padding around the list
              itemCount: chatters.length,
              itemBuilder: (context, index) {
                // Alternate background color using theme
                final backgroundColor = index % 2 == 0
                    ? theme.colorScheme.inversePrimary.withOpacity(0.1) // Light surface color
                    : theme.colorScheme.primary.withOpacity(0.1); // Slightly darker surface color

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0), // Spacing between items
                  child: Dismissible(
                    key: Key(chatters[index].id?.toString() ?? 'chatter-$index'),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      final id = chatters[index].id;
                      if (id != null) {
                        controller.deleteChatter(id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${chatters[index].name} deleted')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Cannot delete chatter with null ID')),
                        );
                      }
                    },
                    background: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0), // Padding inside ListTile
                        title: Text(chatters[index].name),
                        trailing: IconButton(
                          icon: Icon(Icons.edit, color: theme.colorScheme.primary),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditChatterPage(chatter: chatters[index]),
                              ),
                            ).then((_) => controller.fetchChatters());
                          },
                        ),
                      ),
                    ),
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
