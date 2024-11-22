// Data model(s) for Chatters

class Chatter {
  String id;
  String name;
  String gender;
  int yearOfBirth;
  String job;
  String personality; // Added field for simulating thought/speech patterns

  Chatter({
    required this.id,
    required this.name,
    required this.gender,
    required this.yearOfBirth,
    required this.job,
    required this.personality,
  });
}
