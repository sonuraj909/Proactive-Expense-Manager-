import 'package:equatable/equatable.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
  @override
  List<Object?> get props => [];
}

class LoadRecentTransactionsEvent extends TransactionEvent {
  const LoadRecentTransactionsEvent();
}

class LoadAllTransactionsEvent extends TransactionEvent {
  const LoadAllTransactionsEvent();
}

class AddTransactionEvent extends TransactionEvent {
  final double amount;
  final String note;
  final String type;
  final String categoryId;

  const AddTransactionEvent({
    required this.amount,
    required this.note,
    required this.type,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [amount, note, type, categoryId];
}

class DeleteTransactionEvent extends TransactionEvent {
  final String id;
  const DeleteTransactionEvent(this.id);

  @override
  List<Object?> get props => [id];
}
