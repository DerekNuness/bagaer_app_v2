import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MediaDb {
  static const _dbName = 'bagaer_media.db';
  static const _dbVersion = 1;

  static Database? _database;

  static Future<Database> get instance async {
    if (_database != null) return _database!;
    _database = await _init();
    return _database!;
  }

  static Future<Database> _init() async {
    final path = join(await getDatabasesPath(), _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE media (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            kind TEXT NOT NULL,
            original_path TEXT NOT NULL,
            processed_path TEXT NOT NULL,
            created_at INTEGER NOT NULL
          )
        ''');
      },
    );
  }
}