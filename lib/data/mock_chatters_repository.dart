import 'dart:async';
import '../features/chatters/chatters_model.dart';

class MockChattersRepository {
  final List<Chatter> _mockChatters = [
    Chatter(id:'1', name: 'Alice', gender: 'Female', yearOfBirth: 1990, job: 'Engineer', personality: 'Friendly'),
    Chatter(id:'2', name: 'Bob', gender: 'Male', yearOfBirth: 1985, job: 'Doctor', personality: 'Calm'),
  ];

  Future<List<Chatter>> fetchChatters() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return List.from(_mockChatters);
  }

  Future<void> saveChatter(Chatter chatter) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    final index = _mockChatters.indexWhere((c) => c.id == chatter.id);
    if (index >= 0) {
      _mockChatters[index] = chatter; // Update the existing chatter
    } else {
      _mockChatters.add(chatter); // Add new chatter
    }
  }
}
