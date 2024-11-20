// lib/features/scenes/scene_model.dart

class Scene {
  final String id;
  final String name;
  final String description;
  final String mood;
  final String topic; // <-- Keep the 'topic' property

  Scene({
    required this.id,
    required this.name,
    required this.description,
    required this.mood,
    required this.topic, // <-- Include topic in the constructor
  });
}
