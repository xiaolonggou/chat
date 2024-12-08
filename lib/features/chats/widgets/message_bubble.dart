import 'package:chat/features/chatters/chatters_controller.dart';
import 'package:chat/features/chatters/chatters_model.dart';
import 'package:flutter/material.dart';
import 'package:chat/features/chats/message_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    // Access the ChattersController via Provider
    final chattersController = Provider.of<ChattersController>(context);
    
    // Find the sender's name using senderId
    String senderName = message.senderId; // Default to senderId if no name is found
    final sender = chattersController.chatters.firstWhere(
      (chatter) => chatter.id.toString() == message.senderId,
      orElse: () => Chatter(id: -1, name: message.senderId, gender: '', job: '', personality: ''), // Fallback to senderId if no match
    );
    
    if (sender.id != -1) {
      senderName = sender.name; // Update senderName with the actual name if found
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Shrinks to fit content
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isMe
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    // Display the sender's name if the message is not from "You"
                    if (!isMe) ...[
                      Text(
                        senderName,  // Display sender's name here
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4), // Add spacing between sender name and message
                    ],
                    // Timestamp
                    Text(
                      DateFormat('yyyy-MM-dd HH:mm').format(message.timestamp),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                    ),
                    const SizedBox(height: 1),
                    // Message content
                    Text(
                      message.content,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}