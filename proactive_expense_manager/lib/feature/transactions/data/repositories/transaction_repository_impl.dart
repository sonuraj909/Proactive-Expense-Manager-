import 'package:proactive_expense_manager/feature/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:proactive_expense_manager/feature/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:proactive_expense_manager/feature/transactions/data/models/transaction_model.dart';
import 'package:proactive_expense_manager/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:proactive_expense_manager/feature/transactions/domain/repositories/transaction_repository.dart';
import 'package:uuid/uuid.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource _local;
  final TransactionRemoteDataSource _remote;
  final Uuid _uuid;

  const TransactionRepositoryImpl(this._local, this._remote, this._uuid);

  @override
  Future<List<TransactionEntity>> getRecentTransactions({
    int limit = 10,
  }) async {
    final models = await _local.getRecentTransactions(limit: limit);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<TransactionEntity>> getAllTransactions() async {
    final models = await _local.getAllTransactions();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<TransactionEntity> addTransaction({
    required double amount,
    required String note,
    required String type,
    required String categoryId,
  }) async {
    final now = DateTime.now();
    final timestamp = now
        .toIso8601String()
        .replaceFirst('T', ' ')
        .split('.')
        .first;
    final model = TransactionModel(
      id: _uuid.v4(),
      amount: amount,
      note: note,
      type: type,
      categoryId: categoryId,
      isSynced: 0,
      isDeleted: 0,
      timestamp: timestamp,
    );
    final saved = await _local.insertTransaction(model);
    return saved.toEntity();
  }

  @override
  Future<void> softDeleteTransaction(String id) async {
    await _local.softDeleteTransaction(id);
  }

  @override
  Future<double> getMonthlyDebitTotal() async {
    return _local.getMonthlyDebitTotal();
  }

  @override
  Future<List<TransactionEntity>> syncDeletedTransactions() async {
    final pending = await _local.getPendingDelete();
    if (pending.isEmpty) return [];

    // Records never uploaded to server — hard-delete locally, no API call needed
    final neverSynced = pending.where((t) => t.isSynced == 0).map((t) => t.id).toList();
    if (neverSynced.isNotEmpty) {
      await _local.hardDeleteTransactions(neverSynced);
    }

    // Records that were synced to cloud — request cloud deletion
    final onServer = pending.where((t) => t.isSynced == 1).toList();
    if (onServer.isEmpty) return [];

    final sentIds = onServer.map((t) => t.id).toList();
    await _remote.deleteTransactions(sentIds);
    await _local.hardDeleteTransactions(sentIds);
    return onServer.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<TransactionEntity>> syncNewTransactions() async {
    final pending = await _local.getPendingSync();
    if (pending.isEmpty) return [];
    final syncedIds = await _remote.uploadTransactions(pending);
    await _local.markSynced(syncedIds);
    return pending.map((m) => m.toEntity()).toList();
  }
}
