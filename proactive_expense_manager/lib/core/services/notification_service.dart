import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:proactive_expense_manager/core/utils/app_logger.dart';

class NotificationService {
  static const _channelId = 'budget_alerts';
  static const _channelName = 'Budget Alerts';
  static const _channelDesc = 'Alerts when monthly spending exceeds your limit';

  final FlutterLocalNotificationsPlugin _plugin;

  NotificationService(this._plugin);

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);

    // Android 13+ requires runtime permission for POST_NOTIFICATIONS
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.requestNotificationsPermission();

    // Explicitly create the notification channel (Android 8+)
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
    );
    await androidPlugin?.createNotificationChannel(channel);

    appLogger.info('NotificationService initialized');
  }

  Future<void> showBudgetLimitAlert({
    required double totalExpense,
    required double limit,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      1001,
      'Budget Limit Exceeded!',
      'Your monthly expenses (₹${totalExpense.toStringAsFixed(0)}) have exceeded your limit of ₹${limit.toStringAsFixed(0)}.',
      details,
    );
    appLogger.warning('Budget limit notification shown');
  }
}
