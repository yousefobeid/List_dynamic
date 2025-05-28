import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;
  DatabaseHelper._internal();
  Future<Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;
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

    final existingColumns =
        (await db.rawQuery(
          'PRAGMA table_info($table)',
        )).map((e) => e['name']?.toString() ?? '').toSet();

    if (!existingColumns.contains('idFirebase')) {
      await db.execute('ALTER TABLE $table ADD COLUMN idFirebase TEXT');
    }
    for (var key in data.keys) {
      if (!existingColumns.contains(key)) {
        await db.execute('ALTER TABLE $table ADD COLUMN $key TEXT');
      }
    }
    var uuid = const Uuid();
    data['idFirebase'] = data['idFirebase'] ?? uuid.v4();
    data['isSynced'] = 0;
    data = data.map((key, value) => MapEntry(key, value?.toString() ?? ''));

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
      final Object? docId = row['idFirebase'];
      final localData =
          Map<String, dynamic>.from(row)
            ..remove('id')
            ..remove('isSynced');

      try {
        final docRef = FirebaseFirestore.instance
            .collection('submittedForms')
            .doc(docId as String? ?? Uuid().v4());

        final docSnapshot = await docRef.get();
        if (!docSnapshot.exists) {
          await docRef.set(localData);
          await db.update(
            'forms',
            {'isSynced': 1},
            where: 'id = ?',
            whereArgs: [row['id']],
          );
          print("تمت مزامنة السجل بنجاح");
        } else {
          print("السجل موجود بالفعل، تم تجاهله");
        }
      } catch (e) {
        print('فشل رفع السجل: ${row['id']}, $e');
      }
    }
  }
}
