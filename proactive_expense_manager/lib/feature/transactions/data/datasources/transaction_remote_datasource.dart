import 'package:dio/dio.dart';
import 'package:proactive_expense_manager/core/error/exceptions.dart';
import 'package:proactive_expense_manager/core/network/api_service.dart';
import 'package:proactive_expense_manager/feature/transactions/data/models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<String>> uploadTransactions(List<TransactionModel> transactions);
  Future<List<String>> deleteTransactions(List<String> ids);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final ApiService _api;
  const TransactionRemoteDataSourceImpl(this._api);

  @override
  Future<List<String>> uploadTransactions(
    List<TransactionModel> transactions,
  ) async {
    try {
      final payload = transactions
          .map(
            (t) => {
              'id': t.id,
              'amount': t.amount,
              'note': t.note,
              'type': '${t.type[0].toUpperCase()}${t.type.substring(1)}',
              'category_id': t.categoryId,
              'timestamp': t.timestamp,
            },
          )
          .toList();
      await _api.addTransactions(
        AddTransactionsRequestModel(transactions: payload),
      );
      // Use the IDs we sent — server may not return synced_ids
      return transactions.map((t) => t.id).toList();
    } on DioException catch (e) {
      final data = e.response?.data;
      throw ServerException(
        (data is Map ? data['message'] as String? : null) ??
            e.message ??
            'Sync failed',
      );
    }
  }

  @override
  Future<List<String>> deleteTransactions(List<String> ids) async {
    final deletedIds = <String>[];
    for (final id in ids) {
      try {
        await _api.deleteTransaction(id);
        deletedIds.add(id);
      } on DioException catch (e) {
        // 404 = not on server (uploaded before we sent id, or already deleted)
        // Treat as deleted so the local record is cleaned up
        if (e.response?.statusCode == 404) {
          deletedIds.add(id);
          continue;
        }
        final data = e.response?.data;
        throw ServerException(
          (data is Map ? data['message'] as String? : null) ??
              e.message ??
              'Delete sync failed',
        );
      }
    }
    return deletedIds;
  }
}
