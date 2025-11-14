import 'package:diagno_bot/core/theming/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isPassword;
  final IconData icon;
  final bool validator;
  final bool isEmail;
  final bool isConfirmPassword;
  final TextEditingController? password;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.validator = true,
    this.isEmail = false,
    this.isConfirmPassword = false,
    this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey.shade300),
      ),

      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0.h, horizontal: 4.0.w),
        child: TextFormField(
          validator:
              validator
                  ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter this field is required';
                    }
                    if (isEmail) {
                      final emailRegex = RegExp(
                        r"^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$",
                      );
                      if (!emailRegex.hasMatch(value.trim()))
                        return "please wright the correct email";
                    }
                    if (isConfirmPassword) {
                      if (password != null) {
                        if (value != password!.text) {
                          return 'Passwords do not match ';
                        }
                      }
                    }

                    return null;
                  }
                  : null,
          controller: controller,
          obscureText: isPassword,
          cursorColor: ColorManager.primaryColor,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            hintStyle: TextStyle(
              fontSize: 13.sp,

              fontWeight: FontWeight.w400,
              color: Colors.grey[400],
            ),
            prefixIcon: Icon(icon, size: 18.w, color: Colors.grey[400]),

            hintText: hint,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
