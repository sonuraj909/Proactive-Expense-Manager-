import 'package:proactive_expense_manager/feature/auth/domain/repositories/auth_repository.dart';

class CreateAccountUseCase {
  final AuthRepository _repository;
  const CreateAccountUseCase(this._repository);

  Future<String> call(String phone, String nickname) =>
      _repository.createAccount(phone, nickname);
}
