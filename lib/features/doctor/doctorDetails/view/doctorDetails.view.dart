import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';

import 'package:diagno_bot/core/widgets/simpleButton.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/view/widgets/doctor_card.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/view/widgets/single_stat.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDetailsView extends StatelessWidget {
  const DoctorDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Doctor Details',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            DoctorCard(),
            30.verticalSpace,
            _infoStats(),
            30.verticalSpace,
            _aboutSection(),
            30.verticalSpace,
            _workingTime(),
            30.verticalSpace,
            SimpleButton(
              onPressed: () {
                context.pushNamed(Routers.bookAppointmentView);
              },
              text: 'Book Appointment',
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        singleStat(icon: Icons.people, number: "2,000+", title: "patients"),
        singleStat(icon: Icons.star, number: "10+", title: "experience"),
        singleStat(icon: Icons.favorite, number: "5", title: "rating"),
        singleStat(icon: Icons.chat, number: "1,872", title: "reviews"),
      ],
    );
  }

  Widget _aboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About me",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        10.verticalSpace,
        Text(
          "Dr. David Patel, a dedicated cardiologist, brings a wealth of experience…",
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _workingTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Working Time",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        10.verticalSpace,
        Text(
          "Monday–Friday, 08:00 AM–18:00 PM",
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
