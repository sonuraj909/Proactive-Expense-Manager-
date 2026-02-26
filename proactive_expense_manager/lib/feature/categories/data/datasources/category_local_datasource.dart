import 'package:proactive_expense_manager/core/database/database_helper.dart';
import 'package:proactive_expense_manager/core/error/exceptions.dart';
import 'package:proactive_expense_manager/feature/categories/data/models/category_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getActiveCategories();
  Future<List<CategoryModel>> getPendingSync();
  Future<List<CategoryModel>> getPendingDelete();
  Future<CategoryModel> insertCategory(CategoryModel model);
  Future<void> insertBatch(List<CategoryModel> models);
  Future<void> ensureUncategorizedPlaceholder();
  Future<bool> hasActiveTransactions(String categoryId);
  Future<void> softDeleteCategory(String id);
  Future<void> markSynced(List<String> ids);
  Future<void> hardDeleteCategories(List<String> ids);
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final DatabaseHelper _db;
  const CategoryLocalDataSourceImpl(this._db);

  /// A fixed, well-known ID used as a fallback category for transactions
  /// restored from the cloud that have no associated category.
  /// Stored with is_deleted=1 so it never appears in the UI category list.
  static const uncategorizedId = '00000000-0000-0000-0000-000000000000';

  @override
  Future<List<CategoryModel>> getActiveCategories() async {
    try {
      final db = await _db.database;
      final rows = await db.query(
        DatabaseHelper.tableCategories,
        where: 'is_deleted = ?',
        whereArgs: [0],
        orderBy: 'name ASC',
      );
      return rows.map(CategoryModel.fromDbMap).toList();
    } catch (e) {
      throw CacheException('Failed to load categories: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getPendingSync() async {
    final db = await _db.database;
    final rows = await db.query(
      DatabaseHelper.tableCategories,
      where: 'is_synced = ? AND is_deleted = ?',
      whereArgs: [0, 0],
    );
    return rows.map(CategoryModel.fromDbMap).toList();
  }

  @override
  Future<List<CategoryModel>> getPendingDelete() async {
    final db = await _db.database;
    // Exclude the uncategorized placeholder — it must never be synced/deleted
    // because transactions with no server category are linked to it.
    final rows = await db.query(
      DatabaseHelper.tableCategories,
      where: 'is_deleted = ? AND id != ?',
      whereArgs: [1, uncategorizedId],
    );
    return rows.map(CategoryModel.fromDbMap).toList();
  }

  @override
  Future<bool> hasActiveTransactions(String categoryId) async {
    final db = await _db.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseHelper.tableTransactions} WHERE category_id = ? AND is_deleted = 0',
      [categoryId],
    );
    return (result.first['count'] as int) > 0;
  }

  @override
  Future<CategoryModel> insertCategory(CategoryModel model) async {
    try {
      final db = await _db.database;
      await db.insert(DatabaseHelper.tableCategories, model.toDbMap());
      return model;
    } catch (e) {
      throw CacheException('Failed to insert category: $e');
    }
  }

  @override
  Future<void> ensureUncategorizedPlaceholder() async {
    final db = await _db.database;
    await db.insert(
      DatabaseHelper.tableCategories,
      {
        'id': uncategorizedId,
        'name': 'Uncategorized',
        'is_synced': 1,
        'is_deleted': 1, // hidden from UI category list
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<void> insertBatch(List<CategoryModel> models) async {
    if (models.isEmpty) return;
    final db = await _db.database;
    final batch = db.batch();
    for (final model in models) {
      batch.insert(
        DatabaseHelper.tableCategories,
        model.toDbMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> softDeleteCategory(String id) async {
    final db = await _db.database;
    // Preserve is_synced so we can tell if this record exists on the server
    await db.update(
      DatabaseHelper.tableCategories,
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
        DatabaseHelper.tableCategories,
        {'is_synced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> hardDeleteCategories(List<String> ids) async {
    final db = await _db.database;
    final placeholders = List.filled(ids.length, '?').join(',');
    await db.delete(
      DatabaseHelper.tableCategories,
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
  }
}
