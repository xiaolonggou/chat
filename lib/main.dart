import 'package:chat/features/chatters/chatters_page.dart';
import 'package:chat/features/settings/settings_page.dart';
import 'package:chat/features/scenes/scenes_page.dart';
import 'package:chat/features/chats/chats_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'features/chatters/chatters_controller.dart';
import 'data/mock_chatters_repository.dart'; // Import the mock repository

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ChattersController(repository: MockChattersRepository()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

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
        selectedItemColor: Theme.of(context).colorScheme.primary, // Highlighted icon color
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant, // Non-selected icon color
        backgroundColor: Theme.of(context).colorScheme.surface, // Bar background color
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

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }
}
