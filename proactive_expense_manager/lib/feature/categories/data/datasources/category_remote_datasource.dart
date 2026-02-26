import 'package:dio/dio.dart';
import 'package:proactive_expense_manager/core/error/exceptions.dart';
import 'package:proactive_expense_manager/core/network/api_service.dart';
import 'package:proactive_expense_manager/feature/categories/data/models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<String>> uploadCategories(List<CategoryModel> categories);
  Future<List<String>> deleteCategories(List<String> ids);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiService _api;
  const CategoryRemoteDataSourceImpl(this._api);

  @override
  Future<List<String>> uploadCategories(List<CategoryModel> categories) async {
    final syncedIds = <String>[];
    for (final category in categories) {
      try {
        await _api.addCategory(category.id, category.name);
        syncedIds.add(category.id);
      } on DioException catch (e) {
        final data = e.response?.data;
        throw ServerException(
          (data is Map ? data['message'] as String? : null) ??
              e.message ??
              'Sync failed',
        );
      }
    }
    return syncedIds;
  }

  @override
  Future<List<String>> deleteCategories(List<String> ids) async {
    final deletedIds = <String>[];
    for (final id in ids) {
      try {
        await _api.deleteCategory(id);
        deletedIds.add(id);
      } on DioException catch (e) {
        // 404 = not on server — treat as deleted so local record is cleaned up
        if (e.response?.statusCode == 404) {
          deletedIds.add(id);
          continue;
        }
        final data = e.response?.data;
        throw ServerException(
          (data is Map ? data['message'] as String? : null) ??
              e.message ??
              'Delete sync failed',
        );
      }
    }
    return deletedIds;
  }
}
