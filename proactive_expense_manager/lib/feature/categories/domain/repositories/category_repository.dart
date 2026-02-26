import 'package:proactive_expense_manager/feature/categories/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getLocalCategories();
  Future<CategoryEntity> addCategory(String name);
  Future<void> softDeleteCategory(String id);
  Future<List<CategoryEntity>> syncDeletedCategories();
  Future<List<CategoryEntity>> syncNewCategories();
}
