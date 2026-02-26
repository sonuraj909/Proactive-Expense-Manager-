import 'package:proactive_expense_manager/feature/transactions/domain/repositories/transaction_repository.dart';

class DeleteTransactionUseCase {
  final TransactionRepository _repository;
  const DeleteTransactionUseCase(this._repository);

  Future<void> call(String id) => _repository.softDeleteTransaction(id);
}
