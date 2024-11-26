// lib/features/scenes/scene_model.dart

class Scene {
  final String id;
  final String name;
  final String description;
  final String mood;
  final String topic;
  final String language; // New property for language
  final String? userId;  // New property to associate scene with a user

  Scene({
    required this.id,
    required this.name,
    required this.description,
    required this.mood,
    required this.topic,
    required this.language, // Include language in the constructor
    this.userId,   // Include userId in the constructor
  });

  // Factory method to create a Scene from a JSON object
  factory Scene.fromJson(Map<String, dynamic> json) {
    return Scene(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unnamed Scene', // Default value if null
      description: json['description'] as String? ?? 'No description', // Default if null
      mood: json['mood'] as String? ?? 'Neutral',
      topic: json['topic'] as String? ?? 'General', // Default to 'General' if null
      language: json['language'] as String? ?? 'English', // Default to 'English' if null
      userId: json['user_id'] as String, // User ID to associate scene with user
    );
  }

  // Convert Scene object to JSON
  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'mood': mood,
      'topic': topic,
      'language': language,
      'user_id': userId, // Include user ID in JSON
    };
  }
}
