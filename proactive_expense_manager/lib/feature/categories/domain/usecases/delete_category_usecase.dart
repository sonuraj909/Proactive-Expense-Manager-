import 'package:proactive_expense_manager/feature/categories/domain/repositories/category_repository.dart';

class DeleteCategoryUseCase {
  final CategoryRepository _repository;
  const DeleteCategoryUseCase(this._repository);

  Future<void> call(String id) => _repository.softDeleteCategory(id);
}
