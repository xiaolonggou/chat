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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat_app.db');

    return await openDatabase(
      path,
      version: 1, // Increment version for schema changes
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create `chats` table
    await db.execute('''
      CREATE TABLE chats (
        id TEXT PRIMARY KEY,
        subject TEXT NOT NULL,
        meetingReason TEXT NOT NULL,
        sceneId TEXT NOT NULL
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
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Add migrations for schema changes
    if (oldVersion < newVersion) {
      // Example migration (modify as needed for your schema)
    }
  }

  Future<void> resetDatabase() async {
    final db = await database;
    // Delete all data from tables
    await db.delete('chat_participants');
    await db.delete('chats');
    // Optionally recreate tables
    await _onCreate(db, 1);
  }
}
