import 'package:chat/shared/utils/db_helper.dart';
import 'package:flutter/material.dart';
// Import Chat model to reload chat data

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final String chatId; // Chat ID to delete messages from this chat
  final Function refreshChatPage; // Callback to refresh chat page

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    required this.chatId, // Pass chatId to the widget
    required this.refreshChatPage, // Pass the refresh callback to refresh chat page
  });

  // Delete all messages and ask for confirmation
  Future<void> _deleteAllMessages(BuildContext context) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete All Messages'),
          content: const Text(
              'Are you sure you want to delete all messages in this chat?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirm
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      // Call the method to delete messages from the database
      try {
        await DBHelper().deleteMessages(chatId);
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All messages have been deleted.')),
        );
        // Refresh the chat page by calling the callback function
        refreshChatPage(); // Trigger the page refresh after deletion
      } catch (e) {
        print('Error deleting messages: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete messages.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 35),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Leftmost delete button
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteAllMessages(context),
          ),
          // Message input field
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.primaryContainer,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
            ),
          ),
          const SizedBox(width: 10),
          // Send button
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
