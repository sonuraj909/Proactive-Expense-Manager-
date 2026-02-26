import 'package:proactive_expense_manager/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:proactive_expense_manager/feature/transactions/domain/repositories/transaction_repository.dart';

class GetRecentTransactionsUseCase {
  final TransactionRepository _repository;
  const GetRecentTransactionsUseCase(this._repository);

  Future<List<TransactionEntity>> call({int limit = 10}) =>
      _repository.getRecentTransactions(limit: limit);
}

class GetAllTransactionsUseCase {
  final TransactionRepository _repository;
  const GetAllTransactionsUseCase(this._repository);

  Future<List<TransactionEntity>> call() => _repository.getAllTransactions();
}
