import 'package:proactive_expense_manager/feature/categories/data/datasources/category_local_datasource.dart';
import 'package:proactive_expense_manager/feature/categories/data/datasources/category_remote_datasource.dart';
import 'package:proactive_expense_manager/feature/categories/data/models/category_model.dart';
import 'package:proactive_expense_manager/feature/categories/domain/entities/category_entity.dart';
import 'package:proactive_expense_manager/feature/categories/domain/repositories/category_repository.dart';
import 'package:uuid/uuid.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource _local;
  final CategoryRemoteDataSource _remote;
  final Uuid _uuid;

  const CategoryRepositoryImpl(this._local, this._remote, this._uuid);

  @override
  Future<List<CategoryEntity>> getLocalCategories() async {
    final models = await _local.getActiveCategories();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<CategoryEntity> addCategory(String name) async {
    final model = CategoryModel(
      id: _uuid.v4(),
      name: name,
      isSynced: 0,
      isDeleted: 0,
    );
    final saved = await _local.insertCategory(model);
    return saved.toEntity();
  }

  @override
  Future<void> softDeleteCategory(String id) async {
    if (await _local.hasActiveTransactions(id)) {
      throw Exception('Cannot delete a category that has transactions. Remove the transactions first.');
    }
    await _local.softDeleteCategory(id);
  }

  @override
  Future<List<CategoryEntity>> syncDeletedCategories() async {
    final pending = await _local.getPendingDelete();
    if (pending.isEmpty) return [];

    // Records never uploaded to server — hard-delete locally, no API call needed
    final neverSynced = pending.where((c) => c.isSynced == 0).map((c) => c.id).toList();
    if (neverSynced.isNotEmpty) {
      await _local.hardDeleteCategories(neverSynced);
    }

    // Records that were synced to cloud — request cloud deletion
    final onServer = pending.where((c) => c.isSynced == 1).toList();
    if (onServer.isEmpty) return [];

    final sentIds = onServer.map((c) => c.id).toList();
    await _remote.deleteCategories(sentIds);
    await _local.hardDeleteCategories(sentIds);
    return onServer.map((m) => m.toEntity().copyWithDeleted()).toList();
  }

  @override
  Future<List<CategoryEntity>> syncNewCategories() async {
    final pending = await _local.getPendingSync();
    if (pending.isEmpty) return [];
    final syncedIds = await _remote.uploadCategories(pending);
    await _local.markSynced(syncedIds);
    return pending.map((m) => m.toEntity()).toList();
  }
}

extension on CategoryEntity {
  CategoryEntity copyWithDeleted() => CategoryEntity(
    id: id,
    name: name,
    isSynced: isSynced,
    isDeleted: true,
  );
}
