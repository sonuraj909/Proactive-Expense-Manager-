import 'package:equatable/equatable.dart';
import 'package:proactive_expense_manager/feature/categories/domain/entities/category_entity.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

class CategoryLoaded extends CategoryState {
  final List<CategoryEntity> categories;
  const CategoryLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoryError extends CategoryState {
  final String message;
  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class CategoryDeleteFailed extends CategoryState {
  final List<CategoryEntity> categories;
  final String message;
  const CategoryDeleteFailed(this.categories, this.message);

  @override
  List<Object?> get props => [categories, message];
}
