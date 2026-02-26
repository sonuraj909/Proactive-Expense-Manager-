import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proactive_expense_manager/core/di/injection_container.dart';
import 'package:proactive_expense_manager/core/extensions/sized_box_extension.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';
import 'package:proactive_expense_manager/feature/categories/presentation/bloc/category_bloc.dart';
import 'package:proactive_expense_manager/feature/categories/presentation/bloc/category_event.dart';
import 'package:proactive_expense_manager/feature/dashboard/presentation/widgets/add_fab.dart';
import 'package:proactive_expense_manager/feature/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:proactive_expense_manager/feature/dashboard/presentation/widgets/recent_transactions_section.dart';
import 'package:proactive_expense_manager/ui/divider/app_divider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CategoryBloc>()..add(const LoadCategoriesEvent()),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(
              vertical: 20.h,
            ).copyWith(bottom: 100.h),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: const DashboardHeader(),
              ),
              20.hBox,
              const AppDivider(),
              16.hBox,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: const RecentTransactionsSection(),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 100.h, right: 4.w),
          child: const AddFab(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
