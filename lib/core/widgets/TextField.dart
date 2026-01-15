import 'package:diagno_bot/core/theming/color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final bool isPassword;
  final IconData? icon;
  final bool validator;
  final bool isEmail;
  final bool isConfirmPassword;
  final TextEditingController? password;

  const CustomTextField({
    super.key,
    this.controller,
    required this.hint,
    this.icon,
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
        padding: EdgeInsets.symmetric(
          vertical: 6.0.h,
          horizontal: icon != null ? 4.0.w : 8.0.w,
        ),
        child: TextFormField(
          validator:
              validator
                  ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'field_required'.tr();
                    }
                    if (isEmail) {
                      final emailRegex = RegExp(
                        r"^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$",
                      );
                      if (!emailRegex.hasMatch(value.trim()))
                        return "email_invalid".tr();
                    }
                    if (isConfirmPassword) {
                      if (password != null) {
                        if (value != password!.text) {
                          return 'passwords_not_match'.tr();
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
            prefixIcon:
                icon != null
                    ? Icon(icon, size: 18.w, color: Colors.grey[400])
                    : null,

            hintText: hint,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
