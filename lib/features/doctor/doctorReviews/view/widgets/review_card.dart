import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/comments/view/comments.view.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/view/widgets/actions_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final Future<void> Function(int id) onDelete;
  final Future<void> Function(int id, String? content, int rating) onEdit;
  const ReviewCard({
    super.key,
    required this.review,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final myUserId = AuthManager().currentUser?.id;
    final isMyReview = review.patientId == myUserId;

    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // User Avatar
              CircleAvatar(
                radius: 20.r,
                backgroundColor: ColorManager.primaryColor.withValues(
                  alpha: 0.1,
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: ColorManager.primaryColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              // User Name & Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isMyReview ? "you_label".tr() : "patient_label".tr(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      _formatDate(review.createdAt, context),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              // Rating Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star_rounded, color: Colors.amber, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      '${review.rating}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              if (isMyReview) ...[
                SizedBox(width: 4.w),
                ActionsMenu(
                  review: review,
                  context: context,
                  onDelete: onDelete,
                  onEdit: onEdit,
                ),
              ],
            ],
          ),
          if (review.content != null && review.content!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              review.content!,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
          ],
          SizedBox(height: 5.h),
          ReviewComments(reviewId: review.id, canAddComment: isMyReview),
        ],
      ),
    );
  }

  String _formatDate(String dateStr, BuildContext context) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 7) {
        return DateFormat(
          'MMM dd, yyyy',
          context.locale.languageCode,
        ).format(date);
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ${'ago'.tr()}';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ${'ago'.tr()}';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ${'ago'.tr()}';
      } else {
        return 'just_now'.tr();
      }
    } catch (e) {
      if (dateStr.contains('T')) {
        return dateStr.split('T').first;
      }
      return dateStr;
    }
  }
}
