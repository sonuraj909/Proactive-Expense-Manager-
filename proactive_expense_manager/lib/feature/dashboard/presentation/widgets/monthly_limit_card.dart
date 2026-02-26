import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proactive_expense_manager/core/di/injection_container.dart';
import 'package:proactive_expense_manager/core/extensions/sized_box_extension.dart';
import 'package:proactive_expense_manager/core/services/local_storage_service.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';
import 'package:proactive_expense_manager/feature/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:proactive_expense_manager/feature/transactions/presentation/bloc/transaction_state.dart';

class MonthlyLimitCard extends StatelessWidget {
  const MonthlyLimitCard({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return ValueListenableBuilder<double>(
      valueListenable: sl<LocalStorageService>().budgetLimitNotifier,
      builder: (context, limit, _) {
        return BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            final expense =
                state is TransactionLoaded ? state.totalExpense : 0.0;
            final progress =
                limit > 0 ? (expense / limit).clamp(0.0, 1.0) : 0.0;
            final remaining = ((1 - progress) * 100).toInt();

            return Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('MONTHLY LIMIT', style: tt.titleSmall),
                  8.hBox,
                  Row(
                    children: [
                      Text(
                        '₹${expense.toStringAsFixed(0)}',
                        style: tt.labelMedium,
                      ),
                      Text(
                        ' / ₹${limit.toStringAsFixed(0)}',
                        style: tt.labelMedium?.copyWith(
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ],
                  ),
                  12.hBox,
                  _ProgressBar(progress: progress),
                  8.hBox,
                  Text('$remaining% Remaining', style: tt.titleSmall),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;

  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 6.h,
          decoration: BoxDecoration(
            color: AppColors.textTertiary,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        FractionallySizedBox(
          widthFactor: progress,
          child: Container(
            height: 6.h,
            decoration: BoxDecoration(
              gradient: AppColors.progressGradient,
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
        ),
      ],
    );
  }
}
