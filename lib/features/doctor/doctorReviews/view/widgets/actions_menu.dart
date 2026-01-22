import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/show_confirm_dialog.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/view/widgets/show_add_review_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionsMenu extends StatelessWidget {
  const ActionsMenu({
    super.key,
    required this.review,
    required this.context,
    required this.onDelete,
    required this.onEdit,
  });

  final Review review;
  final BuildContext context;
  final Future<void> Function(int id) onDelete;
  final Future<void> Function(int id, String? content, int rating) onEdit;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      icon: Icon(
        Icons.more_vert_rounded,
        color: Colors.grey.shade400,
        size: 22.sp,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      onSelected: (value) async {
        if (value == 'edit') {
          showAddReviewSheet(
            context: context,
            existingReview: review,
            onSave: (rating, content) async {
              await onEdit(review.id, content, rating);
            },
          );
        } else if (value == 'delete') {
          showConfirmDialog(
            context: context,
            title: 'delete_review_title'.tr(),
            message: 'delete_review_confirm'.tr(),
            onConfirm: () async {
              await onDelete(review.id);
            },
          );
        }
      },
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(
                    Icons.edit_rounded,
                    color: ColorManager.primaryColor,
                    size: 20.sp,
                  ),
                  SizedBox(width: 10.w),
                  Text('edit'.tr()),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 20.sp),
                  SizedBox(width: 10.w),
                  Text(
                    'delete'.tr(),
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
    );
  }
}
