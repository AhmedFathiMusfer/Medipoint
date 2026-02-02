import 'package:diagno_bot/core/widgets/simpleButton.dart';
import 'package:easy_localization/easy_localization.dart';
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
          height: 200.h,
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
                'select_image_source'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              SimpleButton(
                text: 'camera'.tr(),
                onPressed: () async {
                  if (onSelectCamera != null) {
                    onSelectCamera();
                  }
                },
              ),
              const SizedBox(height: 10),
              SimpleButton(
                text: 'gallery'.tr(),
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
