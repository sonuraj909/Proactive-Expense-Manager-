import 'package:proactive_expense_manager/core/error/exceptions.dart';
import 'package:proactive_expense_manager/core/error/failures.dart';
import 'package:proactive_expense_manager/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:proactive_expense_manager/feature/auth/domain/entities/auth_entity.dart';
import 'package:proactive_expense_manager/feature/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;

  const AuthRepositoryImpl(this._remote);

  @override
  Future<OtpResponseEntity> sendOtp(String phone) async {
    try {
      final result = await _remote.sendOtp(phone);
      return OtpResponseEntity(
        otp: result.otp,
        userExists: result.userExists,
        nickname: result.nickname,
        token: result.token,
      );
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }

  @override
  Future<String> createAccount(String phone, String nickname) async {
    try {
      final result = await _remote.createAccount(phone, nickname);
      return result.token;
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
