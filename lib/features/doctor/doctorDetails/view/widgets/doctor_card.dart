import 'package:diagno_bot/core/theming/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key});

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
            child: Image.asset(
              "assets/image/final_on_obourding_image.png",
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          15.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dr. David Patel",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              5.verticalSpace,
              5.verticalSpace,
              Text("Cardiologist"),
              5.verticalSpace,
              Row(
                children: [
                  Icon(Icons.location_on, size: 16),
                  Text(" Golden Cardiology Center"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
