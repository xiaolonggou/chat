import 'package:chat/shared/utils/db_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:chat/features/chats/chat_model.dart';
import 'package:chat/features/chats/local_chatter_model.dart';
import 'package:chat/features/scenes/scene_model.dart';

class ChatController with ChangeNotifier {
  List<Chat> chats = [];


  // Load chats from the database
  Future<void> loadChats() async {
    final db = await DBHelper().database;
    final chatMaps = await db.query('chats');
    final participantMaps = await db.query('chat_participants');

    // Fetching scenes using the userId
    final sceneMaps = await db.query('scenes');

    chats = chatMaps.map((chatMap) {
      final chatId = chatMap['id'] as String;
      final participants = participantMaps
          .where((p) => p['chatId'] == chatId)
          .map((p) => LocalChatter(
                id: p['participantId'] as int,
                name: p['name'] as String,
                gender: p['gender'] as String,
                job: p['job'] as String,
                personality: p['personality'] as String,
                objective: p['objective'] as String?,
                mood: p['mood'] as String?,
              ))
          .toList();

      // Fetching the scene based on the sceneId and userId
      final sceneMap = sceneMaps.firstWhere(
        (scene) => scene['id'] == chatMap['sceneId'],
        orElse: () => {'id': '', 'name': 'Unknown Scene'}, // Default if not found
      );

      return Chat(
        id: chatId,
        subject: chatMap['subject'] as String,
        meetingReason: chatMap['meetingReason'] as String,
        scene: Scene(
          id: sceneMap['id'] as int,
          name: sceneMap['name'] as String,
        ),
        participants: participants,
        messages: [], // Placeholder for messages
      );
    }).toList();

    notifyListeners();
  }
}
