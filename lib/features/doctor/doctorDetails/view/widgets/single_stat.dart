import 'package:diagno_bot/core/theming/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SingleStat extends StatelessWidget {
  const SingleStat({
    super.key,
    required this.icon,
    required this.number,
    required this.title,
  });

  final IconData icon;
  final String number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(icon, size: 30.r, color: ColorManager.primaryColor),
        ),
        10.verticalSpace,
        Text(
          number,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
