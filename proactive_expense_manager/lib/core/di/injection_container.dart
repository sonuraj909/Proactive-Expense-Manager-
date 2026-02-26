import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:proactive_expense_manager/core/bloc/bloc_factory.dart';
import 'package:proactive_expense_manager/core/database/database_helper.dart';
import 'package:proactive_expense_manager/core/network/api_service.dart';
import 'package:proactive_expense_manager/core/network/dio_client.dart';
import 'package:proactive_expense_manager/core/services/local_storage_service.dart';
import 'package:proactive_expense_manager/core/services/notification_service.dart';
import 'package:proactive_expense_manager/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:proactive_expense_manager/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:proactive_expense_manager/feature/auth/domain/repositories/auth_repository.dart';
import 'package:proactive_expense_manager/feature/auth/domain/usecases/create_account_usecase.dart';
import 'package:proactive_expense_manager/feature/auth/domain/usecases/send_otp_usecase.dart';
import 'package:proactive_expense_manager/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:proactive_expense_manager/feature/categories/data/datasources/category_local_datasource.dart';
import 'package:proactive_expense_manager/feature/categories/data/datasources/category_remote_datasource.dart';
import 'package:proactive_expense_manager/feature/categories/data/repositories/category_repository_impl.dart';
import 'package:proactive_expense_manager/feature/categories/domain/repositories/category_repository.dart';
import 'package:proactive_expense_manager/feature/categories/domain/usecases/add_category_usecase.dart';
import 'package:proactive_expense_manager/feature/categories/domain/usecases/delete_category_usecase.dart';
import 'package:proactive_expense_manager/feature/categories/domain/usecases/get_categories_usecase.dart';
import 'package:proactive_expense_manager/feature/categories/presentation/bloc/category_bloc.dart';
import 'package:proactive_expense_manager/feature/onboarding/di/onboarding_injection.dart';
import 'package:proactive_expense_manager/feature/sync/presentation/bloc/sync_bloc.dart';
import 'package:proactive_expense_manager/feature/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:proactive_expense_manager/feature/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:proactive_expense_manager/feature/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:proactive_expense_manager/feature/transactions/domain/repositories/transaction_repository.dart';
import 'package:proactive_expense_manager/feature/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:proactive_expense_manager/feature/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:proactive_expense_manager/feature/transactions/domain/usecases/get_transactions_usecase.dart';
import 'package:proactive_expense_manager/feature/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  sl.registerSingleton<FlutterLocalNotificationsPlugin>(notificationsPlugin);

  sl.registerSingleton<Uuid>(const Uuid());

  sl.registerSingleton<BlocFactory>(BlocFactory(sl));

  sl.registerSingleton<LocalStorageService>(
    LocalStorageService(sl<SharedPreferences>()),
  );

  sl.registerSingleton<NotificationService>(
    NotificationService(sl<FlutterLocalNotificationsPlugin>()),
  );

  sl.registerSingleton<DatabaseHelper>(DatabaseHelper());

  sl.registerSingleton<ApiService>(
    ApiService(DioClient.createDio(sl<LocalStorageService>())),
  );

  sl.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(sl<ApiService>()),
  );
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );
  sl.registerSingleton<SendOtpUseCase>(SendOtpUseCase(sl<AuthRepository>()));
  sl.registerSingleton<CreateAccountUseCase>(
    CreateAccountUseCase(sl<AuthRepository>()),
  );
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      sendOtp: sl<SendOtpUseCase>(),
      createAccount: sl<CreateAccountUseCase>(),
      storage: sl<LocalStorageService>(),
      db: sl<DatabaseHelper>(),
    ),
  );

  sl.registerSingleton<CategoryLocalDataSource>(
    CategoryLocalDataSourceImpl(sl<DatabaseHelper>()),
  );
  sl.registerSingleton<CategoryRemoteDataSource>(
    CategoryRemoteDataSourceImpl(sl<ApiService>()),
  );
  sl.registerSingleton<CategoryRepository>(
    CategoryRepositoryImpl(
      sl<CategoryLocalDataSource>(),
      sl<CategoryRemoteDataSource>(),
      sl<Uuid>(),
    ),
  );
  sl.registerSingleton<GetCategoriesUseCase>(
    GetCategoriesUseCase(sl<CategoryRepository>()),
  );
  sl.registerSingleton<AddCategoryUseCase>(
    AddCategoryUseCase(sl<CategoryRepository>()),
  );
  sl.registerSingleton<DeleteCategoryUseCase>(
    DeleteCategoryUseCase(sl<CategoryRepository>()),
  );
  sl.registerFactory<CategoryBloc>(
    () => CategoryBloc(
      getCategories: sl<GetCategoriesUseCase>(),
      addCategory: sl<AddCategoryUseCase>(),
      deleteCategory: sl<DeleteCategoryUseCase>(),
    ),
  );

  sl.registerSingleton<TransactionLocalDataSource>(
    TransactionLocalDataSourceImpl(sl<DatabaseHelper>()),
  );
  sl.registerSingleton<TransactionRemoteDataSource>(
    TransactionRemoteDataSourceImpl(sl<ApiService>()),
  );
  sl.registerSingleton<TransactionRepository>(
    TransactionRepositoryImpl(
      sl<TransactionLocalDataSource>(),
      sl<TransactionRemoteDataSource>(),
      sl<Uuid>(),
    ),
  );
  sl.registerSingleton<GetRecentTransactionsUseCase>(
    GetRecentTransactionsUseCase(sl<TransactionRepository>()),
  );
  sl.registerSingleton<GetAllTransactionsUseCase>(
    GetAllTransactionsUseCase(sl<TransactionRepository>()),
  );
  sl.registerSingleton<AddTransactionUseCase>(
    AddTransactionUseCase(sl<TransactionRepository>()),
  );
  sl.registerSingleton<DeleteTransactionUseCase>(
    DeleteTransactionUseCase(sl<TransactionRepository>()),
  );
  sl.registerFactory<TransactionBloc>(
    () => TransactionBloc(
      getRecent: sl<GetRecentTransactionsUseCase>(),
      getAll: sl<GetAllTransactionsUseCase>(),
      addTransaction: sl<AddTransactionUseCase>(),
      deleteTransaction: sl<DeleteTransactionUseCase>(),
      repository: sl<TransactionRepository>(),
      notifications: sl<NotificationService>(),
      storage: sl<LocalStorageService>(),
    ),
  );

  sl.registerFactory<SyncBloc>(
    () => SyncBloc(
      categoryRepository: sl<CategoryRepository>(),
      transactionRepository: sl<TransactionRepository>(),
    ),
  );

  registerOnboardingDependencies(sl);
}
