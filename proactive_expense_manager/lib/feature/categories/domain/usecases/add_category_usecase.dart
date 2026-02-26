import 'package:proactive_expense_manager/feature/categories/domain/entities/category_entity.dart';
import 'package:proactive_expense_manager/feature/categories/domain/repositories/category_repository.dart';

class AddCategoryUseCase {
  final CategoryRepository _repository;
  const AddCategoryUseCase(this._repository);

  Future<CategoryEntity> call(String name) => _repository.addCategory(name);
}
