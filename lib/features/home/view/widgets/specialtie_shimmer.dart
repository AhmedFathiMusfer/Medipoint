// main.dart
// Flutter app: HomePage UI matching provided design + Cubit (flutter_bloc) + mock API

import 'package:diagno_bot/features/home/view/widgets/shimmer_glowing_circle.dart';
import 'package:flutter/material.dart';

class SpecialtieShimmer extends StatelessWidget {
  const SpecialtieShimmer({super.key});

  @override
  Widget build(BuildContext context) => GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 60,
      mainAxisSpacing: 14,
      childAspectRatio: 0.75,
    ),
    shrinkWrap: true,
    itemCount: 6,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      return ShimmerGlowingCircle(size: 30);
    },
  );
}
