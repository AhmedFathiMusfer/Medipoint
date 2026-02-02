import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/helpers/dateHelper.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkingHourWidget extends StatelessWidget {
  final List<WorkingHour> workingHours;
  const WorkingHourWidget({super.key, required this.workingHours});

  @override
  Widget build(BuildContext context) {
    final thisWeek = _getThisWeek(workingHours);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "working_time".tr(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        12.verticalSpace,
        WorkingWeekList(workingHours: thisWeek),
      ],
    );
  }

  List<WorkingHour> _getThisWeek(List<WorkingHour> allHours) {
    final today = DateTime.now();
    final weekStart = DateHelper.getCurrentWeekStart(today);
    final weekEnd = DateHelper.getCurrentWeekEnd(weekStart);

    return allHours.where((w) {
      final wDate = DateHelper.parseTime(w.startTime);
      return wDate.isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
          wDate.isBefore(weekEnd.add(const Duration(days: 1)));
    }).toList();
  }
}

class WorkingWeekList extends StatelessWidget {
  final List<WorkingHour> workingHours;
  const WorkingWeekList({super.key, required this.workingHours});

  static const List<int> weekDaysOrder = [
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
    DateTime.saturday,
    DateTime.sunday,
  ];

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;

    // Group by weekday number
    final Map<int, List<Map<String, DateTime>>> grouped = {};

    for (final w in workingHours) {
      final start = DateTime.parse(w.startTime);
      final end = DateTime.parse(w.endTime);
      final weekday = start.weekday;

      grouped.putIfAbsent(weekday, () => []);
      grouped[weekday]!.add({'start': start, 'end': end});
    }

    // Sort periods inside each day
    for (final entry in grouped.entries) {
      entry.value.sort((a, b) {
        return a['start']!.compareTo(b['start']!);
      });
    }

    final todayWeekday = DateTime.now().weekday;

    return Column(
      children:
          weekDaysOrder.map((weekday) {
            final periods = grouped[weekday] ?? [];

            final dayName = DateFormat(
              'EEEE',
              locale,
            ).format(_dateForWeekday(weekday));

            final isToday = weekday == todayWeekday;

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Day name
                  if (periods.isNotEmpty) ...[
                    SizedBox(
                      width: 90.w,
                      child: Text(
                        dayName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight:
                              isToday ? FontWeight.w700 : FontWeight.w600,
                          color: isToday ? Colors.green : Colors.black,
                        ),
                      ),
                    ),

                    // Periods
                    Expanded(
                      child: Wrap(
                        spacing: 6.w,
                        runSpacing: 4.h,
                        children:
                            periods.map((period) {
                              final start = DateFormat(
                                'hh:mm a',
                                locale,
                              ).format(period['start']!);

                              final end = DateFormat(
                                'hh:mm a',
                                locale,
                              ).format(period['end']!);

                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isToday
                                          ? ColorManager.primaryColor
                                              .withValues(alpha: 0.08)
                                          : Colors.grey.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  "$start - $end",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
    );
  }

  DateTime _dateForWeekday(int weekday) {
    final now = DateTime.now();
    final diff = weekday - now.weekday;
    return now.add(Duration(days: diff));
  }
}
