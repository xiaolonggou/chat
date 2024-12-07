import 'package:flutter/material.dart';
import 'package:chat/features/chats/chat_model.dart';
import 'package:chat/features/chats/message_model.dart';
import 'package:chat/features/chats/widgets/message_bubble.dart';
import 'package:chat/features/chats/widgets/chat_input_field.dart';
import 'package:chat/shared/utils/db_helper.dart';
import 'package:chat/features/chats/chats_controller.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;
  final ChatsController chatsController;

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

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  // Load messages for the current chat from the database
  Future<void> _loadMessages() async {
    try {
      final dbMessages = await DBHelper().fetchMessages(widget.chat.id);
      setState(() {
        widget.chat.messages = dbMessages;
      });
    } catch (e) {
      print('Error loading messages: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load messages.')),
      );
    }
  }

  // Send a new message
  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();

    if (messageText.isEmpty) return;

    final timestamp = DateTime.now();
    final newMessage = Message(
      id: '', // Placeholder ID
      chatId: widget.chat.id,
      sender: 'You',
      content: messageText,
      timestamp: timestamp,
    );

    try {
      // Add the message locally
      setState(() {
        widget.chat.messages.insert(0,newMessage);
      });

      // Insert the message into the database
      final messageId = await DBHelper().insertMessage(newMessage);
      // Update the message with the generated ID
      final updatedMessage = newMessage.copyWith(id: messageId.toString());
      setState(() {
        final index = widget.chat.messages.indexOf(newMessage);
        if (index != -1) widget.chat.messages[index] = updatedMessage;
      });

      // Optionally, sync with the server
      await widget.chatsController.sendMessage(widget.chat);

      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send message.')),
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
          // Message List
          Expanded(
            child: ListView.builder(
              itemCount: widget.chat.messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                final message = widget.chat.messages[index];
                final isMe = message.sender == 'You';
                return MessageBubble(
                  message: message,
                  isMe: isMe,
                );
              },
            ),
          ),
          // Input Field
          ChatInputField(
            controller: _messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}
