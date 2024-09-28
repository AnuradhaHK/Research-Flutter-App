import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/uploaded_file.dart';

class DatabaseHelper {
  static Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'uploaded_files.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE uploaded_files(id INTEGER PRIMARY KEY AUTOINCREMENT, file_name TEXT, file_path TEXT)',
        );
      },
      version: 1,
    );
  }

  // Insert a file into the database
  static Future<void> insertFile(String fileName, String filePath) async {
    final db = await DatabaseHelper.database();
    await db.insert(
      'uploaded_files',
      {
        'file_name': fileName,
        'file_path': filePath,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all files from the database
  static Future<List<UploadedFile>> getFiles() async {
    final db = await DatabaseHelper.database();
    final List<Map<String, dynamic>> maps = await db.query('uploaded_files');
    return List.generate(maps.length, (i) {
      return UploadedFile(
        id: maps[i]['id'],
        fileName: maps[i]['file_name'],
        filePath: maps[i]['file_path'],
      );
    });
  }

  // Delete a file from the database
  static Future<void> deleteFile(int id) async {
    final db = await DatabaseHelper.database();
    await db.delete(
      'uploaded_files',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
