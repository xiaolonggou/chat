// lib/data/api_chatters_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../features/chatters/chatters_model.dart';
import '../features/chatters/chatters_repository.dart';
import '../shared/utils/token_storage.dart'; // Import TokenStorage to retrieve JWT

class ApiChattersRepository implements ChattersRepository {
  final String baseUrl;

  ApiChattersRepository({required this.baseUrl});

  Future<Map<String, String>> _getHeaders() async {
    final token = await TokenStorage.retrieveToken();
    if (token == null) {
      throw Exception('Authentication token not found');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<Chatter>> fetchChatters() async {
    final headers = await _getHeaders(); // Include authentication headers
    final response = await http.get(Uri.parse('$baseUrl/chatters'), headers: headers);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((chatter) => Chatter.fromJson(chatter)).toList();
    } else {
      throw Exception('Failed to fetch chatters');
    }
  }

  @override
  Future<void> saveChatter(Chatter chatter) async {
    final headers = await _getHeaders(); // Include authentication headers
    final Uri url = chatter.id != null
        ? Uri.parse('$baseUrl/chatters/${chatter.id}') // For existing chatter
        : Uri.parse('$baseUrl/chatters'); // For new chatter (POST)

    final response = await (chatter.id != null
        ? http.put(
            url,
            headers: headers,
            body: jsonEncode(chatter.toJson()),
          )
        : http.post(
            url,
            headers: headers,
            body: jsonEncode(chatter.toJson()..remove('id')),
          ));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to save chatter');
    }
  }

  @override
  Future<void> deleteChatter(int id) async {
    final headers = await _getHeaders(); // Include authentication headers
    final response = await http.delete(Uri.parse('$baseUrl/chatters/$id'), headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete chatter');
    }
  }
}
