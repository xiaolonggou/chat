import 'package:flutter/material.dart';
import 'package:chat/features/chats/message_model.dart';

class ChatPage extends StatelessWidget {
  final String scene;
  final List<String> participants;
  final List<Message> messages;

  ChatPage({
    super.key,
    required this.scene,
    required this.participants,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat: $scene'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              reverse: true, // Newest message at the bottom
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message.sender == 'You';

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        // Timestamp
                        Row(
                          mainAxisAlignment:
                              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            Text(
                              message.timestamp as String, // Assuming message has a timestamp field
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 1),
                        // Message content
                        Text(
                          message.content,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30), // Adjust vertical padding
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end, // Ensure alignment to the bottom
              children: [
                const SizedBox(width: 10), // Space between avatar and input box
                // Input text field with flexible height and multiline support
                Expanded(
                  child: TextField(
                    minLines: 1,
                    maxLines: 5, // Limit to 5 lines, adjust as needed
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.primaryContainer,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    ),
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline, // Allows multiline input with the return key
                  ),
                ),
                const SizedBox(width: 10), // Space between input and button
                // Send button aligned to bottom
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        // Handle message sending
                      },
                    ),
                  ],
                ),
              ],
            ),

          ),
        ],
      ),
    );
  }
}
