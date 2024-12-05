// lib/features/chats/message_model.dart

import 'dart:convert'; // For JSON encoding and decoding

class Message {
  final String id; // Unique ID for the message
  final String chatId; // The chat to which this message belongs
  final String sender; // The sender of the message
  final String content; // The content of the message
  final DateTime timestamp; // The timestamp of the message

  // Constructor to initialize the message details
  const Message({
    required this.id,
    required this.chatId,
    required this.sender,
    required this.content,
    required this.timestamp,
  });

  // Method to convert a Message instance to a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatId': chatId, // Store the chatId to link the message to the correct chat
      'sender': sender,
      'content': content,
      'timestamp': timestamp.toIso8601String(), // Convert timestamp to a string format
    };
  }

  // Factory constructor to create a Message from a Map (e.g., retrieved from database)
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      chatId: map['chatId'], // Fetch the associated chatId from the map
      sender: map['sender'],
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']), // Parse timestamp back to DateTime
    );
  }

  // Convert a Message instance to JSON (String)
  String toJson() {
    final map = toMap(); // Convert to map first
    return json.encode(map); // Convert map to JSON string
  }

  // Create a Message instance from a JSON string
  factory Message.fromJson(String jsonStr) {
    final map = json.decode(jsonStr); // Decode JSON string to Map
    return Message.fromMap(map); // Create Message from map
  }
}
