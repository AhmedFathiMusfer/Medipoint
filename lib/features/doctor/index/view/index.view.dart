import 'dart:io';

import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/widgets/noData.dart';
import 'package:diagno_bot/features/doctor/index/cubit/doctors.cubit.dart';
import 'package:diagno_bot/features/doctor/index/cubit/doctors.state.dart';
import 'package:diagno_bot/features/doctor/index/view/widgets/doctor_card.dart';
import 'package:diagno_bot/features/doctor/index/view/widgets/specialt_chip.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorsView extends StatelessWidget {
  const DoctorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'all_doctors'.tr(),
      child: BlocBuilder<DoctorsCubit, DoctorsState>(
        builder: (context, state) {
          var doctorsCubit = context.read<DoctorsCubit>();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: state.maybeMap(
              loading: (_) {
                return Center(child: CircularProgressIndicator());
              },
              success: (state) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.verticalSpace,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(Icons.search),
                            hintText: "search_doctor".tr(),
                          ),
                          onChanged: (value) async {
                            await doctorsCubit.fillterDoctorBySpecialtyOrName(
                              null,
                              value,
                            );
                          },
                        ),
                      ),
                      16.verticalSpace,
                      SizedBox(
                        height: 38,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await doctorsCubit
                                    .fillterDoctorBySpecialtyOrName(null, null);
                              },
                              child: SpecialtChip(
                                text: "all".tr(),
                                selected: state.specialtySelected == 'All',
                              ),
                            ),
                            ...state.specialities.map(
                              (specialty) => GestureDetector(
                                onTap: () async {
                                  await doctorsCubit
                                      .fillterDoctorBySpecialtyOrName(
                                        specialty.name,
                                        null,
                                      );
                                },
                                child: SpecialtChip(
                                  text: specialty.name,
                                  selected:
                                      state.specialtySelected == specialty.name,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      20.verticalSpace,
                      Text(
                        "${state.doctors.length} ${"founds".tr()}",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      5.verticalSpace,
                      if (state.doctors.isEmpty) Nodata(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: state.doctors.length,
                        itemBuilder: (context, index) {
                          var doctor = state.doctors[index];
                          return DoctorCard(
                            doctor: doctor,
                            name: doctor.fullName,
                            speciality: doctor.specialty,
                            location: doctor.addressLine1 ?? '',
                            rating: 5.0,
                            reviews: 10,
                            image: doctor.image ?? '',
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
              orElse: () {},
            ),
          );
        },
      ),
    );
  }

  // ✅ Custom Filter Button
}
