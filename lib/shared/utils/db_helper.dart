import 'dart:io';

import 'package:chat/features/chats/message_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  DBHelper._internal();

  factory DBHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }
Future<Database> _initDatabase() async {
  try {
    // Get the path to the database directory
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat_app.db');
    print('Database path: $path'); // Debugging purpose

    // Ensure the directory exists
    final directory = Directory(dbPath);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    // Open the database
    return await openDatabase(
      path,
      version: 1,
      readOnly: false,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        print('Database opened at: $path'); // Debugging purpose
      },
    );
  } catch (e) {
    print('Error initializing database: $e');
    rethrow;
  }
}


Future<void> _onCreate(Database db, int version) async {
  try {
    // Create `chats` table
    await db.execute('''
      CREATE TABLE chats (
        id TEXT PRIMARY KEY,
        subject TEXT NOT NULL,
        meetingReason TEXT NOT NULL,
        sceneId INTEGER NOT NULL
      )
    ''');

    // Create `chat_participants` table with a foreign key reference to `chats`
    await db.execute('''
      CREATE TABLE chat_participants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chatId TEXT NOT NULL,
        participantId INTEGER NOT NULL,
        objective TEXT,
        mood TEXT,
        FOREIGN KEY (chatId) REFERENCES chats (id) ON DELETE CASCADE
      )
    ''');

    // Create `messages` table with a foreign key reference to `chats`
    await db.execute('''
      CREATE TABLE messages (
        id TEXT PRIMARY KEY,  -- Unique identifier for each message
        chatId TEXT NOT NULL,                  -- Reference to the associated chat
        sender TEXT NOT NULL,                  -- Who sent the message
        content TEXT NOT NULL,                 -- The message content
        timestamp TEXT NOT NULL,               -- Timestamp of when the message was sent
        FOREIGN KEY (chatId) REFERENCES chats (id) ON DELETE CASCADE -- Maintain referential integrity
      )
    ''');


    print('Database created successfully.'); // Debugging purpose
  } catch (e) {
    print('Error during database creation: $e');
    rethrow;
  }
}


  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {
      if (oldVersion < newVersion) {
        // Example migration logic (update as per your schema changes)
        print('Upgrading database from version $oldVersion to $newVersion');
        // Add actual migration logic here
      }
    } catch (e) {
      print('Error during database upgrade: $e');
      rethrow;
    }
  }

  Future<void> resetDatabase() async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.delete('chat_participants');
        await txn.delete('chats');
        await txn.delete('messages');
      });
      print('Database reset successfully.');
    } catch (e) {
      print('Error resetting database: $e');
      rethrow;
    }
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      print('Database closed.');
      _database = null;
    }
  }

Future<void> insertMessage(Message m) async {
  try {
    final db = await database; // Get the database instance

    // Insert the message into the `messages` table
    await db.insert(
      'messages',
      {
        'id': m.id,
        'sender': m.sender,
        'chatId': m.chatId,
        'content': m.content,
        'timestamp': m.timestamp.toIso8601String(), // Convert timestamp to ISO format
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print('Message inserted successfully for chatId: $m.chatId');
  } catch (e) {
    print('Error inserting message: $e');
    rethrow; // Re-throw the error for further handling if necessary
  }
}

  Future<List<Message>> fetchMessages(String chatId) async {
  try {
    final db = await database;

    // Query messages for the given chatId
    final maps = await db.query(
      'messages',
      where: 'chatId = ?',
      whereArgs: [chatId],
      orderBy: 'timestamp DESC', // Order by timestamp descending
    );

    // Convert the map results to Message objects
    return List.generate(
      maps.length,
      (i) => Message(
        id: maps[i]['id'].toString(),
        sender: maps[i]['sender'].toString(), // Adjust this as needed
        content: maps[i]['content'].toString(),
        timestamp:DateTime.parse(maps[i]['timestamp'].toString()), 
        chatId: maps[i]['chatId'].toString(),
      ),
    );
  } catch (e) {
    print('Error fetching messages: $e');
    rethrow;
  }
}

}
