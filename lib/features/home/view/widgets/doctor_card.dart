// main.dart
// Flutter app: HomePage UI matching provided design + Cubit (flutter_bloc) + mock API

import 'package:cached_network_image/cached_network_image.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorCard extends StatelessWidget {
  final String fullName;
  final String specialty;
  final String experience;
  final String fees;
  final String imageUrl;
  final String id;

  const DoctorCard({
    super.key,
    required this.fullName,
    required this.specialty,
    required this.experience,
    required this.fees,
    required this.imageUrl,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routers.doctorDetailsView, arguments: id);
      },
      child: SizedBox(
        width: 300,
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
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) {
                      return Image.asset(
                        width: 60,
                        height: 60,
                        "assets/image/default_doctor_image.jpg",
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                10.horizontalSpace,
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
                      Row(
                        children: [
                          Text(
                            '${'fees'.tr()}: ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              fees,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      // Text(
                      //   'Fees: \$$fees',
                      //   style: TextStyle(
                      //     fontSize: 14.sp,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
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
