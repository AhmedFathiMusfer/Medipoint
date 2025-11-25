import 'package:diagno_bot/core/enum/pages.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/widgets/BottomNavBar/nav_item.dart';
import 'package:diagno_bot/features/profile/index/view/profile.view.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavItem(
            icon: Icons.home_rounded,
            pageRouter: Routers.homeView,
            page: PagesEnum.home,
          ),
          NavItem(
            icon: Icons.people_outlined,
            pageRouter: Routers.doctorsView,
            page: PagesEnum.doctor,
          ),
          NavItem(
            icon: Icons.calendar_month_rounded,
            pageRouter: Routers.bookAppointmentView,
            page: PagesEnum.appointment,
          ),
          NavItem(
            icon: Icons.chat_bubble_rounded,
            pageRouter: Routers.chatView,
            page: PagesEnum.chat,
          ),
        ],
      ),
    );
  }
}
