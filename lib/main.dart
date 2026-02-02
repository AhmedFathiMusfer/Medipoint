import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/di/di.dart' as di;
import 'package:diagno_bot/core/notifaction/notifaction.dart';
import 'package:diagno_bot/core/routing/app_router.dart';
import 'package:diagno_bot/doc_app.dart';
import 'package:diagno_bot/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

// final FlutterLocalNotificationsPlugin notificationsPlugin =
//     FlutterLocalNotificationsPlugin();
// const AndroidNotificationChannel appointmentsChannel =
//     AndroidNotificationChannel(
//       'appointments_channel',
//       'Appointments',
//       description: 'Appointment reminders',
//       importance: Importance.high,
//     );

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Stripe.publishableKey =
      'pk_test_51QpdPwBgmAvGuQnxC2gZl1aESH3myJb17u1PBIftdQWw5AXCUp4BMYl0ZEs8Ii5JXqrYlA38FZlaj9daO1HvGxnE00PJyZNSqS';
  await EasyLocalization.ensureInitialized();
  tz_data.initializeTimeZones();
  await di.init();
  await AuthManager().init();
  await NotificationService.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: DocApp(appRouter: AppRouter()),
    ),
  );
}
