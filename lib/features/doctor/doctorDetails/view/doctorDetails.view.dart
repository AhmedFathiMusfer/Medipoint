import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/helpers/dateHelper.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/theming/color.dart';

import 'package:diagno_bot/core/widgets/simpleButton.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/cubit/doctorDetails.cubit.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/cubit/doctorDetails.state.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/view/widgets/doctor_card.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/view/widgets/single_stat.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/view/widgets/review_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDetailsView extends StatelessWidget {
  const DoctorDetailsView({super.key});

  get context => null;

  @override
  Widget build(BuildContext context) {
    var doctorDetailsCubit = context.read<DoctorDetailsCubit>();
    return BaseView(
      title: 'Doctor Details',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
          builder: (context, state) {
            return state.maybeMap(
              success: (state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    DoctorCard(doctor: state.doctor),
                    30.verticalSpace,
                    _infoStats(
                      experience: state.doctor.experience,
                      rating: state.doctor.rating.toString(),
                      reviews: state.doctor.reviews.toString(),
                    ),
                    30.verticalSpace,
                    _aboutSection(about: state.doctor.about),
                    30.verticalSpace,
                    WorkingHourWidget(workingHours: state.doctor.workingHours),
                    30.verticalSpace,

                    _review(state.doctor.review, state.doctor.userId, context),
                    30.verticalSpace,
                    SimpleButton(
                      onPressed: () {
                        context.pushNamed(
                          Routers.bookingView,
                          arguments: state.doctor,
                        );
                      },
                      text: 'Book Appointment',
                    ),
                  ],
                );
              },
              orElse: () {
                return Container();
              },
            );
          },
        ),
      ),
    );
  }

  Widget _infoStats({
    String? patients,
    String? experience,
    String? rating,
    String? reviews,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        singleStat(
          icon: Icons.people,
          number: patients ?? "2,000+",
          title: "patients",
        ),
        singleStat(
          icon: Icons.star,
          number: experience ?? "10+",
          title: "experience",
        ),
        singleStat(
          icon: Icons.favorite,
          number: rating ?? "5",
          title: "rating",
        ),
        singleStat(
          icon: Icons.chat,
          number: reviews ?? "1,872",
          title: "reviews",
        ),
      ],
    );
  }

  Widget _aboutSection({String? about}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About me",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        10.verticalSpace,
        Text(
          about ??
              "Dr. David Patel, a dedicated cardiologist, brings a wealth of experience…",
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _review(Review? review, String doctorId, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Reviews",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
            ),
            TextButton(
              onPressed: () {
                context.pushNamed(
                  Routers.doctorReviewsView,
                  arguments: doctorId,
                );
              },
              child: Text(
                'show',
                style: TextStyle(color: Colors.blue, fontSize: 12.sp),
              ),
            ),
          ],
        ),
        10.verticalSpace,
        if (review != null)
          ReviewCard(review: review)
        else
          Text("No reviews yet."),
      ],
    );
  }
}

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
          "Working Time",
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
            tabs: const [Tab(text: "this week"), Tab(text: "next week ")],
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
          Padding(padding: const EdgeInsets.all(8.0), child: Text('not found')),
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
