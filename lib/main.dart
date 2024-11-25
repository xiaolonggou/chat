import 'package:chat/data/api_chatters_repository.dart';
import 'package:chat/features/chatters/chatters_page.dart';
import 'package:chat/features/settings/settings_page.dart';
import 'package:chat/features/scenes/scenes_page.dart';
import 'package:chat/features/chats/chats_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart'; // Import the provider package
import 'features/chatters/chatters_controller.dart';
import 'data/mock_chatters_repository.dart';
import 'features/chatters/chatters_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const String serverUrl = 'http://localhost:3000';
  final bool useMockData = await _shouldUseMockData(serverUrl); // Toggle this to switch repositories

  final ChattersRepository repository = useMockData
      ? MockChattersRepository()
      : ApiChattersRepository(baseUrl: '$serverUrl/api'); // Use the appropriate repository

  final chattersController = ChattersController(repository: repository);

  runApp(MyApp(
    chattersController: chattersController,
    useMockData: useMockData,
  ));
}

Future<bool> _shouldUseMockData(String serverUrl) async {
  try {
    final response = await http.get(Uri.parse('$serverUrl/ping'));
    if (response.statusCode == 200) {
      return false; // Server is reachable, use API data
    }
  } catch (e) {
    // Log or handle the exception if needed
  }
  return true; // Default to mock data if ping fails
}

class MyApp extends StatelessWidget {
  final ChattersController chattersController;
  final bool useMockData;

  MyApp({required this.chattersController, required this.useMockData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => chattersController,  // Provide the controller here
      child: MaterialApp(
        title: 'Chat App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(), // The home page of your app
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = ChatsPage();
      case 1:
        page = ChattersPage();
      case 2:
        page = ScenesPage();
      case 3:
        page = SettingsPage();
      default:
        throw UnimplementedError('No widget for index $selectedIndex');
    }

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        backgroundColor: Theme.of(context).colorScheme.surface,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            label: 'Chatters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Scenes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
