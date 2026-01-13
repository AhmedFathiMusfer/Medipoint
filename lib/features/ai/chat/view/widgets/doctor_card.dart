import 'package:cached_network_image/cached_network_image.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/model/doctor.model.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routers.doctorDetailsView, arguments: doctor.userId);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 10.r),
          decoration: BoxDecoration(
            color: ColorManager.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(
              color: ColorManager.primaryColor.withOpacity(0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50.r),
                child: CachedNetworkImage(
                  imageUrl: doctor.image ?? '',
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                  errorWidget: (context, error, stackTrace) {
                    return Image.asset(
                      width: 20,
                      height: 20,
                      "assets/image/default_doctor_image.jpg",
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              8.horizontalSpace,
              Text(
                doctor.fullName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorManager.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
