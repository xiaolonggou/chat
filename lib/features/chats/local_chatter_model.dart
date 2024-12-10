// lib/features/chatters/local_chatter_model.dart
import 'package:chat/features/chatters/chatters_model.dart';

class LocalChatter extends Chatter {
  String? objective;
  String? mood;

  // Constructor to initialize LocalChatter, passing parameters to the Chatter constructor
  LocalChatter({
    int? id,
    required String name,
    required String gender,
    int? yearOfBirth,
    required String job,
    required String personality,
    this.objective,
    this.mood,
  }) : super(
          id: id,
          name: name,
          gender: gender,
          yearOfBirth: yearOfBirth,
          job: job,
          personality: personality,
        );

  // Override the toString() method to include the properties of both Chatter and LocalChatter
  @override
  String toString() {
    return 'LocalChatter(id: $id, name: $name, gender: $gender, yearOfBirth: $yearOfBirth, job: $job, personality: $personality, objective: $objective, mood: $mood)';
  }

  // Factory method to create a LocalChatter from a JSON object
  factory LocalChatter.fromJson(Map<String, dynamic> json) {
    return LocalChatter(
      id: json['id'] as int?,
      name: json['name'] as String? ?? 'Unknown',
      gender: json['gender'] as String? ?? 'Unknown',
      yearOfBirth: json['year_of_birth'] as int?,
      job: json['job'] as String? ?? 'Unemployed',
      personality: json['personality'] as String? ?? 'Neutral',
      objective: json['objective'] as String?,
      mood: json['mood'] as String?,
    );
  }

  // Convert LocalChatter object to JSON
  @override
  Map<String, Object?> toJson() {
    final json = super.toJson(); // Get the base Chatter properties
    // Add LocalChatter specific properties
    json['objective'] = objective;
    json['mood'] = mood;
    return json;
  }

  // copyWith method allows you to create a modified copy of the current object
  LocalChatter copyWith({
    int? id,
    String? name,
    String? gender,
    int? yearOfBirth,
    String? job,
    String? personality,
    String? objective,
    String? mood,
  }) {
    return LocalChatter(
      id: id ?? this.id, // If not provided, use the current value
      name: name ?? this.name,
      gender: gender ?? this.gender,
      yearOfBirth: yearOfBirth ?? this.yearOfBirth,
      job: job ?? this.job,
      personality: personality ?? this.personality,
      objective: objective ?? this.objective,
      mood: mood ?? this.mood,
    );
  }

  static LocalChatter fromChatter(Chatter chatter) {
  return LocalChatter(
    id: chatter.id,
    name: chatter.name,
    gender: chatter.gender,
    yearOfBirth: chatter.yearOfBirth,
    job: chatter.job,
    personality: chatter.personality,
    objective: null, // Default value or modify as needed
    mood: null,      // Default value or modify as needed
  );
}
}
