import 'package:chat/features/chats/chat_controller.dart';
import 'package:chat/shared/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:chat/features/chats/message_model.dart';
import 'package:chat/features/chats/widgets/message_bubble.dart';
import 'package:chat/features/chats/widgets/chat_input_field.dart';

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
  // Instance of ChatController to manage sending messages
  late final ChatController chatController;
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

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();

    if (messageText.isEmpty) return;

    final timestamp = DateTime.now();

    try {
      await DBHelper().insertMessage('You', widget.chatId, messageText, timestamp);
      //await chatController.sendMessage('hi backend.');
      _messageController.clear();
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
