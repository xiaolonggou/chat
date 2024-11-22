import 'package:flutter/material.dart';
import '../../data/mock_chatters_repository.dart';
import 'chatters_model.dart';

class ChattersController extends ChangeNotifier {
  final MockChattersRepository repository;

  ChattersController({required this.repository}) {
    fetchChatters();
  }

  bool isLoading = false;
  String? error;
  List<Chatter> chatters = [];

  Future<void> fetchChatters() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      chatters = await repository.fetchChatters();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addOrUpdateChatter(Chatter chatter) async {
    isLoading = true;
    notifyListeners();

    try {
      await repository.saveChatter(chatter); // Update or add chatter in the repository
      await fetchChatters(); // Refresh the chatters list after saving
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
