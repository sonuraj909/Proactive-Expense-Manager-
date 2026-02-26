import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _dbVersion = 1;

  static const tableCategories = 'categories';
  static const tableTransactions = 'transactions';

  Database? _db;
  String _dbName = 'expense_manager_guest.db';

  /// Call this after the user ID is known (login or app restart while logged in).
  Future<void> reinitForUser(String userId) async {
    await _db?.close();
    _db = null;
    final sanitized = userId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    _dbName = 'expense_manager_$sanitized.db';
  }

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onConfigure: (db) async {
        // Enable foreign key support
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCategories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        is_synced INTEGER NOT NULL DEFAULT 0,
        is_deleted INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableTransactions (
        id TEXT PRIMARY KEY,
        amount REAL NOT NULL,
        note TEXT NOT NULL,
        type TEXT NOT NULL,
        category_id TEXT NOT NULL,
        is_synced INTEGER NOT NULL DEFAULT 0,
        is_deleted INTEGER NOT NULL DEFAULT 0,
        timestamp TEXT NOT NULL,
        FOREIGN KEY (category_id) REFERENCES $tableCategories(id)
      )
    ''');
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete(tableTransactions);
    await db.delete(tableCategories);
  }

  Future<void> close() async => _db?.close();
}
