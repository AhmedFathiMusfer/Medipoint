// main.dart
// Flutter app: HomePage UI matching provided design + Cubit (flutter_bloc) + mock API

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerGlowingCircle extends StatelessWidget {
  final double size;

  const ShimmerGlowingCircle({super.key, this.size = 50});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.5),
      highlightColor: Colors.grey,
      period: const Duration(seconds: 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey, // اللون الأساسي للدائرة
        ),
      ),
    );
  }
}
