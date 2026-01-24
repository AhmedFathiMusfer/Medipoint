import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/cubit/doctorDetails.cubit.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/view/widgets/review_card.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/view/widgets/show_add_review_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewWidget extends StatelessWidget {
  const ReviewWidget({
    super.key,
    required this.review,
    required this.doctorId,
    required this.cubit,
  });

  final Review? review;
  final String doctorId;
  final DoctorDetailsCubit cubit;

  @override
  Widget build(BuildContext context) {
    var doctorDetailsCubit = cubit;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "reviews".tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
            ),
            TextButton(
              onPressed: () {
                context.pushNamed(
                  Routers.doctorReviewsView,
                  arguments: doctorId,
                );
              },
              child: Text(
                'see_all'.tr(),
                style: TextStyle(color: Colors.blue, fontSize: 12.sp),
              ),
            ),
          ],
        ),
        10.verticalSpace,
        if (review != null)
          ReviewCard(
            review: review!,
            onDelete: (id) async {
              await doctorDetailsCubit.deleteReview(id);
            },
            onEdit: (id, content, rating) async {
              await doctorDetailsCubit.updateReview(
                reviewId: id,
                content: content,
                rating: rating,
              );
            },
          )
        else
          Center(
            child: TextButton(
              onPressed: () async {
                showAddReviewSheet(
                  context: context,
                  onSave: (rating, content) async {
                    await doctorDetailsCubit.addReview(
                      rating: rating,
                      content: content,
                    );
                  },
                );
              },
              child: Text(
                'add_review'.tr(),
                style: TextStyle(color: Colors.blue, fontSize: 12.sp),
              ),
            ),
          ),
      ],
    );
  }
}
