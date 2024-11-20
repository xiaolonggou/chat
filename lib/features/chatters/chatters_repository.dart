import 'dart:convert';
import 'package:http/http.dart' as http;

class ChattersRepository {
  Future<List<String>> fetchChatters() async {
    final response = await http.get(Uri.parse('https://example.com/chatters'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((chatter) => chatter['name'] as String).toList();
    } else {
      throw Exception('Failed to load chatters');
    }
  }
}
