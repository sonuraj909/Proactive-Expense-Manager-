import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proactive_expense_manager/core/extensions/sized_box_extension.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';
import 'package:proactive_expense_manager/feature/categories/presentation/bloc/category_bloc.dart';
import 'package:proactive_expense_manager/feature/categories/presentation/bloc/category_event.dart';
import 'package:proactive_expense_manager/feature/categories/presentation/bloc/category_state.dart';
import 'package:proactive_expense_manager/feature/settings/presentation/widgets/category_item.dart';
import 'package:proactive_expense_manager/ui/divider/app_divider.dart';
import 'package:proactive_expense_manager/ui/text_field/custom_text_field.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({super.key});

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _addCategory() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category name cannot be empty')),
      );
      return;
    }
    context.read<CategoryBloc>().add(AddCategoryEvent(name));
    _controller.clear();
    _focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                height: 48.h,
                controller: _controller,
                focusNode: _focus,
                hintText: 'New category name',
              ),
            ),
            12.wBox,
            GestureDetector(
              onTap: _addCategory,
              child: Container(
                height: 48.h,
                width: 48.h,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Icon(Icons.add, color: AppColors.white, size: 20.sp),
                ),
              ),
            ),
          ],
        ),
        16.hBox,
        AppDivider(),
        16.hBox,
        BlocConsumer<CategoryBloc, CategoryState>(
          listener: (context, state) {
            if (state is CategoryDeleteFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is CategoryLoading || state is CategoryInitial) {
              return Column(
                children: List.generate(
                  4,
                  (_) => Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[600]!,
                      child: Container(
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            final categories = state is CategoryLoaded
                ? state.categories
                : state is CategoryDeleteFailed
                    ? state.categories
                    : null;
            if (categories != null) {
              if (categories.isEmpty) {
                return Text(
                  'No categories yet.',
                  style: Theme.of(context).textTheme.bodySmall,
                );
              }
              return Column(
                children: categories
                    .map(
                      (c) => CategoryItem(
                        title: c.name,
                        onDelete: () => context
                            .read<CategoryBloc>()
                            .add(DeleteCategoryEvent(c.id)),
                      ),
                    )
                    .toList(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
