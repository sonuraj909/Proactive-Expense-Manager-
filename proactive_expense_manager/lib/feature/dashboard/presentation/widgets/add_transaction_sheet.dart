import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proactive_expense_manager/core/controllers/nav_bar_controller.dart';
import 'package:proactive_expense_manager/core/extensions/sized_box_extension.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';
import 'package:proactive_expense_manager/feature/categories/domain/entities/category_entity.dart';
import 'package:proactive_expense_manager/feature/categories/presentation/bloc/category_bloc.dart';
import 'package:proactive_expense_manager/feature/categories/presentation/bloc/category_event.dart';
import 'package:proactive_expense_manager/feature/categories/presentation/bloc/category_state.dart';
import 'package:proactive_expense_manager/feature/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:proactive_expense_manager/feature/transactions/presentation/bloc/transaction_event.dart';
import 'package:proactive_expense_manager/ui/button/custom_button.dart';
import 'package:proactive_expense_manager/ui/section_header/section_header.dart';
import 'package:proactive_expense_manager/ui/text_field/custom_text_field.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  static void show(BuildContext context) {
    navBarVisible.value = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<TransactionBloc>()),
          BlocProvider.value(
            value: context.read<CategoryBloc>()
              ..add(const LoadCategoriesEvent()),
          ),
        ],
        child: const AddTransactionSheet(),
      ),
    ).whenComplete(() => navBarVisible.value = true);
  }

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  bool _isExpense = true;
  String _selectedCategoryId = '';
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _titleFocus = FocusNode();
  final _amountFocus = FocusNode();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _titleFocus.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Add Transaction', style: tt.headlineLarge),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text(
                    'Close',
                    style: tt.bodySmall?.copyWith(color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
            24.hBox,
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  _buildToggleOption('Expense', true),
                  _buildToggleOption('Income', false),
                ],
              ),
            ),
            16.hBox,

            CustomTextField(
              controller: _titleController,
              focusNode: _titleFocus,
              hintText: 'Title / Note',
              height: 56.h,
            ),
            12.hBox,

            CustomTextField(
              controller: _amountController,
              focusNode: _amountFocus,
              hintText: 'Amount  ( ₹ )',
              keyboardType: TextInputType.number,
              height: 56.h,
            ),
            20.hBox,

            const SectionHeader(title: 'CATEGORY'),
            8.hBox,
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                final categories = state is CategoryLoaded
                    ? state.categories
                    : <CategoryEntity>[];
                if (categories.isEmpty) {
                  return Text(
                    'No categories. Add one in Settings.',
                    style: tt.bodySmall,
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map(_buildCategoryChip).toList(),
                  ),
                );
              },
            ),
            20.hBox,

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.successColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.successColor.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.textSecondary,
                    size: 18.sp,
                  ),
                  12.wBox,
                  Expanded(
                    child: Text(
                      'Everything you add here is saved only on your device.',
                      style: tt.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            20.hBox,

            CustomButton(text: 'Save', onPressed: _save),
            30.hBox,
          ],
        ),
      ),
    );
  }

  Widget _buildToggleOption(String label, bool isExpense) {
    final isSelected = _isExpense == isExpense;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isExpense = isExpense),
        child: AnimatedContainer(
          height: 56.h,
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.successColor : AppColors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textTertiary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(CategoryEntity category) {
    final isSelected = _selectedCategoryId == category.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategoryId = category.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondary.withValues(alpha: 0.5)
              : AppColors.surfaceVariant.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          category.name,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected ? AppColors.textPrimary : AppColors.textTertiary,
          ),
        ),
      ),
    );
  }

  void _save() {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();
    if (title.isEmpty || amountText.isEmpty || _selectedCategoryId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select a category'),
        ),
      );
      return;
    }
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }
    context.read<TransactionBloc>().add(
      AddTransactionEvent(
        amount: amount,
        note: title,
        type: _isExpense ? 'debit' : 'credit',
        categoryId: _selectedCategoryId,
      ),
    );
    Navigator.of(context).pop();
  }
}
