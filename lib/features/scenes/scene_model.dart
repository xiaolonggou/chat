import 'package:equatable/equatable.dart';

class Scene extends Equatable {
  final int? id; // id is nullable, assigned by the backend after creation
  final int userId; // userId is non-nullable
  final String? name; // name can be nullable
  final String? description; // description can be nullable
  final String? mood; // mood can be nullable
  final String? topic; // topic can be nullable
  final String? language; // language can be nullable

  const Scene({
    this.id, // id can be nullable, assigned by backend
    required this.userId, // userId is required
    this.name, // name is optional
    this.description, // description is optional
    this.mood, // mood is optional
    this.topic, // topic is optional
    this.language, // language is optional
  });

  /// Creates a new `Scene` instance from a JSON map.
  factory Scene.fromJson(Map<String, dynamic> json) {
    return Scene(
      id: json['id'] as int?, // id can be nullable, assigned by the backend
      userId: json['user_id'] as int, // userId is required
      name: json['name'] as String?, // name can be nullable
      description: json['description'] as String?, // description can be nullable
      mood: json['mood'] as String?, // mood can be nullable
      topic: json['topic'] as String?, // topic can be nullable
      language: json['language'] as String?, // language can be nullable
    );
  }

  /// Converts the `Scene` instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id, // id can be nullable
      'user_id': userId, // userId is required
      'name': name, // name can be nullable
      'description': description, // description can be nullable
      'mood': mood, // mood can be nullable
      'topic': topic, // topic can be nullable
      'language': language, // language can be nullable
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
      id: id ?? this.id, // id can be nullable, assigned by backend
      userId: userId ?? this.userId, // userId is required
      name: name ?? this.name, // name can be nullable
      description: description ?? this.description, // description can be nullable
      mood: mood ?? this.mood, // mood can be nullable
      topic: topic ?? this.topic, // topic can be nullable
      language: language ?? this.language, // language can be nullable
    );
  }

  @override
  List<Object?> get props => [id, userId, name, description, mood, topic, language];
}
