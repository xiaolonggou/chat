import '../../data/mock_chatters_repository.dart';

class ChattersController {
  final MockChattersRepository repository;

  ChattersController({required this.repository});

  Future<List<String>> getChatters() async {
    return await repository.fetchChatters();
  }
}
