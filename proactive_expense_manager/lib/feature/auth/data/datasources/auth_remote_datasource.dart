import 'package:dio/dio.dart';
import 'package:proactive_expense_manager/core/error/exceptions.dart';
import 'package:proactive_expense_manager/core/network/api_service.dart';
import 'package:proactive_expense_manager/feature/auth/data/models/auth_models.dart';

abstract class AuthRemoteDataSource {
  Future<SendOtpResponseModel> sendOtp(String phone);
  Future<CreateAccountResponseModel> createAccount(
    String phone,
    String nickname,
  );
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _api;
  const AuthRemoteDataSourceImpl(this._api);

  @override
  Future<SendOtpResponseModel> sendOtp(String phone) async {
    try {
      return await _api.sendOtp(SendOtpRequestModel(phone: phone));
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? e.message ?? 'Server error',
      );
    }
  }

  @override
  Future<CreateAccountResponseModel> createAccount(
    String phone,
    String nickname,
  ) async {
    try {
      return await _api.createAccount(
        CreateAccountRequestModel(phone: phone, nickname: nickname),
      );
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? e.message ?? 'Server error',
      );
    }
  }
}
