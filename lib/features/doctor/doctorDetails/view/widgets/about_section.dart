import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key, required this.about});

  final String? about;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "about_me".tr(),
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
}
