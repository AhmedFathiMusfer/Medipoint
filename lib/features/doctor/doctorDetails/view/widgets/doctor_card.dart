import 'package:cached_network_image/cached_network_image.dart';
import 'package:diagno_bot/core/model/doctor.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: CachedNetworkImage(
              imageUrl: doctor.image ?? '',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorWidget: (contex, url, _) {
                return Image.asset(
                  "assets/image/default_doctor_image.jpg",
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          15.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor.fullName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              5.verticalSpace,
              5.verticalSpace,
              Text(doctor.specialty),
              5.verticalSpace,
              Row(
                children: [
                  Icon(Icons.location_on, size: 16),
                  Text(doctor.addressLine1 ?? doctor.addressLine2 ?? ""),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
