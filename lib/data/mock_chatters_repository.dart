// lib/data/mock_chatters_repository.dart

import '../features/chatters/chatters_model.dart';
import '../features/chatters/chatters_repository.dart';

class MockChattersRepository implements ChattersRepository {
  final List<Chatter> _chatters = [
    Chatter(
      id: 1,
      name: 'Alice',
      gender: 'Female',
      yearOfBirth: 1990,
      job: 'Engineer',
      personality: 'Analytical',
    ),
    Chatter(
      id: 2,
      name: 'Bob',
      gender: 'Male',
      yearOfBirth: 1985,
      job: 'Designer',
      personality: 'Creative',
    ),
  ];

  @override
  Future<List<Chatter>> fetchChatters() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return _chatters;
  }

  @override
  Future<void> saveChatter(Chatter chatter) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    final index = _chatters.indexWhere((c) => c.id == chatter.id);
    if (index != -1) {
      _chatters[index] = chatter; // Update existing chatter
    } else {
      _chatters.add(chatter); // Add new chatter
    }
  }

  @override
  Future<void> deleteChatter(int id) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    _chatters.removeWhere((c) => c.id == id);
  }
}
