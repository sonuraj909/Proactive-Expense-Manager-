import 'package:equatable/equatable.dart';
import 'package:proactive_expense_manager/feature/transactions/domain/entities/transaction_entity.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

class TransactionLoading extends TransactionState {
  const TransactionLoading();
}

class TransactionLoaded extends TransactionState {
  final List<TransactionEntity> transactions;
  final double totalIncome;
  final double totalExpense;

  const TransactionLoaded({
    required this.transactions,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  List<Object?> get props => [transactions, totalIncome, totalExpense];
}

class TransactionError extends TransactionState {
  final String message;
  const TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}
