import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/features/doctor/index/view/widgets/doctor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorsView extends StatelessWidget {
  const DoctorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'All Doctors',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                  hintText: "Search doctor...",
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _chip("All", true),
                  _chip("General", false),
                  _chip("Cardiologist", false),
                  _chip("Dentist", false),
                  _chip("Pediatrics", false),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "532 founds",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  DoctorCard(
                    name: "Dr. David Patel",
                    speciality: "Cardiologist",
                    location: "Cardiology Center, USA",
                    rating: 5.0,
                    reviews: 1872,
                    image: "https://i.pravatar.cc/300?img=60",
                    color: Color(0xffF6DFE6),
                  ),
                  DoctorCard(
                    name: "Dr. Jessica Turner",
                    speciality: "Gynecologist",
                    location: "Women’s Clinic, Seattle, USA",
                    rating: 4.9,
                    reviews: 127,
                    image: "https://i.pravatar.cc/300?img=47",
                    color: Color(0xffFFE7D1),
                  ),
                  DoctorCard(
                    name: "Dr. Michael Johnson",
                    speciality: "Orthopedic Surgery",
                    location: "Maple Associates, NY, USA",
                    rating: 4.7,
                    reviews: 5223,
                    image: "https://i.pravatar.cc/300?img=12",
                    color: Color(0xffD7F6F1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Custom Filter Button
  Widget _chip(String text, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.black : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
