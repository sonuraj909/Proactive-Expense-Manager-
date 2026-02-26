import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proactive_expense_manager/core/utils/app_logger.dart';
import 'package:proactive_expense_manager/feature/categories/domain/entities/category_entity.dart';
import 'package:proactive_expense_manager/feature/categories/domain/usecases/add_category_usecase.dart';
import 'package:proactive_expense_manager/feature/categories/domain/usecases/delete_category_usecase.dart';
import 'package:proactive_expense_manager/feature/categories/domain/usecases/get_categories_usecase.dart';
import 'package:proactive_expense_manager/feature/categories/presentation/bloc/category_event.dart';
import 'package:proactive_expense_manager/feature/categories/presentation/bloc/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUseCase _getCategories;
  final AddCategoryUseCase _addCategory;
  final DeleteCategoryUseCase _deleteCategory;

  CategoryBloc({
    required GetCategoriesUseCase getCategories,
    required AddCategoryUseCase addCategory,
    required DeleteCategoryUseCase deleteCategory,
  })  : _getCategories = getCategories,
        _addCategory = addCategory,
        _deleteCategory = deleteCategory,
        super(const CategoryInitial()) {
    on<LoadCategoriesEvent>(_onLoad);
    on<AddCategoryEvent>(_onAdd);
    on<DeleteCategoryEvent>(_onDelete);
  }

  Future<void> _onLoad(
    LoadCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      final categories = await _getCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      appLogger.error('Load categories error', error: e);
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onAdd(
    AddCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      final current = state is CategoryLoaded
          ? (state as CategoryLoaded).categories
          : <CategoryEntity>[];
      final newCategory = await _addCategory(event.name);
      emit(CategoryLoaded([...current, newCategory]));
    } catch (e) {
      appLogger.error('Add category error', error: e);
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    final current = state is CategoryLoaded
        ? (state as CategoryLoaded).categories
        : state is CategoryDeleteFailed
            ? (state as CategoryDeleteFailed).categories
            : <CategoryEntity>[];
    try {
      await _deleteCategory(event.id);
      final updated = current.where((c) => c.id != event.id).toList();
      emit(CategoryLoaded(updated));
    } catch (e) {
      appLogger.error('Delete category error', error: e);
      final message = e.toString().replaceFirst('Exception: ', '');
      // If state is already CategoryDeleteFailed, BLoC will skip emission of
      // an equal state — the listener won't fire and the snackbar won't show.
      // Emitting CategoryLoaded first guarantees a state change on every retry.
      if (state is CategoryDeleteFailed) emit(CategoryLoaded(current));
      emit(CategoryDeleteFailed(current, message));
    }
  }
}
