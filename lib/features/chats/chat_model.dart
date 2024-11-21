// lib/features/chats/chat_model.dart

class Message {
  final String id;
  final String sender;
  final String content;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
  });
}
