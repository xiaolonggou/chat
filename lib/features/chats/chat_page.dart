import 'package:chat/features/chats/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:chat/shared/utils/db_helper.dart';
import 'package:chat/features/chats/message_model.dart';
import 'package:chat/features/chats/widgets/message_bubble.dart';
import 'package:chat/features/chats/widgets/chat_input_field.dart';
import 'package:chat/features/chats/chats_controller.dart'; // Ensure this import is correct

class ChatPage extends StatefulWidget {
  final Chat chat; // Pass the entire Chat object
  final ChatsController chatsController; // Pass ChatController

  const ChatPage({
    super.key,
    required this.chat,
    required this.chatsController,
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
      final dbMessages = await DBHelper().fetchMessages(widget.chat.id);
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

Future<void> _sendMessage() async {
  final messageText = _messageController.text.trim();

  if (messageText.isEmpty) return;

  final timestamp = DateTime.now();
  final newMessage = Message(
    id: UniqueKey().toString(), // Generate a unique ID for the message
    chatId: widget.chat.id,
    sender: 'You', // Assume the current user is the sender
    content: messageText,
    timestamp: timestamp,
  );

  try {
    // Add the message to the Chat object
    setState(() {
      widget.chat.messages.add(newMessage);
    });

    // Insert the message into the local database
    await DBHelper().insertMessage(newMessage);

    // Send the updated Chat object to the server
    await widget.chatsController.sendMessage(widget.chat);

    _messageController.clear(); // Clear the input field
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
        title: Text('Chat: ${widget.chat.subject}'),
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
