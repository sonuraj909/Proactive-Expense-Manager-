import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';
import 'package:proactive_expense_manager/feature/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:proactive_expense_manager/feature/transactions/presentation/bloc/transaction_event.dart';
import 'package:proactive_expense_manager/feature/transactions/presentation/bloc/transaction_state.dart';
import 'package:proactive_expense_manager/feature/transactions/presentation/widgets/transaction_tile.dart';
import 'package:shimmer/shimmer.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Text(
                'Transactions',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Expanded(
              child: BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  if (state is TransactionLoading ||
                      state is TransactionInitial) {
                    return _buildShimmer();
                  }
                  if (state is TransactionLoaded) {
                    if (state.transactions.isEmpty) {
                      return Center(
                        child: Text(
                          'No transactions yet.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                      ).copyWith(bottom: 100.h),
                      itemCount: state.transactions.length,
                      itemBuilder: (context, index) {
                        final t = state.transactions[index];
                        final formatted =
                            DateFormat('d MMM yyyy').format(t.timestamp);
                        final amountStr =
                            '${t.isCredit ? '+' : '-'}₹${t.amount.toStringAsFixed(0)}';
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: TransactionTile(
                            title: t.note,
                            category: t.categoryName.isEmpty
                                ? '—'
                                : t.categoryName,
                            date: formatted,
                            amount: amountStr,
                            isIncome: t.isCredit,
                            onDelete: () =>
                                context.read<TransactionBloc>().add(
                                  DeleteTransactionEvent(t.id),
                                ),
                          ),
                        );
                      },
                    );
                  }
                  if (state is TransactionError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: 6,
      itemBuilder: (_, __) => Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[600]!,
          child: Container(
            height: 68.h,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }
}
