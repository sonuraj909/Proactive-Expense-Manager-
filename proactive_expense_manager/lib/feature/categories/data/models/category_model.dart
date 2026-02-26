import 'package:json_annotation/json_annotation.dart';
import 'package:proactive_expense_manager/feature/categories/domain/entities/category_entity.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  final String id;
  final String name;
  @JsonKey(name: 'is_synced', defaultValue: 0)
  final int isSynced;
  @JsonKey(name: 'is_deleted', defaultValue: 0)
  final int isDeleted;

  const CategoryModel({
    required this.id,
    required this.name,
    this.isSynced = 0,
    this.isDeleted = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  // ── DB map (snake_case column names) ───────────────────────────────────────
  Map<String, dynamic> toDbMap() => {
    'id': id,
    'name': name,
    'is_synced': isSynced,
    'is_deleted': isDeleted,
  };

  factory CategoryModel.fromDbMap(Map<String, dynamic> map) => CategoryModel(
    id: map['id'] as String,
    name: map['name'] as String,
    isSynced: map['is_synced'] as int,
    isDeleted: map['is_deleted'] as int,
  );

  CategoryEntity toEntity() => CategoryEntity(
    id: id,
    name: name,
    isSynced: isSynced == 1,
    isDeleted: isDeleted == 1,
  );

  factory CategoryModel.fromEntity(CategoryEntity e) => CategoryModel(
    id: e.id,
    name: e.name,
    isSynced: e.isSynced ? 1 : 0,
    isDeleted: e.isDeleted ? 1 : 0,
  );
}

// ── API response wrappers ─────────────────────────────────────────────────────

/// Matches the server's GET /categories/ shape, where the id is returned as
/// `category_id` and may be null for entries not yet persisted on the server.
@JsonSerializable()
class RemoteCategoryModel {
  @JsonKey(name: 'category_id')
  final String? id;
  final String name;

  const RemoteCategoryModel({required this.id, required this.name});

  factory RemoteCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteCategoryModelToJson(this);
}

@JsonSerializable()
class CategoriesResponseModel {
  final String status;
  final List<RemoteCategoryModel> categories;

  const CategoriesResponseModel({
    required this.status,
    required this.categories,
  });

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesResponseModelToJson(this);
}

@JsonSerializable()
class AddCategoriesRequestModel {
  final List<Map<String, dynamic>> categories;

  const AddCategoriesRequestModel({required this.categories});

  factory AddCategoriesRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AddCategoriesRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddCategoriesRequestModelToJson(this);
}

@JsonSerializable()
class SyncIdsResponseModel {
  final String status;
  @JsonKey(name: 'synced_ids', defaultValue: [])
  final List<String> syncedIds;

  const SyncIdsResponseModel({required this.status, required this.syncedIds});

  factory SyncIdsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SyncIdsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SyncIdsResponseModelToJson(this);
}

@JsonSerializable()
class DeleteCategoriesRequestModel {
  @JsonKey(name: 'category_id')
  final List<String> ids;

  const DeleteCategoriesRequestModel({required this.ids});

  factory DeleteCategoriesRequestModel.fromJson(Map<String, dynamic> json) =>
      _$DeleteCategoriesRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteCategoriesRequestModelToJson(this);
}

@JsonSerializable()
class DeleteIdsResponseModel {
  final String status;
  @JsonKey(name: 'deleted_ids', defaultValue: [])
  final List<String> deletedIds;

  const DeleteIdsResponseModel({
    required this.status,
    required this.deletedIds,
  });

  factory DeleteIdsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DeleteIdsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteIdsResponseModelToJson(this);
}
