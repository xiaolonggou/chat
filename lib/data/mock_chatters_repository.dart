import 'dart:async';
import '../features/chatters/chatters_model.dart';

class MockChattersRepository {
  final List<Chatter> _mockChatters = [
    Chatter(name: 'Alice', gender: 'Female', yearOfBirth: 1990, job: 'Engineer', personality: 'Friendly'),
    Chatter(name: 'Bob', gender: 'Male', yearOfBirth: 1985, job: 'Doctor', personality: 'Calm'),
  ];

  Future<List<Chatter>> fetchChatters() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return List.from(_mockChatters);
  }

  Future<void> saveChatter(Chatter chatter) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    final index = _mockChatters.indexWhere((c) => c.name == chatter.name);
    if (index >= 0) {
      _mockChatters[index] = chatter;
    } else {
      _mockChatters.add(chatter);
    }
  }
}
