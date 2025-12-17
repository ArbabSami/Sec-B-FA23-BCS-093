import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'translator.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            source_text TEXT,
            translated_text TEXT,
            source_lang TEXT,
            target_lang TEXT,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getFavorites(int userId) async {
    final db = await database;
    return db.query(
      'favorites',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
  }

  Future<int> insertFavorite(Map<String, dynamic> data) async {
    final db = await database;
    return db.insert('favorites', data);
  }

  Future<int> deleteFavorite(int id) async {
    final db = await database;
    return db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
