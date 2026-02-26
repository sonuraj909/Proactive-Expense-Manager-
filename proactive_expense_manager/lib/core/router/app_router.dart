import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:proactive_expense_manager/core/di/injection_container.dart';
import 'package:proactive_expense_manager/core/router/app_routes.dart';
import 'package:proactive_expense_manager/core/services/local_storage_service.dart';
import 'package:proactive_expense_manager/feature/auth/presentation/pages/otp_verification_page.dart';
import 'package:proactive_expense_manager/feature/auth/presentation/pages/phone_auth_page.dart';
import 'package:proactive_expense_manager/feature/auth/presentation/pages/setup_name_page.dart';
import 'package:proactive_expense_manager/feature/dashboard/presentation/pages/dashboard_page.dart';
import 'package:proactive_expense_manager/feature/main/presentation/pages/main_page.dart';
import 'package:proactive_expense_manager/feature/onboarding/presentation/pages/onboarding_page.dart';
import 'package:proactive_expense_manager/feature/settings/presentation/pages/settings_page.dart';
import 'package:proactive_expense_manager/feature/transactions/presentation/pages/transactions_page.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.onboarding,
  debugLogDiagnostics: kDebugMode,
  redirect: (context, state) {
    final storage = sl<LocalStorageService>();
    final isLoggedIn = storage.isLoggedIn();
    final onboardingDone = storage.isOnboardingDone();

    final isGoingToAuth = state.matchedLocation.startsWith('/phone-auth') ||
        state.matchedLocation.startsWith('/otp-verification') ||
        state.matchedLocation.startsWith('/setup-name') ||
        state.matchedLocation.startsWith('/onboarding');

    // If logged in and trying to go to auth screens → redirect to dashboard
    if (isLoggedIn && isGoingToAuth) {
      return AppRoutes.dashboard;
    }

    // If not logged in and not going to auth screens → redirect to onboarding
    if (!isLoggedIn && !isGoingToAuth) {
      return onboardingDone ? AppRoutes.phoneAuth : AppRoutes.onboarding;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      name: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.phoneAuth,
      name: AppRoutes.phoneAuth,
      builder: (context, state) => const PhoneAuthPage(),
    ),
    GoRoute(
      path: AppRoutes.otpVerification,
      name: AppRoutes.otpVerification,
      builder: (context, state) => OtpVerificationPage(
        phoneNumber: state.uri.queryParameters['phoneNumber'] ?? '',
        otp: state.uri.queryParameters['otp'] ?? '',
        userExists:
            state.uri.queryParameters['userExists'] == 'true',
        token: state.uri.queryParameters['token'],
        nickname: state.uri.queryParameters['nickname'],
      ),
    ),
    GoRoute(
      path: AppRoutes.setupName,
      name: AppRoutes.setupName,
      builder: (context, state) => SetupNamePage(
        phone: state.uri.queryParameters['phone'] ?? '',
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              name: AppRoutes.dashboard,
              builder: (context, state) => const DashboardPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.transactions,
              name: AppRoutes.transactions,
              builder: (context, state) => const TransactionsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              name: AppRoutes.settings,
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
