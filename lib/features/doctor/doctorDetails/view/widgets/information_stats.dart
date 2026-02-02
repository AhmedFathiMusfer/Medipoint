import 'package:diagno_bot/features/doctor/doctorDetails/view/widgets/single_stat.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class InformationStats extends StatelessWidget {
  const InformationStats({
    super.key,
    required this.experience,
    required this.rating,
    required this.reviews,
  });

  final String? experience;
  final String? rating;
  final String? reviews;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SingleStat(
          icon: Icons.star,
          number: experience ?? "1",
          title: "experience".tr(),
        ),
        SingleStat(
          icon: Icons.favorite,
          number: rating ?? "0",
          title: "rating".tr(),
        ),
        SingleStat(
          icon: Icons.chat,
          number: reviews ?? "0",
          title: "reviews".tr(),
        ),
      ],
    );
  }
}
