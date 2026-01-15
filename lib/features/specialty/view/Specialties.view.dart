import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/features/home/view/widgets/specialtie_shimmer.dart';
import 'package:diagno_bot/features/home/view/widgets/specialty_item.dart';
import 'package:diagno_bot/features/specialty/cubit/specialties.cubit.dart';
import 'package:diagno_bot/features/specialty/cubit/specialties.state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpecialtiesView extends StatelessWidget {
  const SpecialtiesView({super.key});

  @override
  Widget build(BuildContext context) {
    var specialtiesCubit = context.read<SpecialtiesCubit>();
    return BaseView(
      title: 'specialties_title'.tr(),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,

              12.verticalSpace,
              BlocSelector<
                SpecialtiesCubit,
                SpecialtiesState,
                List<Specialty>?
              >(
                selector:
                    (state) => state.maybeMap(
                      success: (s) => s.specialities,
                      orElse: () => null,
                    ),
                builder: (context, specialties) {
                  if (specialties == null || specialties.isEmpty) {
                    return SpecialtieShimmer();
                  }
                  return SizedBox(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.75,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ...specialties.map(
                          (specialty) => SpecialtyItem(
                            title: specialty.name,

                            icon: specialty.icon ?? '',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
