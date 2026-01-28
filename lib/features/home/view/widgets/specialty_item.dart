// main.dart
// Flutter app: HomePage UI matching provided design + Cubit (flutter_bloc) + mock API

import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SpecialtyItem extends StatelessWidget {
  final String icon;
  final String title;
  final String specialty;

  const SpecialtyItem({
    super.key,
    required this.icon,
    required this.title,
    required this.specialty,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamedAndRemoveUntil(
          Routers.doctorsView,
          arguments: specialty,
          predicate: (root) => false,
        );
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: CachedNetworkSVGImage(
              icon,
              height: 50,
              width: 50,

              // color: ColorManager.primaryColor,
            ),
          ),
          5.verticalSpace,
          Text(
            title,
            style: TextStyle(fontSize: 12.sp, color: ColorManager.primaryColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
