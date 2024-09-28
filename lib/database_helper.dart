import 'dart:typed_data';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'files_database.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE files (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          file BLOB
        )
      ''');
    });
  }

  Future<int> insertFile(String name, Uint8List file) async {
    var dbClient = await db;
    return await dbClient!.insert('files', {'name': name, 'file': file});
  }

  Future<List<Map<String, dynamic>>> getFiles() async {
    var dbClient = await db;
    return await dbClient!.query('files');
  }

  Future<int> updateFile(int id, Uint8List file) async {
    var dbClient = await db;
    return await dbClient!
        .update('files', {'file': file}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteFile(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('files', where: 'id = ?', whereArgs: [id]);
  }
}
