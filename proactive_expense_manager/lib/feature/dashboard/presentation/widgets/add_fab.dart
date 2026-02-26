import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';
import 'package:proactive_expense_manager/feature/dashboard/presentation/widgets/add_transaction_sheet.dart';

class AddFab extends StatelessWidget {
  const AddFab({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AddTransactionSheet.show(context),
      child: Container(
        width: 56.w,
        height: 56.w,
        decoration: const BoxDecoration(
          gradient: AppColors.fabGradient,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.add,
          color: AppColors.textPrimary,
          size: 24.sp,
        ),
      ),
    );
  }
}
