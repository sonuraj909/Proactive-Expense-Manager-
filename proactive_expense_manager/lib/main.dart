import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proactive_expense_manager/core/database/database_helper.dart';
import 'package:proactive_expense_manager/core/di/injection_container.dart';
import 'package:proactive_expense_manager/core/router/app_router.dart';
import 'package:proactive_expense_manager/core/services/local_storage_service.dart';
import 'package:proactive_expense_manager/core/services/notification_service.dart';
import 'package:proactive_expense_manager/core/theme/app_theme.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  await initDependencies();

  // Reinit DB for the logged-in user so we open the correct per-user file
  final storage = sl<LocalStorageService>();
  if (storage.isLoggedIn()) {
    final phone = storage.getPhone() ?? '';
    if (phone.isNotEmpty) {
      await sl<DatabaseHelper>().reinitForUser(phone);
    }
  }

  // Initialize local notifications after DI is ready
  await sl<NotificationService>().init();

  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => MaterialApp.router(
        title: 'Proactive Expense Manager',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
