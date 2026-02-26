import 'package:proactive_expense_manager/core/database/database_helper.dart';
import 'package:proactive_expense_manager/core/error/exceptions.dart';
import 'package:proactive_expense_manager/feature/transactions/data/models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getRecentTransactions({int limit = 10});
  Future<List<TransactionModel>> getAllTransactions();
  Future<List<TransactionModel>> getPendingSync();
  Future<List<TransactionModel>> getPendingDelete();
  Future<TransactionModel> insertTransaction(TransactionModel model);
  Future<void> softDeleteTransaction(String id);
  Future<void> markSynced(List<String> ids);
  Future<void> hardDeleteTransactions(List<String> ids);
  Future<double> getMonthlyDebitTotal();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final DatabaseHelper _db;
  const TransactionLocalDataSourceImpl(this._db);

  // SQL JOIN to fetch category_name with each transaction
  static const _joinQuery = '''
    SELECT t.*, c.name as category_name
    FROM ${DatabaseHelper.tableTransactions} t
    LEFT JOIN ${DatabaseHelper.tableCategories} c ON t.category_id = c.id
    WHERE t.is_deleted = 0
  ''';

  @override
  Future<List<TransactionModel>> getRecentTransactions({
    int limit = 10,
  }) async {
    try {
      final db = await _db.database;
      final rows = await db.rawQuery(
        '$_joinQuery ORDER BY t.timestamp DESC LIMIT ?',
        [limit],
      );
      return rows.map(TransactionModel.fromDbMap).toList();
    } catch (e) {
      throw CacheException('Failed to load recent transactions: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final db = await _db.database;
      final rows = await db.rawQuery(
        '$_joinQuery ORDER BY t.timestamp DESC',
      );
      return rows.map(TransactionModel.fromDbMap).toList();
    } catch (e) {
      throw CacheException('Failed to load all transactions: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getPendingSync() async {
    final db = await _db.database;
    final rows = await db.rawQuery('''
      SELECT t.*, c.name as category_name
      FROM ${DatabaseHelper.tableTransactions} t
      LEFT JOIN ${DatabaseHelper.tableCategories} c ON t.category_id = c.id
      WHERE t.is_synced = 0 AND t.is_deleted = 0
    ''');
    return rows.map(TransactionModel.fromDbMap).toList();
  }

  @override
  Future<List<TransactionModel>> getPendingDelete() async {
    final db = await _db.database;
    final rows = await db.query(
      DatabaseHelper.tableTransactions,
      where: 'is_deleted = ?',
      whereArgs: [1],
    );
    return rows
        .map((r) => TransactionModel.fromDbMap({...r, 'category_name': ''}))
        .toList();
  }

  @override
  Future<TransactionModel> insertTransaction(TransactionModel model) async {
    try {
      final db = await _db.database;
      await db.insert(DatabaseHelper.tableTransactions, model.toDbMap());
      // Re-fetch with JOIN so categoryName is populated in the returned model
      final rows = await db.rawQuery(
        '$_joinQuery AND t.id = ?',
        [model.id],
      );
      if (rows.isEmpty) throw CacheException('Inserted transaction not found');
      return TransactionModel.fromDbMap(rows.first);
    } catch (e) {
      throw CacheException('Failed to insert transaction: $e');
    }
  }

  @override
  Future<void> softDeleteTransaction(String id) async {
    final db = await _db.database;
    // Preserve is_synced so we can tell if this record exists on the server
    await db.update(
      DatabaseHelper.tableTransactions,
      {'is_deleted': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> markSynced(List<String> ids) async {
    final db = await _db.database;
    final batch = db.batch();
    for (final id in ids) {
      batch.update(
        DatabaseHelper.tableTransactions,
        {'is_synced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> hardDeleteTransactions(List<String> ids) async {
    final db = await _db.database;
    final placeholders = List.filled(ids.length, '?').join(',');
    await db.delete(
      DatabaseHelper.tableTransactions,
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
  }

  @override
  Future<double> getMonthlyDebitTotal() async {
    final db = await _db.database;
    final now = DateTime.now();
    final firstOfMonth = DateTime(now.year, now.month, 1)
        .toIso8601String()
        .replaceFirst('T', ' ')
        .split('.')
        .first;
    final result = await db.rawQuery('''
      SELECT COALESCE(SUM(amount), 0) as total
      FROM ${DatabaseHelper.tableTransactions}
      WHERE type = 'debit' AND is_deleted = 0 AND timestamp >= ?
    ''', [firstOfMonth]);
    return (result.first['total'] as num).toDouble();
  }
}
