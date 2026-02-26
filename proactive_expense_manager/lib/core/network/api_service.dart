import 'package:dio/dio.dart';
import 'package:proactive_expense_manager/feature/auth/data/models/auth_models.dart';
import 'package:proactive_expense_manager/feature/categories/data/models/category_model.dart';
import 'package:proactive_expense_manager/feature/transactions/data/models/transaction_model.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: 'https://appskilltest.zybotech.in')
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  // ── Auth ──────────────────────────────────────────────────────────────────

  @POST('/auth/send-otp/')
  Future<SendOtpResponseModel> sendOtp(@Body() SendOtpRequestModel request);

  @POST('/auth/create-account/')
  Future<CreateAccountResponseModel> createAccount(
    @Body() CreateAccountRequestModel request,
  );

  // ── Categories ────────────────────────────────────────────────────────────

  @GET('/categories/')
  Future<CategoriesResponseModel> getCategories();

  @POST('/categories/add/')
  @FormUrlEncoded()
  Future<SyncIdsResponseModel> addCategory(
    @Field('category_id') String id,
    @Field('name') String name,
  );

  @DELETE('/categories/delete/')
  @FormUrlEncoded()
  Future<DeleteIdsResponseModel> deleteCategory(
    @Field('category_id') String id,
  );

  // ── Transactions ──────────────────────────────────────────────────────────

  @GET('/transactions/')
  Future<TransactionsResponseModel> getTransactions();

  @POST('/transactions/add/')
  Future<SyncIdsResponseModel> addTransactions(
    @Body() AddTransactionsRequestModel request,
  );

  @DELETE('/transactions/delete/')
  Future<DeleteIdsResponseModel> deleteTransactions(
    @Body() DeleteTransactionsRequestModel request,
  );
}
