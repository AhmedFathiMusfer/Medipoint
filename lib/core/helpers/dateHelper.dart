import 'package:easy_localization/easy_localization.dart';

class DateHelper {
  // تحويل النص إلى DateTime
  static DateTime parseTime(String text) {
    return DateTime.parse(text);
  }

  // دالة لحساب أول سبت في الأسبوع الحالي بالنسبة لليوم الحالي
  static DateTime getCurrentWeekStart(DateTime today) {
    // weekday: الاثنين = 1 ... الأحد = 7
    int daysToSaturday = (today.weekday + 1) % 7;
    return today.subtract(Duration(days: daysToSaturday));
  }

  // دالة لحساب أقرب جمعة للأسبوع (نهاية الأسبوع الحالي)
  static DateTime getCurrentWeekEnd(DateTime weekStart) {
    return weekStart.add(Duration(days: 6)); // السبت → الجمعة = +6 أيام
  }

  // دالة لحساب الأسبوع الثاني (السبت القادم → الجمعة بعده)
  static Map<String, DateTime> getNextWeekRange(DateTime today) {
    DateTime nextSaturday = getCurrentWeekStart(today).add(Duration(days: 7));
    DateTime nextFriday = nextSaturday.add(Duration(days: 6));
    return {"start": nextSaturday, "end": nextFriday};
  }
}
