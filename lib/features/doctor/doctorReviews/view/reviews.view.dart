import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/cubit/doctorReviews.cubit.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/cubit/doctorReviews.state.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/view/widgets/review_card.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/view/widgets/show_add_review_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorReviewsView extends StatelessWidget {
  final String doctorId;
  const DoctorReviewsView({super.key, required this.doctorId});
  @override
  Widget build(BuildContext context) {
    var doctorReviewsCubit = context.read<DoctorReviewsCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text("reviews".tr()),
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.white,

        actions: [
          BlocBuilder<DoctorReviewsCubit, DoctorReviewsState>(
            builder: (context, state) {
              return state.maybeWhen(
                success: (reviews) {
                  final myUserId = AuthManager().currentUser!.id;
                  final alreadyReviewed = reviews.any(
                    (r) => r.patientId == myUserId,
                  );

                  if (alreadyReviewed) return const SizedBox();

                  return IconButton(
                    icon: const Icon(Icons.rate_review_outlined),
                    onPressed: () async {
                      showAddReviewSheet(
                        onCreate: (rating, content) async {
                          await doctorReviewsCubit.addReview(
                            rating: rating,
                            content: content,
                          );
                        },
                        context: context,
                      );
                    },
                  );
                },
                orElse: () => const SizedBox(),
              );
            },
          ),
        ],
      ),

      body: BlocBuilder<DoctorReviewsCubit, DoctorReviewsState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => const SizedBox(),
            initial:
                () => const Center(
                  child: CircularProgressIndicator(
                    color: ColorManager.primaryColor,
                  ),
                ),
            loading:
                () => const Center(
                  child: CircularProgressIndicator(
                    color: ColorManager.primaryColor,
                  ),
                ),

            success: (reviews) {
              if (reviews.isEmpty) {
                return Center(child: Text("no_reviews_yet".tr()));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: reviews.length,
                separatorBuilder: (_, __) => 16.verticalSpace,
                itemBuilder: (_, index) {
                  return ReviewCard(review: reviews[index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}
