// lib/features/chatters/chatters_model.dart
class Chatter {
  final int? id;
  final String name;
  final String gender;
  final int yearOfBirth;
  final String job;
  final String personality;

  Chatter({
    this.id,
    required this.name,
    required this.gender,
    required this.yearOfBirth,
    required this.job,
    required this.personality,
  });

  // Factory method to create a Chatter from a JSON object
  factory Chatter.fromJson(Map<String, dynamic> json) {
    return Chatter(
      id: json['id'] as int?, // Nullable id
      name: json['name'] as String? ?? 'Unknown', // Default to 'Unknown' if null
      gender: json['gender'] as String? ?? 'Unknown', // Default to 'Unknown' if null
      yearOfBirth: json['yearOfBirth'] as int? ?? 2000, // Default to 2000 if null
      job: json['job'] as String? ?? 'Unemployed', // Default to 'Unemployed' if null
      personality: json['personality'] as String? ?? 'Neutral', // Default to 'Neutral' if null
    );
  }

  // Convert Chatter object to JSON
  Map<String, Object?> toJson() {
    return {
      if (id != null) 'id': id, // Include id only if not null
      'name': name,
      'gender': gender,
      'yearOfBirth': yearOfBirth,
      'job': job,
      'personality': personality,
    };
  }
}
