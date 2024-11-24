// lib/features/chatters/chatters_model.dart

class Chatter {
  int? id;
  String name;
  String gender;
  int yearOfBirth;
  String job;
  String personality; // Added field for simulating thought/speech patterns

  Chatter({
    this.id,
    required this.name,
    required this.gender,
    required this.yearOfBirth,
    required this.job,
    required this.personality,
  });

  // Factory constructor for creating a Chatter instance from JSON
  factory Chatter.fromJson(Map<String, dynamic> json) {
    return Chatter(
      id: json['id'],
      name: json['name'] as String,
      gender: json['gender'] as String,
      yearOfBirth: json['year_of_birth'] as int,
      job: json['job'] as String,
      personality: json['personality'] as String,
    );
  }

  // Method for converting a Chatter instance to JSON
  Map<String, Object?> toJson() {
    return {
      if (id != null) 'id': id, // Include 'id' only if it is not null
      'name': name,
      'gender': gender,
      'yearOfBirth': yearOfBirth,
      'job': job,
      'personality': personality,
    };
  }

}
