import 'package:proactive_expense_manager/feature/auth/domain/entities/auth_entity.dart';
import 'package:proactive_expense_manager/feature/auth/domain/repositories/auth_repository.dart';

class SendOtpUseCase {
  final AuthRepository _repository;
  const SendOtpUseCase(this._repository);

  Future<OtpResponseEntity> call(String phone) => _repository.sendOtp(phone);
}
