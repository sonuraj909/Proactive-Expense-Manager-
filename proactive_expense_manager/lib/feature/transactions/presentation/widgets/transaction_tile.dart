import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proactive_expense_manager/core/extensions/sized_box_extension.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';

class TransactionTile extends StatelessWidget {
  final String title;
  final String category;
  final String date;
  final String amount;
  final bool isIncome;
  final IconData icon;
  final VoidCallback? onDelete;

  const TransactionTile({
    super.key,
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.isIncome,
    this.icon = Icons.shopping_cart,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Box
            Container(
              height: 28.w,
              width: 28.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.textDisabled,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: AppColors.textPrimary, size: 16.sp),
            ),
            10.wBox,

            // Title & Category
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: tt.labelMedium),
                  4.hBox,
                  Text(category, style: tt.bodySmall),
                ],
              ),
            ),

            // Date, Amount & Delete
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(date, style: tt.titleSmall),
                4.hBox,
                Text(
                  amount,
                  style: tt.bodyLarge?.copyWith(
                    color: isIncome
                        ? AppColors.successColor
                        : AppColors.errorColor,
                  ),
                ),
              ],
            ),
            8.wBox,
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.delete_rounded,
                color: AppColors.errorColor,
                size: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
