import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:proactive_expense_manager/core/controllers/nav_bar_controller.dart';
import 'package:proactive_expense_manager/core/di/injection_container.dart';
import 'package:proactive_expense_manager/core/extensions/sized_box_extension.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';
import 'package:proactive_expense_manager/feature/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:proactive_expense_manager/feature/transactions/presentation/bloc/transaction_event.dart';
import 'package:proactive_expense_manager/gen/assets.gen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<TransactionBloc>()..add(const LoadAllTransactionsEvent()),
      child: _MainScaffold(navigationShell: navigationShell),
    );
  }
}

class _MainScaffold extends StatelessWidget {
  const _MainScaffold({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          navigationShell,
          ValueListenableBuilder<bool>(
            valueListenable: navBarVisible,
            builder: (_, visible, child) => AnimatedSlide(
              offset: visible ? Offset.zero : const Offset(0, 1.5),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: child!,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(40.r),
                  border: Border.all(
                    color: AppColors.textPrimary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildNavItem(image: Assets.images.chartPieSlice, index: 0),
                    8.wBox,
                    _buildNavItem(
                      image: Assets.images.arrowsCounterClockwise,
                      index: 1,
                    ),
                    8.wBox,
                    _buildNavItem(
                      image: Assets.images.userCircleGear,
                      index: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }

  Widget _buildNavItem({required AssetGenImage image, required int index}) {
    final isActive = navigationShell.currentIndex == index;
    return GestureDetector(
      onTap: () => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isActive ? AppColors.secondary : AppColors.transparent,
          shape: BoxShape.circle,
        ),
        child: image.image(
          width: 28.sp,
          height: 28.sp,
          color: AppColors.textPrimary,
          colorBlendMode: BlendMode.srcIn,
        ),
      ),
    );
  }
}
