import 'package:diagno_bot/core/theming/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    required this.onProfileTap,
    required this.onNotificationTap,
  });

  final String title;
  final VoidCallback onProfileTap;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: ColorManager.primaryColor,
        ),
      ),
      actions: [
        IconButton(
          onPressed: onNotificationTap,
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_none,
                color: ColorManager.primaryColor,
                size: 28,
              ),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        10.horizontalSpace,
        GestureDetector(
          onTap: () {
            onProfileTap();
          },
          child: CircleAvatar(
            radius: 18,
            backgroundColor: ColorManager.primaryColor,
            child: Icon(Icons.person, color: Colors.white, size: 24),
          ),
        ),
        10.horizontalSpace,
      ],
      shadowColor: Colors.black12,
      surfaceTintColor: ColorManager.primaryColor,
    );
  }
}
