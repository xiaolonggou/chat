// lib/data/api_chatters_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../features/chatters/chatters_model.dart';
import '../features/chatters/chatters_repository.dart';

class ApiChattersRepository implements ChattersRepository {
  final String baseUrl;

  ApiChattersRepository({required this.baseUrl});

  @override
  Future<List<Chatter>> fetchChatters() async {
    final response = await http.get(Uri.parse('$baseUrl/chatters'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((chatter) => Chatter.fromJson(chatter)).toList();
    } else {
      throw Exception('Failed to fetch chatters');
    }
  }

@override
Future<void> saveChatter(Chatter chatter) async {
  final Uri url = chatter.id != null
      ? Uri.parse('$baseUrl/chatters/${chatter.id}') // For existing chatter
      : Uri.parse('$baseUrl/chatters'); // For new chatter (POST)

  final response = await (chatter.id != null
      ? http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(chatter.toJson()),
        )
      : http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(chatter.toJson()..remove('id')),
        ));

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception('Failed to save chatter');
  }
}


  @override
  Future<void> deleteChatter(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/chatters/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete chatter');
    }
  }
}
