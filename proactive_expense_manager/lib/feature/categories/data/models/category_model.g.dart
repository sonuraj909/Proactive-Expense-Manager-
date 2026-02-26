// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      isSynced: (json['is_synced'] as num?)?.toInt() ?? 0,
      isDeleted: (json['is_deleted'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_synced': instance.isSynced,
      'is_deleted': instance.isDeleted,
    };

RemoteCategoryModel _$RemoteCategoryModelFromJson(
  Map<String, dynamic> json,
) => RemoteCategoryModel(
  id: json['category_id'] as String?,
  name: json['name'] as String,
);

Map<String, dynamic> _$RemoteCategoryModelToJson(
  RemoteCategoryModel instance,
) => <String, dynamic>{
  'category_id': instance.id,
  'name': instance.name,
};

CategoriesResponseModel _$CategoriesResponseModelFromJson(
  Map<String, dynamic> json,
) => CategoriesResponseModel(
  status: json['status'] as String,
  categories: (json['categories'] as List<dynamic>)
      .map((e) => RemoteCategoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CategoriesResponseModelToJson(
  CategoriesResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'categories': instance.categories,
};

AddCategoriesRequestModel _$AddCategoriesRequestModelFromJson(
  Map<String, dynamic> json,
) => AddCategoriesRequestModel(
  categories: (json['categories'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
);

Map<String, dynamic> _$AddCategoriesRequestModelToJson(
  AddCategoriesRequestModel instance,
) => <String, dynamic>{'categories': instance.categories};

SyncIdsResponseModel _$SyncIdsResponseModelFromJson(
  Map<String, dynamic> json,
) => SyncIdsResponseModel(
  status: json['status'] as String,
  syncedIds:
      (json['synced_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
);

Map<String, dynamic> _$SyncIdsResponseModelToJson(
  SyncIdsResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'synced_ids': instance.syncedIds,
};

DeleteCategoriesRequestModel _$DeleteCategoriesRequestModelFromJson(
  Map<String, dynamic> json,
) => DeleteCategoriesRequestModel(
  ids: (json['category_id'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$DeleteCategoriesRequestModelToJson(
  DeleteCategoriesRequestModel instance,
) => <String, dynamic>{'category_id': instance.ids};

DeleteIdsResponseModel _$DeleteIdsResponseModelFromJson(
  Map<String, dynamic> json,
) => DeleteIdsResponseModel(
  status: json['status'] as String,
  deletedIds:
      (json['deleted_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
);

Map<String, dynamic> _$DeleteIdsResponseModelToJson(
  DeleteIdsResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'deleted_ids': instance.deletedIds,
};
