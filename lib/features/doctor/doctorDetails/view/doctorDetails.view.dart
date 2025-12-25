import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';

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
                    _workingTime(state.doctor.workingHours),
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

  Widget _workingTime(List<WorkingHour> workingHours) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Working Time",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        10.verticalSpace,
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
