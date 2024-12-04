import 'package:chat/shared/utils/db_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:chat/features/chats/chat_model.dart';
import 'package:chat/features/chats/local_chatter_model.dart';
import 'package:chat/features/scenes/scene_model.dart';
import 'package:chat/features/scenes/scenes_controller.dart';
import 'package:chat/features/chatters/chatters_controller.dart';

class ChatController with ChangeNotifier {
  final ScenesController scenesController;
  final ChattersController chattersController;
  List<Chat> chats = [];

  // Constructor now also requires the ChattersController
  ChatController({
    required this.scenesController,
    required this.chattersController,
  });

  // Load chats from the database and fetch scenes and chatters via API
  Future<void> loadChats() async {
    final db = await DBHelper().database;
    final chatMaps = await db.query('chats');
    final participantMaps = await db.query('chat_participants');

    // Fetch scenes via the ScenesController
    await scenesController.fetchScenes();
    final scenes = scenesController.scenes;

    // Fetch chatters data via the ChattersController (this may be asynchronous)
    await chattersController.fetchChatters();
    final chatters = chattersController.chatters;

    chats = chatMaps.map((chatMap) {
      final chatId = chatMap['id'] as String;
      
      // Debugging: Print the chatId to check the value
      print('Processing chatId: $chatId');
      
      // Check if participantMaps contains any items
      if (participantMaps.isEmpty) {
        print('No participants found.');
      }
      
      // Fetch participants using the participantMaps and chattersController
      final participants = participantMaps
          .where((p) => p['chatId'] == chatId)
          .map((p) {
        // Fetch the chatter data for the participant
        final participantId = p['participantId'] as int;

        // Find the participant's chatter data from the fetched chatters
        final chatter = chatters.firstWhere(
          (chatter) => chatter.id == participantId,
          orElse: () => LocalChatter(
            id: participantId,
            name: 'Unknown',
            gender: 'Unknown',
            job: 'Unknown',
            personality: 'Unknown',
            objective: p['objective'] as String?,
            mood: p['mood'] as String?,
          ),
        );

        // Debugging: Print the participant's chatter data
        print('Processing participant: ${chatter.name}');
        
        return LocalChatter(
          id: participantId,
          name: chatter.name,
          gender: chatter.gender,
          job: chatter.job,
          personality: chatter.personality,
          objective: p['objective'] as String?,
          mood: p['mood'] as String?,
        );
      }).toList();
      
      // Debugging: Print the list of participants found for this chat
      print('Found ${participants.length} participants for chatId $chatId');
      
      // Fetch the scene dynamically based on sceneId (if not already present in chatMap)
      final sceneId = chatMap['sceneId'] as int;
      final scene = scenes.firstWhere(
        (scene) => scene.id == sceneId,
        orElse: () => Scene(id: sceneId, name: 'Unknown Scene'),
      );

      return Chat(
        id: chatId,
        subject: chatMap['subject'] as String,
        meetingReason: chatMap['meetingReason'] as String,
        scene: scene, // Use the dynamically fetched scene
        participants: participants,
        messages: [], // Placeholder for messages
      );
    }).toList();

    // Notify listeners when the chats are updated
    notifyListeners();
  }

Future<void> deleteChat(String chatId) async {
  final db = await DBHelper().database;

  // Delete all messages related to the chat
  await db.delete(
    'messages', // Adjust table name if it's different in your database
    where: 'chatId = ?',
    whereArgs: [chatId],
  );

  // Delete participants associated with the chat
  await db.delete(
    'chat_participants',
    where: 'chatId = ?',
    whereArgs: [chatId],
  );

  // Delete the chat itself
  await db.delete(
    'chats',
    where: 'id = ?',
    whereArgs: [chatId],
  );

  // Remove the chat from the local list
  chats.removeWhere((chat) => chat.id == chatId);

  notifyListeners(); // Notify listeners to refresh the UI
}

}
