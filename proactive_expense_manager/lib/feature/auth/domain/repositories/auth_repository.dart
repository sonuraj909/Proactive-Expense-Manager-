import 'package:proactive_expense_manager/feature/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<OtpResponseEntity> sendOtp(String phone);
  Future<String> createAccount(String phone, String nickname);
}
