import 'package:diagno_bot/core/database/tables/comments_tables.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/comments/cubit/comments.cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showAddCommentDialog(BuildContext context) {
  final controller = TextEditingController();
  final cubit = context.read<CommentsCubit>();
  bool isLoading = false;
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
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
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
              child: Text('cancel'.tr(), style: TextStyle(color: Colors.grey)),
            ),
            StatefulBuilder(
              builder: (context, setState) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    if (isLoading) return;
                    if (controller.text.trim().isNotEmpty) {
                      setState(() {
                        isLoading = true;
                      });
                      await cubit.addComment(
                        content: controller.text.trim(),
                        type: CommentType.P, // Patient comment
                      );
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child:
                      isLoading
                          ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                          : Text(
                            'add'.tr(),
                            style: TextStyle(color: Colors.white),
                          ),
                );
              },
            ),
          ],
        ),
  );
}
