import 'package:flutter/material.dart';
import 'package:chat/shared/utils/db_helper.dart';
import 'package:chat/features/chats/message_model.dart';
import 'package:chat/features/chats/widgets/message_bubble.dart';
import 'package:chat/features/chats/widgets/chat_input_field.dart';
import 'package:chat/features/chats/chat_controller.dart'; // Ensure this import is correct

class ChatPage extends StatefulWidget {
  final String scene;
  final String chatId;
  final List<String> participants;
  final ChatController chatController; // Pass chatController here

  const ChatPage({
    super.key,
    required this.chatId,
    required this.scene,
    required this.participants,
    required this.chatController, // Ensure it's passed here
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

  // Load messages from the database
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

  // Send the message to the database and call chatController
  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();

    if (messageText.isEmpty) return;

    final timestamp = DateTime.now();

    try {
      // Insert the message into the local database
      await DBHelper().insertMessage('You', widget.chatId, messageText, timestamp);
      
      // Call sendMessage method from chatController
      await widget.chatController.sendMessage(messageText);
      
      _messageController.clear();
      _loadMessages(); // Reload messages after sending a new one
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
          // Message list
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              reverse: true, // Messages loaded in the correct order
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message.sender == 'You'; // Adjust based on sender

                return MessageBubble(
                  message: message,
                  isMe: isMe,
                );
              },
            ),
          ),
          // Input field
          ChatInputField(
            controller: _messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}
