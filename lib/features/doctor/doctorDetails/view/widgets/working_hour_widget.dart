import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/helpers/dateHelper.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkingHourWidget extends StatefulWidget {
  final List<WorkingHour> workingHours;
  const WorkingHourWidget({super.key, required this.workingHours});
  @override
  State<StatefulWidget> createState() => _WorkingHourWidgetState();
}

class _WorkingHourWidgetState extends State<WorkingHourWidget>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      if (!controller.indexIsChanging && mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var workingHours = splitWeeks(widget.workingHours);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          "working_time".tr(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        10.verticalSpace,
        Container(
          height: 50.h,
          color: Colors.white,
          child: TabBar(
            tabAlignment: TabAlignment.center,
            labelColor: ColorManager.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: ColorManager.primaryColor,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            controller: controller,
            tabs: [Tab(text: "this_week".tr()), Tab(text: "next_week".tr())],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: SizedBox(
            height:
                controller.index == 0
                    ? calculateHeight(workingHours['thisWeek']!)
                    : calculateHeight(workingHours['nextWeek']!),
            child: TabBarView(
              controller: controller,

              children: [
                _workingTime(workingHours['thisWeek']!),
                _workingTime(workingHours['nextWeek']!),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _workingTime(List<WorkingHour> workingHours) {
    if (workingHours.isEmpty) {
      return SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.verticalSpace,
        if (workingHours.isEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('not_found'.tr()),
          ),
        ...workingHours.map((workingHour) {
          final startTime = DateTime.parse(workingHour.startTime);
          final endTime = DateTime.parse(workingHour.endTime);
          final day = DateFormat('EEEE').format(startTime);
          final firstHour = DateFormat('hh:mm a').format(startTime);
          final endHour = DateFormat('hh:mm a').format(endTime);
          return Text(
            "$day, $firstHour–$endHour",
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
          );
        }),
      ],
    );
  }

  Map<String, List<WorkingHour>> splitWeeks(List<WorkingHour> allHours) {
    final today = DateTime.now();

    final week1Start = DateHelper.getCurrentWeekStart(today);
    final week1End = DateHelper.getCurrentWeekEnd(week1Start);

    final nextWeekRange = DateHelper.getNextWeekRange(today);
    final week2Start = nextWeekRange["start"]!;
    final week2End = nextWeekRange["end"]!;
    final thisWeek =
        allHours.where((w) {
          final wDate = DateHelper.parseTime(w.startTime);
          return wDate.isAfter(week1Start.subtract(Duration(seconds: 1))) &&
              wDate.isBefore(week1End.add(Duration(days: 1)));
        }).toList();
    final secondWeek =
        allHours.where((w) {
          final wDate = DateHelper.parseTime(w.startTime);
          return wDate.isAfter(week2Start.subtract(Duration(seconds: 1))) &&
              wDate.isBefore(week2End.add(Duration(days: 1)));
        }).toList();

    return {"thisWeek": thisWeek, "nextWeek": secondWeek};
  }

  double calculateHeight(List<WorkingHour> hours) {
    if (hours.isEmpty) return 0;

    const double rowHeight = 27;
    const double verticalPadding = 10;

    return ((hours.length * rowHeight) + verticalPadding).h;
  }
}
