
import 'package:equatable/equatable.dart';

class Scene extends Equatable {
  final int? id;
  final int userId;
  final String name;
  final String description;
  final String mood;
  final String topic;
  final String language;

  const Scene({
    this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.mood,
    required this.topic,
    required this.language,
  });

  /// Creates a new `Scene` instance from a JSON map.
  factory Scene.fromJson(Map<String, dynamic> json) {
    return Scene(
      id: json['id'] as int?,
      userId: json['user_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      mood: json['mood'] as String,
      topic: json['topic'] as String,
      language: json['language'] as String,
    );
  }

  /// Converts the `Scene` instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'mood': mood,
      'topic': topic,
      'language': language,
    };
  }

  /// Creates a copy of the `Scene` with updated fields.
  Scene copyWith({
    int? id,
    int? userId,
    String? name,
    String? description,
    String? mood,
    String? topic,
    String? language,
  }) {
    return Scene(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      mood: mood ?? this.mood,
      topic: topic ?? this.topic,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [id, userId, name, description, mood, topic, language];
}
