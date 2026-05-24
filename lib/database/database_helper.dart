import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('medications.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medications(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        dosage TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE logs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medicationId INTEGER NOT NULL,
        takenAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertMedication(Map<String, dynamic> row) async {
    final db = await instance.database;

    return await db.insert('medications', row);
  }

  Future<List<Map<String, dynamic>>> getMedications() async {
    final db = await instance.database;

    return await db.query('medications');
  }

  Future<int> addLog(int medicationId) async {
    final db = await database;

    return await db.insert('logs', {
      'medicationId': medicationId,
      'takenAt': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getLogs() async {
  final db = await database;

  return await db.rawQuery('''
    SELECT logs.id, logs.takenAt, medications.name, medications.dosage
    FROM logs
    JOIN medications ON medications.id = logs.medicationId
    ORDER BY logs.takenAt DESC
  ''');
  }

}