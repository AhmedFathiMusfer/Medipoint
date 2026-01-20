import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/database/tables/comments_tables.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/show_confirm_dialog.dart';
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
                                  color: ColorManager.primaryColor.withOpacity(
                                    0.1,
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
                              onEdit: () => _showEditDialog(context, comment),
                              onDelete:
                                  () => _showDeleteDialog(context, comment.id),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                  if (canAddComment) ...[
                    //  SizedBox(height: 8.h),
                    _AddCommentButton(reviewId: reviewId),
                  ],
                ],
              );
            },
            orElse: () => const SizedBox(),
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, Comment comment) {
    final controller = TextEditingController(text: comment.content);
    final cubit = context.read<CommentsCubit>();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.edit, color: ColorManager.primaryColor),
                SizedBox(width: 8.w),
                Text(
                  'edit_comment'.tr(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: TextField(
              controller: controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'write_your_comment'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: ColorManager.primaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'cancel'.tr(),
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  if (controller.text.trim().isNotEmpty) {
                    await cubit.updateComment(
                      commentId: comment.id,
                      content: controller.text.trim(),
                    );
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                child: Text('save'.tr(), style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  void _showDeleteDialog(BuildContext context, int commentId) {
    final cubit = context.read<CommentsCubit>();

    showConfirmDialog(
      context: context,
      title: 'confirm_delete'.tr(),
      message: 'are_you_sure_delete_comment'.tr(),
      confirmText: 'delete'.tr(),
      confirmColor: Colors.red,
      onConfirm: () async {
        await cubit.deleteComment(commentId);
      },
    );
  }
}

class CommentCard extends StatelessWidget {
  final Comment comment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CommentCard({
    super.key,
    required this.comment,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // User Avatar
              CircleAvatar(
                radius: 16.r,
                backgroundColor: ColorManager.primaryColor.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  size: 18.sp,
                  color: ColorManager.primaryColor,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.content,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Text(
                      _formatDate(comment.createdAt),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getTypeColor(
                    comment.type.name,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _getTypeLabel(comment.type.name),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: _getTypeColor(comment.type.name),
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.grey.shade600,
                  size: 20.sp,
                ),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit,
                              color: ColorManager.primaryColor,
                              size: 18.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text('edit'.tr()),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red, size: 18.sp),
                            SizedBox(width: 8.w),
                            Text(
                              'delete'.tr(),
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
              ),
            ],
          ),
          // SizedBox(height: 8.h),
          // Text(
          //   comment.content,
          //   style: TextStyle(
          //     fontSize: 13.sp,
          //     color: Colors.grey.shade700,
          //     height: 1.4,
          //   ),
          // ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 7) {
        return DateFormat('MMM dd, yyyy').format(date);
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
      return dateStr;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'D':
        return Colors.blue;
      case 'P':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'D':
        return 'doctor'.tr();
      case 'P':
        return 'patient'.tr();
      default:
        return type;
    }
  }
}

class _AddCommentButton extends StatelessWidget {
  final int reviewId;

  const _AddCommentButton({required this.reviewId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showAddCommentDialog(context),
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

  void _showAddCommentDialog(BuildContext context) {
    final controller = TextEditingController();
    final cubit = context.read<CommentsCubit>();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.comment, color: ColorManager.primaryColor),
                SizedBox(width: 8.w),
                Text(
                  'add_comment'.tr(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: TextField(
              controller: controller,
              maxLines: 4,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'write_your_comment'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: ColorManager.primaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'cancel'.tr(),
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  if (controller.text.trim().isNotEmpty) {
                    await cubit.addComment(
                      content: controller.text.trim(),
                      type: CommentType.P, // Patient comment
                    );
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                child: Text('add'.tr(), style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }
}
