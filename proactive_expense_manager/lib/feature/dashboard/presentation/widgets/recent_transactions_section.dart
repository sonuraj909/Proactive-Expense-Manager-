import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:proactive_expense_manager/core/extensions/sized_box_extension.dart';
import 'package:proactive_expense_manager/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:proactive_expense_manager/feature/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:proactive_expense_manager/feature/transactions/presentation/bloc/transaction_event.dart';
import 'package:proactive_expense_manager/feature/transactions/presentation/bloc/transaction_state.dart';
import 'package:proactive_expense_manager/feature/transactions/presentation/widgets/transaction_tile.dart';
import 'package:shimmer/shimmer.dart';

class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Transactions', style: tt.labelMedium),
        16.hBox,
        BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoading || state is TransactionInitial) {
              return _ShimmerList();
            }
            if (state is TransactionLoaded) {
              if (state.transactions.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40.h),
                    child: Text(
                      'No transactions yet.\nTap + to add one!',
                      textAlign: TextAlign.center,
                      style: tt.bodyMedium,
                    ),
                  ),
                );
              }
              final recent = state.transactions.take(10).toList();
              return _TransactionList(transactions: recent);
            }
            if (state is TransactionError) {
              return Text(state.message, style: tt.bodySmall);
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class _TransactionList extends StatelessWidget {
  final List<TransactionEntity> transactions;
  const _TransactionList({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: transactions.map((t) {
        final formatted = DateFormat('d MMM yyyy').format(t.timestamp);
        final amountStr =
            '${t.isCredit ? '+' : '-'}₹${t.amount.toStringAsFixed(0)}';
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: TransactionTile(
            title: t.note,
            category: t.categoryName.isEmpty ? '—' : t.categoryName,
            date: formatted,
            amount: amountStr,
            isIncome: t.isCredit,
            onDelete: () => context.read<TransactionBloc>().add(
              DeleteTransactionEvent(t.id),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (_) => Padding(
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
      ),
    );
  }
}
