import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/widgets/simpleButton.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/cubit/doctorDetails.cubit.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/cubit/doctorDetails.state.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/view/widgets/about_section.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/view/widgets/doctor_card.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/view/widgets/single_stat.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/view/widgets/working_hour_widget.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/view/widgets/review_card.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/view/widgets/show_add_review_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDetailsView extends StatelessWidget {
  const DoctorDetailsView({super.key});

  get context => null;

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'doctor_details'.tr(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
          builder: (context, state) {
            return state.maybeMap(
              success: (state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    DoctorCard(doctor: state.doctor),
                    30.verticalSpace,
                    _infoStats(
                      experience: state.doctor.experience,

                      rating: state.doctor.rating.toString(),
                      reviews: state.doctor.reviews.toString(),
                    ),
                    30.verticalSpace,
                    AboutSection(about: state.doctor.about),
                    30.verticalSpace,
                    WorkingHourWidget(workingHours: state.doctor.workingHours),
                    30.verticalSpace,

                    _review(state.doctor.review, state.doctor.userId, context),
                    30.verticalSpace,
                    SimpleButton(
                      onPressed: () {
                        context.pushNamed(
                          Routers.bookingView,
                          arguments: state.doctor,
                        );
                      },
                      text: 'book_appointment'.tr(),
                    ),
                  ],
                );
              },
              orElse: () {
                return Container();
              },
            );
          },
        ),
      ),
    );
  }

  Widget _infoStats({
    String? patients,
    String? experience,
    String? rating,
    String? reviews,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // singleStat(
        //   icon: Icons.people,
        //   number: patients ?? "2,000+",
        //   title: "patients".tr(),
        // ),
        singleStat(
          icon: Icons.star,
          number: experience ?? "1",
          title: "experience".tr(),
        ),
        singleStat(
          icon: Icons.favorite,
          number: rating ?? "0",
          title: "rating".tr(),
        ),
        singleStat(
          icon: Icons.chat,
          number: reviews ?? "0",
          title: "reviews".tr(),
        ),
      ],
    );
  }

  Widget _review(Review? review, String doctorId, BuildContext context) {
    var doctorDetailsCubit = context.read<DoctorDetailsCubit>();
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
                'show'.tr(),
                style: TextStyle(color: Colors.blue, fontSize: 12.sp),
              ),
            ),
          ],
        ),
        10.verticalSpace,
        if (review != null)
          ReviewCard(
            review: review,
            onDelete: (id) async {
              await doctorDetailsCubit.deleteLocalReview(id);
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
                'Add Review'.tr(),
                style: TextStyle(color: Colors.blue, fontSize: 12.sp),
              ),
            ),
          ),
      ],
    );
  }
}
