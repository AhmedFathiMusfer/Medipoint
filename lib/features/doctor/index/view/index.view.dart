import 'dart:io';

import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/features/doctor/index/cubit/doctors.cubit.dart';
import 'package:diagno_bot/features/doctor/index/cubit/doctors.state.dart';
import 'package:diagno_bot/features/doctor/index/view/widgets/doctor_card.dart';
import 'package:diagno_bot/features/doctor/index/view/widgets/specialt_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorsView extends StatelessWidget {
  const DoctorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'All Doctors',
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
                if (state.doctors.isEmpty) {
                  return Center(child: Text('not found doctors'));
                }
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
                        child: const TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(Icons.search),
                            hintText: "Search doctor...",
                          ),
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
                                await doctorsCubit.fillterDoctorBySpecialty(
                                  null,
                                );
                              },
                              child: SpecialtChip(
                                text: "All",
                                selected: state.specialtySelected == 'All',
                              ),
                            ),
                            ...state.specialities.map(
                              (specialty) => GestureDetector(
                                onTap: () async {
                                  await doctorsCubit.fillterDoctorBySpecialty(
                                    specialty.name,
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
                        "${state.doctors.length} founds",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      5.verticalSpace,
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
                        // children: [
                        //   ...state.doctors.map(
                        //     (doctor) => DoctorCard(
                        //       name: doctor.fullName,
                        //       speciality: doctor.specialty,
                        //       location: doctor.addressLine1 ?? '',
                        //       rating: 5.0,
                        //       reviews: 10,
                        //       image: doctor.image ?? '',
                        //     ),
                        //   ),
                        // DoctorCard(
                        //   name: "Dr. David Patel",
                        //   speciality: "Cardiologist",
                        //   location: "Cardiology Center, USA",
                        //   rating: 5.0,
                        //   reviews: 1872,
                        //   image: "https://i.pravatar.cc/300?img=60",
                        //   color: Color(0xffF6DFE6),
                        // ),
                        // DoctorCard(
                        //   name: "Dr. Jessica Turner",
                        //   speciality: "Gynecologist",
                        //   location: "Women’s Clinic, Seattle, USA",
                        //   rating: 4.9,
                        //   reviews: 127,
                        //   image: "https://i.pravatar.cc/300?img=47",
                        //   color: Color(0xffFFE7D1),
                        // ),
                        // DoctorCard(
                        //   name: "Dr. Michael Johnson",
                        //   speciality: "Orthopedic Surgery",
                        //   location: "Maple Associates, NY, USA",
                        //   rating: 4.7,
                        //   reviews: 5223,
                        //   image: "https://i.pravatar.cc/300?img=12",
                        //   color: Color(0xffD7F6F1),
                        // ),
                        // ],
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
