import 'package:chat/data/api_chatters_repository.dart';
import 'package:chat/data/api_scenes_repository.dart';
import 'package:chat/data/mock_chatters_repository.dart';
import 'package:chat/data/mock_scenes_repository.dart';
import 'package:chat/features/chatters/chatters_controller.dart';
import 'package:chat/features/chatters/chatters_page.dart';
import 'package:chat/features/chatters/chatters_repository.dart';
import 'package:chat/features/chats/chats_page.dart';
import 'package:chat/features/scenes/scenes_controller.dart';
import 'package:chat/features/scenes/scenes_page.dart';
import 'package:chat/features/scenes/scenes_repository.dart';
import 'package:chat/features/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const String serverUrl = 'http://localhost:3000';
  final bool useMockData = await _shouldUseMockData(serverUrl); // Toggle this to switch repositories

  final ChattersRepository chattersRepository = useMockData
      ? MockChattersRepository()
      : ApiChattersRepository(baseUrl: '$serverUrl/api');

  final ScenesRepository scenesRepository = useMockData
      ? MockScenesRepository()
      : ApiScenesRepository(baseUrl: '$serverUrl/api');

  final chattersController = ChattersController(repository: chattersRepository);
  final scenesController = ScenesController(repository: scenesRepository);

  runApp(MyApp(
    chattersController: chattersController,
    scenesController: scenesController,
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
  final ScenesController scenesController;
  final bool useMockData;

  MyApp({
    required this.chattersController,
    required this.scenesController,
    required this.useMockData,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => chattersController),
        ChangeNotifierProvider(create: (_) => scenesController),
      ],
      child: MaterialApp(
        title: 'Chat App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
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
        break;
      case 1:
        page = ChattersPage();
        break;
      case 2:
        page = ScenesPage();
        break;
      case 3:
        page = SettingsPage();
        break;
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
