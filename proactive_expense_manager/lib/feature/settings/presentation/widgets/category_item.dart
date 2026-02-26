import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final VoidCallback onDelete;

  const CategoryItem({super.key, required this.title, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
          ),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppColors.errorColor.withValues(alpha: 0.1),
                border: Border.all(
                  color: AppColors.errorColor.withValues(alpha: 0.5),
                ),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Icon(
                Icons.delete_outline,
                color: AppColors.errorColor,
                size: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
