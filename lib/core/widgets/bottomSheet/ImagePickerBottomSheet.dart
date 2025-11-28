import 'dart:ui';

import 'package:diagno_bot/core/widgets/simpleButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void imagePickerBottomSheet({
  required BuildContext context,
  VoidCallback? onSelectCamera,
  VoidCallback? onSelectGallery,
}) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Container(
          height: 170,

          padding: const EdgeInsets.all(16).copyWith(bottom: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: Colors.grey.shade400,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select Image Source',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              SimpleButton(
                text: 'Camera',
                onPressed: () async {
                  if (onSelectCamera != null) {
                    onSelectCamera();
                  }
                },
              ),
              const SizedBox(height: 10),
              SimpleButton(
                text: 'Gallery',
                onPressed: () async {
                  if (onSelectGallery != null) {
                    onSelectGallery();
                  }
                },
              ),
            ],
          ),
        ),
      );
    },
    useSafeArea: true,
    isScrollControlled: false,
    enableDrag: false,
    isDismissible: true,
  );
}
