import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/comments/view/widgets/show_add_comment_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddCommentButton extends StatelessWidget {
  final int reviewId;

  const AddCommentButton({required this.reviewId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showAddCommentDialog(context),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: ColorManager.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: ColorManager.primaryColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.add_comment_outlined,
              color: ColorManager.primaryColor,
              size: 15.sp,
            ),
            SizedBox(width: 10.w),
            Text(
              'add_comment'.tr(),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: ColorManager.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
