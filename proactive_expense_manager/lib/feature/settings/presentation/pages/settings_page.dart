import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:proactive_expense_manager/core/di/injection_container.dart';
import 'package:proactive_expense_manager/core/extensions/sized_box_extension.dart';
import 'package:proactive_expense_manager/core/router/app_routes.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';
import 'package:proactive_expense_manager/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:proactive_expense_manager/feature/auth/presentation/bloc/auth_event.dart';
import 'package:proactive_expense_manager/feature/auth/presentation/bloc/auth_state.dart';
import 'package:proactive_expense_manager/feature/categories/presentation/bloc/category_bloc.dart';
import 'package:proactive_expense_manager/feature/categories/presentation/bloc/category_event.dart';
import 'package:proactive_expense_manager/feature/settings/presentation/widgets/alert_limit_section.dart';
import 'package:proactive_expense_manager/feature/settings/presentation/widgets/categories_section.dart';
import 'package:proactive_expense_manager/feature/settings/presentation/widgets/cloud_sync_card.dart';
import 'package:proactive_expense_manager/feature/settings/presentation/widgets/nickname_section.dart';
import 'package:proactive_expense_manager/feature/sync/presentation/bloc/sync_bloc.dart';
import 'package:proactive_expense_manager/ui/button/custom_button.dart';
import 'package:proactive_expense_manager/ui/divider/app_divider.dart';
import 'package:proactive_expense_manager/ui/section_header/section_header.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<CategoryBloc>()..add(const LoadCategoriesEvent()),
        ),
        BlocProvider(create: (_) => sl<SyncBloc>()),
        BlocProvider(create: (_) => sl<AuthBloc>()),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoggedOutState) {
            context.go(AppRoutes.onboarding);
          }
        },
        child: const _SettingsView(),
      ),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20.h).copyWith(bottom: 100.h),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Profile & Settings', style: tt.headlineLarge),
                  32.hBox,
                  const SectionHeader(title: 'NICKNAME'),
                  const NicknameSection(),
                  12.hBox,
                ],
              ),
            ),
            AppDivider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: _buildSectionContainer(const AlertLimitSection()),
            ),
            AppDivider(),
            12.hBox,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: 'CATEGORIES'),
                  _buildSectionContainer(const CategoriesSection()),
                  12.hBox,
                ],
              ),
            ),
            AppDivider(),
            12.hBox,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: 'CLOUD SYNC'),
                  _buildSectionContainer(const CloudSyncCard()),
                  16.hBox,
                  CustomButton(
                    height: 52.h,
                    text: 'Log Out',
                    backgroundColor: AppColors.surfaceElevated,
                    borderColor: AppColors.border,
                    textColor: AppColors.errorColor,
                    suffixIcon: Icon(
                      Icons.power_settings_new,
                      color: AppColors.errorColor,
                      size: 20.sp,
                    ),
                    onPressed: () =>
                        context.read<AuthBloc>().add(const LogoutEvent()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContainer(Widget child) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: child,
    );
  }
}
