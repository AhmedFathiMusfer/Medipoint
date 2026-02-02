import 'package:diagno_bot/core/widgets/show_confirm_dialog.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/comments/cubit/comments.cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showDeleteDialog(BuildContext context, int commentId) {
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
