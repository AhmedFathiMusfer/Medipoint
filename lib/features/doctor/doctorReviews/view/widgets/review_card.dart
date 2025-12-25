import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ⭐ Rating
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < review.rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 18,
              ),
            ),
          ),

          8.verticalSpace,
          if (review.content != null)
            Text(review.content!, style: TextStyle(fontSize: 14.sp)),

          10.verticalSpace,
          Text(
            review.createdAt.split('T').first,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          12.verticalSpace,
          //  _ReviewComments(reviewId: review.id),
        ],
      ),
    );
  }
}
