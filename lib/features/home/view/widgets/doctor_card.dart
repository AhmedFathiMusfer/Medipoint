// main.dart
// Flutter app: HomePage UI matching provided design + Cubit (flutter_bloc) + mock API

import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorCard extends StatelessWidget {
  final String fullName;
  final String specialty;
  final String experience;
  final String fees;
  final String imageUrl;

  const DoctorCard({
    super.key,
    required this.fullName,
    required this.specialty,
    required this.experience,
    required this.fees,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routers.doctorDetailsView);
      },
      child: SizedBox(
        width: 260.w,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.r),
                  child: Image.network(
                    imageUrl,
                    width: 60.w,
                    height: 60.h,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            Icon(Icons.person, size: 60.r),
                  ),
                ),
                10.horizontalSpace,
                // معلومات الدكتور
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        specialty,
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                      Text(
                        experience,
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                      5.verticalSpace,
                      Text(
                        'Fees: \$$fees',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16.r, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
