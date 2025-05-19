import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;
  DatabaseHelper._internal();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'form_data.db');
    return await openDatabase(path, version: 5, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE IF NOT EXISTS forms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT,
        lastName TEXT,
        email TEXT,
        gender TEXT,
        religion TEXT,
        birthdate TEXT,
        isSynced INTEGER DEFAULT 0
        
        

      );
    ''');
  }

  Future<int> insertData(Map<String, dynamic> data) async {
    final db = await database;
    const table = 'forms';
    await db.delete(table);
    final existingColumns =
        (await db.rawQuery(
          'PRAGMA table_info($table)',
        )).map((e) => e['name'] as String).toSet();
    print('Existing columns: $existingColumns');

    for (final key in data.keys) {
      if (!existingColumns.contains(key)) {
        print('Adding column: $key');
        await db.execute('ALTER TABLE $table ADD COLUMN `$key` TEXT');
      }
    }
    data = data.map((key, value) => MapEntry(key, value ?? ''));
    data['isSynced'] = 0;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await database;
    return await db.query('forms');
  }

  Future<void> syncUnsentData() async {
    final db = await database;
    final unsyncedRows = await db.query(
      'forms',
      where: 'isSynced = ?',
      whereArgs: [0],
    );

    for (var row in unsyncedRows) {
      final Map<String, dynamic> firebaseData =
          Map.from(row)
            ..remove('id')
            ..remove('isSynced');
      try {
        await FirebaseFirestore.instance
            .collection('submittedForms')
            .add(firebaseData);
        await db.update(
          'forms',
          {'isSynced': 1},
          where: 'id = ?',
          whereArgs: [row['id']],
        );
      } catch (e) {
        print(' فشل مزامنة سجل: ${row['id']}, $e');
      }
    }
  }
}
