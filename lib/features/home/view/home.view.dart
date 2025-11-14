// main.dart
// Flutter app: HomePage UI matching provided design + Cubit (flutter_bloc) + mock API
import 'package:carousel_slider/carousel_options.dart' show CarouselOptions;
import 'package:carousel_slider/carousel_slider.dart' show CarouselSlider;
import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/model/doctor.model.dart';
import 'package:diagno_bot/core/widgets/newsCard.dart';
import 'package:diagno_bot/features/home/cubit/home.cubit.dart';
import 'package:diagno_bot/features/home/cubit/home.state.dart';
import 'package:diagno_bot/features/home/view/widgets/doctor_card.dart';
import 'package:diagno_bot/features/home/view/widgets/doctor_shimmer.dart';
import 'package:diagno_bot/features/home/view/widgets/specialtie_shimmer.dart';
import 'package:diagno_bot/features/home/view/widgets/specialty_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    var homeCubit = context.read<HomeCubit>();
    return BaseView(
      title: 'Home',
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    hintText: 'Search doctor...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CarouselSlider(
                items:
                    homeCubit.news.map((slider) {
                      return NewsCard();
                    }).toList(),
                options: CarouselOptions(
                  height: 200,
                  enlargeCenterPage: true,
                  viewportFraction: 0.88,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                ),
              ),
              20.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    homeCubit.news.asMap().entries.map((entry) {
                      return Container(
                        width: 9,
                        height: 9,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.teal.withOpacity(0.3),
                        ),
                      );
                    }).toList(),
              ),
              24.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Specialties',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See All',
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                  ),
                ],
              ),
              12.verticalSpace,
              BlocSelector<HomeCubit, HomeState, List<Specialty>?>(
                selector:
                    (state) => state.maybeMap(
                      success: (s) => s.specialties,
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
              24.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Doctors',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See All',
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                  ),
                ],
              ),
              12.verticalSpace,
              BlocSelector<HomeCubit, HomeState, List<DoctorModel>?>(
                selector:
                    (state) => state.maybeMap(
                      success: (s) => s.doctors,
                      orElse: () => null,
                    ),
                builder: (context, doctors) {
                  if (doctors == null || doctors.isEmpty) {
                    return DoctorShimmer();
                  }
                  return SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...doctors.map(
                          (doctor) => DoctorCard(
                            fullName: doctor.fullName,
                            imageUrl: doctor.image ?? '',
                            experience: doctor.experience,
                            specialty: doctor.specialty,
                            fees: doctor.fees,
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
