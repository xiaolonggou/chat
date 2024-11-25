import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'edit_chatter_page.dart';
import 'chatters_model.dart';
import 'chatters_controller.dart';

class ChattersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Chatters'),
            AddChatterButton(),
          ],
        ),
      ),
      body: Consumer<ChattersController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.error != null) {
            return Center(child: Text('Error: ${controller.error}'));
          } else {
            return ChattersList(chatters: controller.chatters);
          }
        },
      ),
    );
  }
}

class AddChatterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton.small(
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
      elevation: 0,
      child: const Icon(Icons.add),
    );
  }
}

class ChattersList extends StatelessWidget {
  final List<Chatter> chatters;

  const ChattersList({Key? key, required this.chatters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: chatters.length,
      itemBuilder: (context, index) {
        return ChatterListItem(chatter: chatters[index], isEven: index % 2 == 0);
      },
    );
  }
}

class ChatterListItem extends StatelessWidget {
  final Chatter chatter;
  final bool isEven;

  const ChatterListItem({Key? key, required this.chatter, required this.isEven}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ChattersController>(context, listen: false);
    final theme = Theme.of(context);
    final backgroundColor = isEven
        ? theme.colorScheme.inversePrimary.withOpacity(0.1)
        : theme.colorScheme.inversePrimary.withOpacity(0.3);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Dismissible(
        key: Key(chatter.id?.toString() ?? 'chatter-${chatter.name}'),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          if (chatter.id != null) {
            controller.deleteChatter(chatter.id!);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${chatter.name} deleted')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cannot delete chatter with null ID')),
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
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            title: Text(chatter.name),
            trailing: IconButton(
              icon: Icon(Icons.edit, color: theme.colorScheme.primary),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditChatterPage(chatter: chatter),
                  ),
                ).then((_) => controller.fetchChatters());
              },
            ),
          ),
        ),
      ),
    );
  }
}
