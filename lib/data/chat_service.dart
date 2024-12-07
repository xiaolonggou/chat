import 'dart:convert';
import 'package:chat/features/chats/chat_model.dart';
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
      Duration(seconds: 5),
      onTimeout: () => http.Response('Timeout', 408),
    );

    if (response.statusCode == 200) {
      // Parse and return the server's reply
      final responseBody = json.decode(response.body);
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

}