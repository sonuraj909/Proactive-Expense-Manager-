// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      note: json['note'] as String,
      type: json['type'] as String,
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String? ?? '',
      isSynced: (json['is_synced'] as num?)?.toInt() ?? 0,
      isDeleted: (json['is_deleted'] as num?)?.toInt() ?? 0,
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'note': instance.note,
      'type': instance.type,
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'is_synced': instance.isSynced,
      'is_deleted': instance.isDeleted,
      'timestamp': instance.timestamp,
    };

RemoteTransactionModel _$RemoteTransactionModelFromJson(
  Map<String, dynamic> json,
) => RemoteTransactionModel(
  id: json['id'] as String,
  amount: (json['amount'] as num).toDouble(),
  note: json['note'] as String,
  type: json['type'] as String,
  category: json['category'] as String,
  timestamp: json['timestamp'] as String,
);

Map<String, dynamic> _$RemoteTransactionModelToJson(
  RemoteTransactionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'amount': instance.amount,
  'note': instance.note,
  'type': instance.type,
  'category': instance.category,
  'timestamp': instance.timestamp,
};

TransactionsResponseModel _$TransactionsResponseModelFromJson(
  Map<String, dynamic> json,
) => TransactionsResponseModel(
  status: json['status'] as String,
  transactions: (json['transactions'] as List<dynamic>)
      .map((e) => RemoteTransactionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TransactionsResponseModelToJson(
  TransactionsResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'transactions': instance.transactions,
};

AddTransactionsRequestModel _$AddTransactionsRequestModelFromJson(
  Map<String, dynamic> json,
) => AddTransactionsRequestModel(
  transactions: (json['transactions'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
);

Map<String, dynamic> _$AddTransactionsRequestModelToJson(
  AddTransactionsRequestModel instance,
) => <String, dynamic>{'transactions': instance.transactions};

DeleteTransactionsRequestModel _$DeleteTransactionsRequestModelFromJson(
  Map<String, dynamic> json,
) => DeleteTransactionsRequestModel(
  ids: (json['ids'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$DeleteTransactionsRequestModelToJson(
  DeleteTransactionsRequestModel instance,
) => <String, dynamic>{'ids': instance.ids};
