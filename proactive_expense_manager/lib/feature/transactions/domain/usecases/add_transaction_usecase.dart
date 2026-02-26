import 'package:proactive_expense_manager/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:proactive_expense_manager/feature/transactions/domain/repositories/transaction_repository.dart';

class AddTransactionUseCase {
  final TransactionRepository _repository;
  const AddTransactionUseCase(this._repository);

  Future<TransactionEntity> call({
    required double amount,
    required String note,
    required String type,
    required String categoryId,
  }) => _repository.addTransaction(
    amount: amount,
    note: note,
    type: type,
    categoryId: categoryId,
  );
}
