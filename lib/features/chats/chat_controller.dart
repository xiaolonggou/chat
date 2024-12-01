import 'package:flutter/material.dart';
import 'package:chat/features/chats/local_chatter_model.dart';
import 'package:chat/features/scenes/scene_model.dart';

class ChatController extends ChangeNotifier {
  List<LocalChatter> _chatters = [];
  Scene? _scene;

  List<LocalChatter> get chatters => _chatters;
  Scene? get scene => _scene;

  void setScene(Scene scene) {
    _scene = scene;
    notifyListeners();
  }

  void addChatter(LocalChatter chatter) {
    _chatters.add(chatter);
    notifyListeners();
  }

  void updateChatter(int index, LocalChatter chatter) {
    _chatters[index] = chatter;
    notifyListeners();
  }

  void removeChatter(int index) {
    _chatters.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _chatters = [];
    _scene = null;
    notifyListeners();
  }
}
