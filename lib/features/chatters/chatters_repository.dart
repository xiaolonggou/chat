// lib/features/chatters/chatters_repository.dart

import 'chatters_model.dart';

abstract class ChattersRepository {
  Future<List<Chatter>> fetchChatters();
  Future<void> saveChatter(Chatter chatter);
  Future<void> deleteChatter(int id);
}
