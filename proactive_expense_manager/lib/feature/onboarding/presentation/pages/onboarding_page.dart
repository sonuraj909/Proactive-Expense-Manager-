import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:proactive_expense_manager/core/bloc/bloc_factory.dart';
import 'package:proactive_expense_manager/core/di/injection_container.dart';
import 'package:proactive_expense_manager/core/extensions/sized_box_extension.dart';
import 'package:proactive_expense_manager/core/router/app_routes.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';
import 'package:proactive_expense_manager/core/services/local_storage_service.dart';
import 'package:proactive_expense_manager/core/utils/app_logger.dart';
import 'package:proactive_expense_manager/feature/onboarding/data/models/onboarding_content_model.dart';
import 'package:proactive_expense_manager/feature/onboarding/presentation/bloc/bloc/onboarding_bloc.dart';
import 'package:proactive_expense_manager/feature/onboarding/presentation/bloc/bloc/onboarding_event.dart';
import 'package:proactive_expense_manager/feature/onboarding/presentation/bloc/bloc/onboarding_state.dart';
import 'package:proactive_expense_manager/gen/assets.gen.dart';
import 'package:proactive_expense_manager/ui/button/custom_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToPreviousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finishOnboarding() async {
    await sl<LocalStorageService>().setOnboardingDone();
    if (!mounted) return;
    context.goNamed(AppRoutes.phoneAuth);
    appLogger.debug("Onboarding complete — navigating to phone auth");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BlocFactory>().create<OnboardingBloc>(),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image(
                image: Assets.images.onboarding.image().image,
                fit: BoxFit.cover,
              ),
            ),

            Positioned.fill(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.transparent, AppColors.black],
                    stops: [0.3251, 1.0],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.transparent, AppColors.black],
                    stops: [0.4403, 1.0],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: const ColoredBox(color: AppColors.overlay35),
            ),

            Positioned(
              top: MediaQuery.of(context).size.height * 0.70,
              left: 0,
              right: 0,
              bottom: 0,
              child: BlocBuilder<OnboardingBloc, OnboardingState>(
                builder: (context, state) {
                  return PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingData.length,
                    onPageChanged: (index) {
                      context.read<OnboardingBloc>().add(
                        OnboardingPageChanged(index),
                      );
                    },
                    itemBuilder: (context, index) {
                      return _buildTextContent(onboardingData[index]);
                    },
                  );
                },
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).size.height * 0.70,
              left: 20.w,
              right: 20.w,
              child: BlocBuilder<OnboardingBloc, OnboardingState>(
                builder: (context, state) {
                  return Row(
                    children: List.generate(
                      onboardingData.length,
                      (index) => Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: state.currentPage >= index
                                ? AppColors.textPrimary
                                : AppColors.textPrimary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              top: 60.h,
              right: 20.w,
              child: BlocBuilder<OnboardingBloc, OnboardingState>(
                builder: (context, state) {
                  if (state.isLastPage) return const SizedBox.shrink();
                  return GestureDetector(
                    onTap: _finishOnboarding,
                    child: Text(
                      'SKIP',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              bottom: 40.h,
              left: 20.w,
              right: 20.w,
              child: BlocBuilder<OnboardingBloc, OnboardingState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      if (!state.isFirstPage) ...[
                        InkWell(
                          onTap: _goToPreviousPage,
                          borderRadius: BorderRadius.circular(50.r),
                          child: Container(
                            width: 56.h,
                            height: 56.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.textPrimary,
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        16.wBox,
                      ],
                      Expanded(
                        child: CustomButton(
                          text: state.isLastPage ? 'Get Started' : 'Next',
                          onPressed: state.isLastPage
                              ? _finishOnboarding
                              : _goToNextPage,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextContent(OnboardingContent content) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          28.hBox,
          Text(content.title, style: Theme.of(context).textTheme.headlineLarge),
          12.hBox,
          Text(
            content.subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
