import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/view/widgets/add_review_sheet.dart';
import 'package:flutter/material.dart';

void showAddReviewSheet({
  required BuildContext context,
  required Future<void> Function(int rating, String content) onSave,
  Review? existingReview,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return AddReviewSheet(
        onSave: onSave,
        existingReview: existingReview,
      );
    },
  );
}
