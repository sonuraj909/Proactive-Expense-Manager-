import 'package:proactive_expense_manager/feature/categories/domain/entities/category_entity.dart';
import 'package:proactive_expense_manager/feature/categories/domain/repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository _repository;
  const GetCategoriesUseCase(this._repository);

  Future<List<CategoryEntity>> call() => _repository.getLocalCategories();
}
