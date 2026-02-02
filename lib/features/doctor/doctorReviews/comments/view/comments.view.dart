import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/comments/view/widgets/add_comment_button.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/comments/view/widgets/comment_card.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/comments/view/widgets/show_delete_dialog.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/comments/view/widgets/show_edit_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/comments.cubit.dart';
import '../cubit/comments.state.dart';

class ReviewComments extends StatelessWidget {
  final int reviewId;
  final bool canAddComment;

  const ReviewComments({
    super.key,
    required this.reviewId,
    this.canAddComment = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              CommentsCubit(db: AppDatabase(), reviewId: reviewId)..loadAll(),
      child: BlocBuilder<CommentsCubit, CommentsState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading:
                () => Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.h),
                    child: CircularProgressIndicator(
                      color: ColorManager.primaryColor,
                      strokeWidth: 2,
                    ),
                  ),
                ),
            success: (comments) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (comments.isNotEmpty) ...[
                    Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Row(
                            children: [
                              Icon(
                                Icons.comment_outlined,
                                size: 18.sp,
                                color: ColorManager.primaryColor,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                'comments'.tr(),
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorManager.primaryColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${comments.length}',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: ColorManager.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        children: [
                          ...comments.map((comment) {
                            return CommentCard(
                              comment: comment,
                              onEdit: () => showEditDialog(context, comment),
                              onDelete:
                                  () => showDeleteDialog(context, comment.id),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                  if (canAddComment) ...[AddCommentButton(reviewId: reviewId)],
                ],
              );
            },
            orElse: () => const SizedBox(),
          );
        },
      ),
    );
  }
}
