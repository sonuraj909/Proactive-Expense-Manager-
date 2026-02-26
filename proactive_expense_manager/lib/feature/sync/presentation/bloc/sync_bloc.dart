import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proactive_expense_manager/core/utils/app_logger.dart';
import 'package:proactive_expense_manager/feature/categories/domain/repositories/category_repository.dart';
import 'package:proactive_expense_manager/feature/sync/presentation/bloc/sync_event.dart';
import 'package:proactive_expense_manager/feature/sync/presentation/bloc/sync_state.dart';
import 'package:proactive_expense_manager/feature/transactions/domain/repositories/transaction_repository.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final CategoryRepository _categoryRepo;
  final TransactionRepository _transactionRepo;

  SyncBloc({
    required CategoryRepository categoryRepository,
    required TransactionRepository transactionRepository,
  })  : _categoryRepo = categoryRepository,
        _transactionRepo = transactionRepository,
        super(const SyncInitial()) {
    on<StartSyncEvent>(_onStartSync);
  }

  Future<void> _onStartSync(
    StartSyncEvent event,
    Emitter<SyncState> emit,
  ) async {
    emit(const SyncInProgress('Cleaning up deleted records...'));
    try {
      // Step A1: Delete transactions first (FK constraint)
      final pendingDeletedTx = await _transactionRepo.syncDeletedTransactions();
      appLogger.info('Deleted ${pendingDeletedTx.length} transactions from cloud');

      // Step A2: Delete categories after transactions are cleaned up
      final pendingDeletedCat = await _categoryRepo.syncDeletedCategories();
      appLogger.info('Deleted ${pendingDeletedCat.length} categories from cloud');

      // Step B1: Sync new categories first
      emit(const SyncInProgress('Uploading new categories...'));
      final syncedCats = await _categoryRepo.syncNewCategories();
      appLogger.info('Synced ${syncedCats.length} categories to cloud');

      // Step B2: Sync new transactions after categories are in cloud
      emit(const SyncInProgress('Uploading new transactions...'));
      final syncedTx = await _transactionRepo.syncNewTransactions();
      appLogger.info('Synced ${syncedTx.length} transactions to cloud');

      final total = pendingDeletedTx.length +
          pendingDeletedCat.length +
          syncedCats.length +
          syncedTx.length;
      emit(SyncCompleted(totalSynced: total));
    } catch (e) {
      appLogger.error('Sync error', error: e);
      emit(SyncFailed(e.toString()));
    }
  }
}
