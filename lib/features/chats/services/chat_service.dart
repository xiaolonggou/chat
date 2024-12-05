import 'dart:convert';
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

  // Sends a message to the backend and returns the reply or null in case of failure
  Future<String?> sendMessage(String message) async {
    try {
      final uri = Uri.parse('$serverUrl/api/sendMessage'); // Use the server URL and API endpoint

      // Send the request to the backend
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message}), // Send the message as JSON
      ).timeout(
        Duration(seconds: 5), // Timeout after 5 seconds
        onTimeout: () {
          // If the request takes too long, return a timeout response
          return http.Response('Timeout', 408); // 408 is the HTTP status code for Timeout
        },
      );

      // Check the response status code
      if (response.statusCode == 200) {
        // If the status code is 200 (OK), parse the response body
        final responseBody = json.decode(response.body);
        return responseBody['reply']; // Extract the reply from the response (assuming 'reply' is part of the response)
      } else {
        // If the status code is not 200, log the error and return null
        print('Error: Backend returned status code ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Handle errors (network issues, etc.)
      print('Error sending message: $e');
      return null;
    }
  }
}
