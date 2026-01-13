import 'package:diagno_bot/core/model/doctor.model.dart';
import 'package:diagno_bot/features/ai/chat/view/widgets/doctor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorsSection extends StatelessWidget {
  final List<DoctorModel> doctors;
  final String specialty;
  const DoctorsSection({
    super.key,
    required this.doctors,
    required this.specialty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recommended Doctors${specialty.isNotEmpty ? " for the $specialty" : ''}",
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
          12.verticalSpace,
          Wrap(
            direction: Axis.horizontal,
            spacing: 8,
            children: [
              ...doctors.map((doctor) {
                return DoctorCard(doctor: doctor);
              }),
            ],
          ),
        ],
      ),
    );
  }
}
