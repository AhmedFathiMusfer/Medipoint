import 'package:diagno_bot/core/enum/pages.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/stror/appStore.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, required this.context});

  final BuildContext context;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  PagesEnum currentPage = Appstore.instanse.currentPage;

  void _onItemTapped(PagesEnum page, String route) {
    Appstore.instanse.currentPage = page;
    context.pushNamedAndRemoveUntil(route, predicate: (root) => false);
  }

  Widget _buildItem({
    required IconData icon,
    required PagesEnum page,
    required String route,
  }) {
    final bool isActive = currentPage == page;

    return GestureDetector(
      onTap: () => _onItemTapped(page, route),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color:
              isActive
                  ? ColorManager.primaryColor.withOpacity(0.12)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 250),
          scale: isActive ? 1.2 : 1.0,
          child: Icon(
            icon,
            size: 26,
            color: isActive ? ColorManager.primaryColor : Colors.grey,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(
            icon: Icons.home_rounded,
            page: PagesEnum.home,
            route: Routers.homeView,
          ),
          _buildItem(
            icon: Icons.people_outlined,
            page: PagesEnum.doctor,
            route: Routers.doctorsView,
          ),
          _buildItem(
            icon: Icons.calendar_month_rounded,
            page: PagesEnum.appointment,
            route: Routers.appointmentView,
          ),
          _buildItem(
            icon: Icons.chat_bubble_rounded,
            page: PagesEnum.chat,
            route: Routers.chatView,
          ),
          _buildItem(
            icon: Icons.folder,
            page: PagesEnum.folder,
            route: Routers.folderView,
          ),
        ],
      ),
    );
  }
}
