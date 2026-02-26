import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proactive_expense_manager/core/database/database_helper.dart';
import 'package:proactive_expense_manager/core/services/local_storage_service.dart';
import 'package:proactive_expense_manager/core/utils/app_logger.dart';
import 'package:proactive_expense_manager/feature/auth/domain/usecases/create_account_usecase.dart';
import 'package:proactive_expense_manager/feature/auth/domain/usecases/send_otp_usecase.dart';
import 'package:proactive_expense_manager/feature/auth/presentation/bloc/auth_event.dart';
import 'package:proactive_expense_manager/feature/auth/presentation/bloc/auth_state.dart';
import 'package:proactive_expense_manager/feature/categories/domain/repositories/category_repository.dart';
import 'package:proactive_expense_manager/feature/transactions/domain/repositories/transaction_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtpUseCase _sendOtp;
  final CreateAccountUseCase _createAccount;
  final LocalStorageService _storage;
  final DatabaseHelper _db;
  final CategoryRepository _categoryRepo;
  final TransactionRepository _transactionRepo;

  AuthBloc({
    required SendOtpUseCase sendOtp,
    required CreateAccountUseCase createAccount,
    required LocalStorageService storage,
    required DatabaseHelper db,
    required CategoryRepository categoryRepository,
    required TransactionRepository transactionRepository,
  })  : _sendOtp = sendOtp,
        _createAccount = createAccount,
        _storage = storage,
        _db = db,
        _categoryRepo = categoryRepository,
        _transactionRepo = transactionRepository,
        super(const AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<CreateAccountEvent>(_onCreateAccount);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final result = await _sendOtp('+91${event.phone}');
      await _storage.savePhone('+91${event.phone}');
      emit(
        OtpSentState(
          otp: result.otp,
          userExists: result.userExists,
          phone: '+91${event.phone}',
          token: result.token,
          nickname: result.nickname,
        ),
      );
    } catch (e) {
      appLogger.error('SendOtp error', error: e);
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (event.enteredOtp != event.expectedOtp) {
      emit(const AuthErrorState('Incorrect OTP. Please try again.'));
      return;
    }
    if (event.userExists && event.token != null) {
      await _storage.saveToken(event.token!);
      if (event.nickname != null) {
        await _storage.saveNickname(event.nickname!);
      }
      final phone = _storage.getPhone() ?? '';
      await _db.reinitForUser(phone);
      try {
        await _categoryRepo.restoreFromCloud();
        await _transactionRepo.restoreFromCloud();
      } catch (e) {
        appLogger.error('Restore from cloud failed', error: e);
      }
      emit(const OtpVerifiedExistingUser());
    } else {
      final phone = _storage.getPhone() ?? '';
      emit(OtpVerifiedNewUser(phone));
    }
  }

  Future<void> _onCreateAccount(
    CreateAccountEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final token = await _createAccount(event.phone, event.nickname);
      await _storage.saveToken(token);
      await _storage.saveNickname(event.nickname);
      await _db.reinitForUser(event.phone);
      emit(const AccountCreatedState());
    } catch (e) {
      appLogger.error('CreateAccount error', error: e);
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await _db.clearAll();
    await _storage.clearAuth();
    emit(const LoggedOutState());
  }
}
