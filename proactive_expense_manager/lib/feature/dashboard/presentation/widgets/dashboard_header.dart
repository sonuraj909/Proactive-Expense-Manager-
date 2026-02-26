import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proactive_expense_manager/core/di/injection_container.dart';
import 'package:proactive_expense_manager/core/extensions/sized_box_extension.dart';
import 'package:proactive_expense_manager/core/services/local_storage_service.dart';
import 'package:proactive_expense_manager/feature/dashboard/presentation/widgets/monthly_limit_card.dart';
import 'package:proactive_expense_manager/feature/dashboard/presentation/widgets/summary_card.dart';
import 'package:proactive_expense_manager/feature/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:proactive_expense_manager/feature/transactions/presentation/bloc/transaction_state.dart';
import 'package:shimmer/shimmer.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder<String>(
          valueListenable: sl<LocalStorageService>().nicknameNotifier,
          builder: (context, nickname, _) => Text(
            '👋 Welcome, ${nickname.isNotEmpty ? nickname : 'there'}!',
            style: tt.headlineLarge,
          ),
        ),
        24.hBox,
        const _SummaryCardsRow(),
        20.hBox,
        const MonthlyLimitCard(),
      ],
    );
  }
}

class _SummaryCardsRow extends StatelessWidget {
  const _SummaryCardsRow();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoading || state is TransactionInitial) {
          return Row(
            children: [
              Expanded(child: _ShimmerCard()),
              8.wBox,
              Expanded(child: _ShimmerCard()),
            ],
          );
        }
        double income = 0;
        double expense = 0;
        if (state is TransactionLoaded) {
          income = state.totalIncome;
          expense = state.totalExpense;
        }
        return Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Total Income',
                amount: '₹${income.toStringAsFixed(0)}',
                isIncome: true,
              ),
            ),
            8.wBox,
            Expanded(
              child: SummaryCard(
                title: 'Total Expense',
                amount: '₹${expense.toStringAsFixed(0)}',
                isIncome: false,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[600]!,
      child: Container(
        height: 90.h,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
