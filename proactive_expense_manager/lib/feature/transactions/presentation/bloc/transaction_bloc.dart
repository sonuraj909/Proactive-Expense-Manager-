import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proactive_expense_manager/core/services/local_storage_service.dart';
import 'package:proactive_expense_manager/core/services/notification_service.dart';
import 'package:proactive_expense_manager/core/utils/app_logger.dart';
import 'package:proactive_expense_manager/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:proactive_expense_manager/feature/transactions/domain/repositories/transaction_repository.dart';
import 'package:proactive_expense_manager/feature/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:proactive_expense_manager/feature/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:proactive_expense_manager/feature/transactions/domain/usecases/get_transactions_usecase.dart';
import 'package:proactive_expense_manager/feature/transactions/presentation/bloc/transaction_event.dart';
import 'package:proactive_expense_manager/feature/transactions/presentation/bloc/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetRecentTransactionsUseCase _getRecent;
  final GetAllTransactionsUseCase _getAll;
  final AddTransactionUseCase _addTransaction;
  final DeleteTransactionUseCase _deleteTransaction;
  final TransactionRepository _repository;
  final NotificationService _notifications;
  final LocalStorageService _storage;

  TransactionBloc({
    required GetRecentTransactionsUseCase getRecent,
    required GetAllTransactionsUseCase getAll,
    required AddTransactionUseCase addTransaction,
    required DeleteTransactionUseCase deleteTransaction,
    required TransactionRepository repository,
    required NotificationService notifications,
    required LocalStorageService storage,
  })  : _getRecent = getRecent,
        _getAll = getAll,
        _addTransaction = addTransaction,
        _deleteTransaction = deleteTransaction,
        _repository = repository,
        _notifications = notifications,
        _storage = storage,
        super(const TransactionInitial()) {
    on<LoadRecentTransactionsEvent>(_onLoadRecent);
    on<LoadAllTransactionsEvent>(_onLoadAll);
    on<AddTransactionEvent>(_onAdd);
    on<DeleteTransactionEvent>(_onDelete);
  }

  Future<void> _onLoadRecent(
    LoadRecentTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());
    try {
      final transactions = await _getRecent();
      emit(_buildLoaded(transactions));
    } catch (e) {
      appLogger.error('Load recent transactions error', error: e);
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onLoadAll(
    LoadAllTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());
    try {
      final transactions = await _getAll();
      emit(_buildLoaded(transactions));
    } catch (e) {
      appLogger.error('Load all transactions error', error: e);
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onAdd(
    AddTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      final newTx = await _addTransaction(
        amount: event.amount,
        note: event.note,
        type: event.type,
        categoryId: event.categoryId,
      );

      final current = state is TransactionLoaded
          ? (state as TransactionLoaded).transactions
          : <TransactionEntity>[];
      final updated = [newTx, ...current];
      emit(_buildLoaded(updated));

      if (event.type == 'debit') {
        await _checkBudgetLimit();
      }
    } catch (e) {
      appLogger.error('Add transaction error', error: e);
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await _deleteTransaction(event.id);
      final current = state is TransactionLoaded
          ? (state as TransactionLoaded).transactions
          : <TransactionEntity>[];
      final updated = current.where((t) => t.id != event.id).toList();
      emit(_buildLoaded(updated));
    } catch (e) {
      appLogger.error('Delete transaction error', error: e);
      emit(TransactionError(e.toString()));
    }
  }

  TransactionLoaded _buildLoaded(List<TransactionEntity> transactions) {
    final income = transactions
        .where((t) => t.isCredit)
        .fold(0.0, (sum, t) => sum + t.amount);
    final expense = transactions
        .where((t) => t.isDebit)
        .fold(0.0, (sum, t) => sum + t.amount);
    return TransactionLoaded(
      transactions: transactions,
      totalIncome: income,
      totalExpense: expense,
    );
  }

  Future<void> _checkBudgetLimit() async {
    try {
      final monthlyTotal = await _repository.getMonthlyDebitTotal();
      final limit = _storage.getBudgetLimit();
      if (monthlyTotal > limit) {
        await _notifications.showBudgetLimitAlert(
          totalExpense: monthlyTotal,
          limit: limit,
        );
      }
    } catch (e) {
      appLogger.warning('Budget check failed', error: e);
    }
  }
}
