import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSnackBar {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void show({
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 15.sp),
        ),
        duration: duration,
        backgroundColor: backgroundColor ?? Colors.black87,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  static void success(String message) {
    show(message: message, backgroundColor: Colors.green.withOpacity(0.5));
  }

  static void error(String message) {
    show(
      message: message,
      backgroundColor: const Color.fromARGB(255, 255, 17, 0).withOpacity(0.8),
    );
  }

  static void warning(String message) {
    show(message: message, backgroundColor: Colors.orange);
  }
}
