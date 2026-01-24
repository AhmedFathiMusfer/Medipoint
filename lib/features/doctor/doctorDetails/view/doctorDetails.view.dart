import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/widgets/simpleButton.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/cubit/doctorDetails.cubit.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/cubit/doctorDetails.state.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/view/widgets/about_section.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/view/widgets/doctor_card.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/view/widgets/information_stats.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/view/widgets/review_widget.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/view/widgets/working_hour_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDetailsView extends StatelessWidget {
  const DoctorDetailsView({super.key});

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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    20.verticalSpace,
                    DoctorCard(doctor: state.doctor),
                    30.verticalSpace,
                    InformationStats(
                      experience: state.doctor.experience,
                      rating: state.doctor.rating.toString(),
                      reviews: state.doctor.reviews.toString(),
                    ),
                    20.verticalSpace,
                    AboutSection(about: state.doctor.about),
                    20.verticalSpace,
                    WorkingHourWidget(workingHours: state.doctor.workingHours),
                    20.verticalSpace,
                    ReviewWidget(
                      review: state.doctor.review,
                      doctorId: state.doctor.userId,
                      cubit: context.read<DoctorDetailsCubit>(),
                    ),
                    20.verticalSpace,
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
}
