import 'package:cached_network_image/cached_network_image.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/model/doctor.model.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorCard extends StatelessWidget {
  final String name, speciality, location, image;
  final double rating;
  final int reviews;
  final DoctorModel doctor;

  const DoctorCard({
    super.key,
    required this.name,
    required this.speciality,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.image,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routers.doctorDetailsView, arguments: doctor.userId);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xffF6DFE6),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  errorWidget: (contex, url, _) {
                    return Image.asset(
                      "assets/image/default_doctor_image.jpg",
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),

            15.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  5.verticalSpace,
                  Text(speciality, style: const TextStyle(color: Colors.grey)),

                  5.verticalSpace,
                  Text(
                    location,
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                  ),

                  5.verticalSpace,

                  Row(
                    children: [
                      Icon(Icons.star, size: 16.r, color: Colors.orange),
                      Text(" $rating"),
                      Text(
                        "  |  $reviews ${"reviews".tr()}",
                        style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
