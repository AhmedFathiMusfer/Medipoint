import 'package:diagno_bot/features/doctor/doctorReviews/view/widgets/add_review_sheet.dart';
import 'package:flutter/material.dart';

void showAddReviewSheet({
  required BuildContext context,
  required Future<void> Function(int rating, String content) onCreate,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return AddReviewSheet(
        onCreate: (rating, content) async {
          await onCreate(rating, content);
        },
      );
    },
  );
}
