import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proactive_expense_manager/core/extensions/sized_box_extension.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final bool isIncome;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      height: 87.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: isIncome
            ? AppColors.incomeCardGradient
            : AppColors.expenseCardGradient,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: tt.titleSmall?.copyWith(color: AppColors.textPrimary),
          ),
          10.hBox,
          Row(
            spacing: 4.w,
            children: [
              Icon(
                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                color: AppColors.textPrimary,
                size: 20.sp,
              ),
              Text(
                amount,
                style: tt.headlineLarge?.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
