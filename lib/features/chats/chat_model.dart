import 'package:chat/features/chats/local_chatter_model.dart';
import 'package:chat/features/chats/message_model.dart';
import 'package:chat/features/scenes/scene_model.dart';


class Chat {
  final String subject;
  final String meetingReason;
  final String id;
  final Scene scene;
  final List<LocalChatter> participants; // List of LocalChatter for local metadata
  final List<Message> messages;

  Chat({
    required this.subject,
    required this.meetingReason,
    required this.id,
    required this.scene, // Use Scene object for chat scene
    required this.participants, // List of LocalChatter objects
    required this.messages,
  });

  // Method to add a new message to the chat
  void addMessage(Message message) {
    messages.add(message);
  }

  // Method to add a participant to the chat
  void addParticipant(LocalChatter chatter) {
    participants.add(chatter);
  }

  // Method to remove a participant from the chat
  void removeParticipant(LocalChatter chatter) {
    participants.remove(chatter);
  }

  // Method to update the metadata (objective, mood) of a participant
  void updateParticipantMetadata(LocalChatter chatter, String? objective, String? mood) {
    int index = participants.indexWhere((p) => p.id == chatter.id);
    if (index != -1) {
      participants[index] = participants[index].copyWith(objective: objective, mood: mood);
    }
  }
}