import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await _plugin.initialize(initializationSettings);

    const androidNotificationChannel = AndroidNotificationChannel(
      'air_quality_channel',
      'air quality',
      description: 'Air Quality Notifications',
      importance: Importance.high,
    );

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(androidNotificationChannel);
  }

  static Future<void> showNotification(
      {required String title, required String body}) async {
    const androidDetails = AndroidNotificationDetails(
      'air_quality_channel',
      'Qualidade do Ar',
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    await _plugin.show(0, title, body, notificationDetails);
  }

  Future<void> requestNotificationPermission() async {
    final plugin = FlutterLocalNotificationsPlugin();
    final androidImplementation = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.requestNotificationsPermission();
  }
}
