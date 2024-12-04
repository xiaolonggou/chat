import 'package:chat/shared/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:chat/features/chats/message_model.dart';

class ChatPage extends StatefulWidget {
  final String scene;
  final String chatId;
  final List<String> participants;

  const ChatPage({
    super.key,
    required this.chatId,
    required this.scene,
    required this.participants,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages(); // Load messages when the page initializes
  }

  Future<void> _loadMessages() async {
    try {
      final dbMessages = await DBHelper().fetchMessages(widget.chatId);
      setState(() {
        messages = dbMessages;
      });
    } catch (e) {
      print('Error loading messages: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load messages.')),
      );
    }
  }

  void _sendMessage() async {
    final messageText = _messageController.text.trim();

    if (messageText.isEmpty) return;

    final timestamp = DateTime.now();

    try {
      // Insert the message into the database
      await DBHelper().insertMessage(widget.chatId, messageText, timestamp);

      // Clear the input field
      _messageController.clear();

      // Reload messages from the database
      _loadMessages();
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat: ${widget.scene}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              reverse: false, // Messages should be loaded in correct order
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message.sender == 'You'; // Adjust based on sender field

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
                              message.timestamp.toString(), // Display timestamp
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15), // Adjust vertical padding
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end, // Ensure alignment to the bottom
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    ),
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
