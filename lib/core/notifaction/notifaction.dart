import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);

    await _notificationsPlugin.initialize(initializationSettings);
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();
  }

  static Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'scheduled_channel_id',
          'Scheduled Notifications',
          channelDescription: 'Channel for scheduled notifications',
          importance: Importance.high,
          priority: Priority.high,
          ticker: ' scheduled notification',
        );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> scheduleAppointmentNotification({
    required int id,
    required DateTime appointmentTime,
    int minutesBefore = 10,
  }) async {
    await NotificationService.init();
    final scheduledTime = appointmentTime.subtract(
      Duration(minutes: minutesBefore),
    );
    if (scheduledTime.isBefore(DateTime.now())) {
      debugPrint(
        '❌ Scheduled time is in the past. Notification not scheduled.',
      );
      return;
    }
    final tzScheduled = tz.TZDateTime.from(scheduledTime, tz.local);

    await _notificationsPlugin.zonedSchedule(
      id,
      '⏰ تذكير بالموعد',
      'موعدك بعد $minutesBefore دقائق',
      tzScheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'appointments_channel',
          'Appointments',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'Appointments notification',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    debugPrint('✅ Notification scheduled successfully');
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}
