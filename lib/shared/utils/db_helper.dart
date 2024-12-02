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
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create tables
    await db.execute('''
      CREATE TABLE chats (
        id TEXT PRIMARY KEY,
        subject TEXT,
        meetingReason TEXT,
        sceneId TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE chat_participants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chatId TEXT,
        participantId INTEGER,
        objective TEXT,
        mood TEXT
      )
    ''');
  }
}
