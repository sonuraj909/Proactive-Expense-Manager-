import 'package:flutter/material.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 2, color: AppColors.border);
  }
}
