import 'package:diagno_bot/core/theming/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OutlineButton extends StatelessWidget {
  final String text;
  final String icon;
  const OutlineButton({super.key, required this.text, required this.icon});
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: Image.asset(icon, height: 20.h, width: 20.w),
      label: Text(
        text,
        style: TextStyle(
          color: ColorManager.primaryColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {},
    );
  }
}
