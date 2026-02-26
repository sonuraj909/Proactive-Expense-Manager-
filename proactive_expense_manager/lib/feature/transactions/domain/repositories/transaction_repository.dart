import 'package:proactive_expense_manager/feature/transactions/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<List<TransactionEntity>> getRecentTransactions({int limit = 10});
  Future<List<TransactionEntity>> getAllTransactions();
  Future<TransactionEntity> addTransaction({
    required double amount,
    required String note,
    required String type,
    required String categoryId,
  });
  Future<void> softDeleteTransaction(String id);
  Future<double> getMonthlyDebitTotal();
  Future<List<TransactionEntity>> syncDeletedTransactions();
  Future<List<TransactionEntity>> syncNewTransactions();
  Future<void> restoreFromCloud();
}
