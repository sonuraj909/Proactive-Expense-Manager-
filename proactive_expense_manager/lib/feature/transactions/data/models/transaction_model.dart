import 'package:json_annotation/json_annotation.dart';
import 'package:proactive_expense_manager/feature/transactions/domain/entities/transaction_entity.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel {
  final String id;
  final double amount;
  final String note;
  final String type;
  @JsonKey(name: 'category_id')
  final String categoryId;
  @JsonKey(name: 'category_name', defaultValue: '')
  final String categoryName;
  @JsonKey(name: 'is_synced', defaultValue: 0)
  final int isSynced;
  @JsonKey(name: 'is_deleted', defaultValue: 0)
  final int isDeleted;
  final String timestamp;

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.note,
    required this.type,
    required this.categoryId,
    this.categoryName = '',
    this.isSynced = 0,
    this.isDeleted = 0,
    required this.timestamp,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  // ── DB map (snake_case column names) ─────────────────────────────────────
  Map<String, dynamic> toDbMap() => {
    'id': id,
    'amount': amount,
    'note': note,
    'type': type,
    'category_id': categoryId,
    'is_synced': isSynced,
    'is_deleted': isDeleted,
    'timestamp': timestamp,
  };

  factory TransactionModel.fromDbMap(Map<String, dynamic> map) =>
      TransactionModel(
        id: map['id'] as String,
        amount: (map['amount'] as num).toDouble(),
        note: map['note'] as String,
        type: map['type'] as String,
        categoryId: map['category_id'] as String,
        categoryName: (map['category_name'] as String?) ?? '',
        isSynced: map['is_synced'] as int,
        isDeleted: map['is_deleted'] as int,
        timestamp: map['timestamp'] as String,
      );

  TransactionEntity toEntity() => TransactionEntity(
    id: id,
    amount: amount,
    note: note,
    type: type,
    categoryId: categoryId,
    categoryName: categoryName,
    isSynced: isSynced == 1,
    isDeleted: isDeleted == 1,
    timestamp: DateTime.parse(timestamp),
  );

  factory TransactionModel.fromEntity(TransactionEntity e) => TransactionModel(
    id: e.id,
    amount: e.amount,
    note: e.note,
    type: e.type,
    categoryId: e.categoryId,
    categoryName: e.categoryName,
    isSynced: e.isSynced ? 1 : 0,
    isDeleted: e.isDeleted ? 1 : 0,
    timestamp: e.timestamp.toIso8601String().replaceFirst('T', ' ').split('.').first,
  );
}

// ── API response wrappers ─────────────────────────────────────────────────────

@JsonSerializable()
class RemoteTransactionModel {
  final String id;
  final double amount;
  final String note;
  final String type;
  final String category;
  final String timestamp;

  const RemoteTransactionModel({
    required this.id,
    required this.amount,
    required this.note,
    required this.type,
    required this.category,
    required this.timestamp,
  });

  factory RemoteTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteTransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteTransactionModelToJson(this);
}

@JsonSerializable()
class TransactionsResponseModel {
  final String status;
  final List<RemoteTransactionModel> transactions;

  const TransactionsResponseModel({
    required this.status,
    required this.transactions,
  });

  factory TransactionsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionsResponseModelToJson(this);
}

@JsonSerializable()
class AddTransactionsRequestModel {
  final List<Map<String, dynamic>> transactions;

  const AddTransactionsRequestModel({required this.transactions});

  factory AddTransactionsRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AddTransactionsRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddTransactionsRequestModelToJson(this);
}

@JsonSerializable()
class DeleteTransactionsRequestModel {
  final List<String> ids;

  const DeleteTransactionsRequestModel({required this.ids});

  factory DeleteTransactionsRequestModel.fromJson(Map<String, dynamic> json) =>
      _$DeleteTransactionsRequestModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DeleteTransactionsRequestModelToJson(this);
}
