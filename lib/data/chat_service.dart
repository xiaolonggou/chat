import 'dart:convert';
import 'package:chat/features/chats/chat_model.dart';
import 'package:chat/features/chats/message_model.dart';
import 'package:chat/shared/utils/db_helper.dart';
import 'package:http/http.dart' as http;

class ChatService {
  // The static private instance of the ChatService
  static final ChatService _instance = ChatService._internal();

  // The server URL that will be used to send messages
  String serverUrl;

  // Private constructor for Singleton pattern
  ChatService._internal({this.serverUrl = 'http://localhost:3000'}); // You can provide a default URL

  // Factory constructor to return the single instance
  factory ChatService({String? serverUrl}) {
    if (serverUrl != null) {
      _instance.serverUrl = serverUrl; // Update the server URL if provided
    }
    return _instance;
  }
  Future<String?> sendMessage(Chat chat) async {
    try {
      final uri = Uri.parse('$serverUrl/api/message');

      // Serialize the Chat object to JSON
      final chatJson = chat.toJsonString();

      // Send the JSON payload to the backend
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: chatJson,
      ).timeout(
        Duration(seconds: 60),
        onTimeout: () => http.Response('Timeout', 408),
      );

      if (response.statusCode == 200) {
        // Parse and return the server's reply
        final responseBody = json.decode(response.body);
        await storeResponse(responseBody);
        return responseBody.toString();
      } else {
        print('Error: Backend returned status code ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error sending message: $e');
      return null;
    }
  }

 Future<void> storeResponse(Map<String, dynamic> responseBody) async {
  try {
    // Extract the chat ID and messages from the response
    final chatId = responseBody['chatId'];
    final messages = responseBody['messages'];

    // Sort messages by sequence_id to ensure the correct order
    messages.sort((a, b) {
      final aSeqId = a['sequence_id'] ?? 0;  // Default to 0 if sequence_id is null
      final bSeqId = b['sequence_id'] ?? 0;  // Default to 0 if sequence_id is null

      // Return an integer to indicate order
      if (aSeqId < bSeqId) {
        return -1;  // a comes before b
      } else if (aSeqId > bSeqId) {
        return 1;   // b comes before a
      } else {
        return 0;   // They are equal
      }
    });

    // Loop through the sorted messages and insert them into the local database
    for (var messageData in messages) {
      final message = Message(
        id: messageData['backend_id'],  // Assuming backend_id is used as the local message ID
        chatId: chatId,
        senderId: messageData['sender_participant_id'].toString(),
        content: messageData['content'],
        timestamp: DateTime.now(),
      );

      // Insert the message into the local database
      await DBHelper().insertMessage(message);
    }

    print('Messages from backend successfully stored locally in sequence.');
  } catch (e) {
    print('Error storing backend response: $e');
    rethrow;
  }
}

}