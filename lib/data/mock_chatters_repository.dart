
//This file will simulate the behavior of the real repository by returning mock data.

class MockChattersRepository {
  Future<List<String>> fetchChatters() async {
    // Simulate a delay to mimic network latency
    await Future.delayed(Duration(seconds: 1));
    // Return mock data
    return ['Alice', 'Bob', 'Charlie', 'Diana', 'Eve'];
  }
}
