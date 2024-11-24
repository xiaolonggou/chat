// lib/features/chatters/chatters_controller.dart

import 'package:flutter/material.dart';
import 'chatters_model.dart';
import 'chatters_repository.dart';

class ChattersController extends ChangeNotifier {
  final ChattersRepository repository;

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
      await repository.saveChatter(chatter);
      await fetchChatters(); // Refresh the chatters list after saving
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteChatter(int id) async {
    isLoading = true;
    notifyListeners();

    try {
      await repository.deleteChatter(id);
      await fetchChatters(); // Refresh the chatters list after deletion
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
