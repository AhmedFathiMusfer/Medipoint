import 'package:diagno_bot/core/enum/pages.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/stror/appStore.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.icon,
    required this.pageRouter,
    required this.page,
  });
  final IconData icon;
  final String pageRouter;
  final PagesEnum page;

  @override
  Widget build(BuildContext context) {
    final selected = Appstore.instanse.currentPage == page;
    return InkWell(
      onTap: () {
        Appstore.instanse.currentPage = page;
        context.pushNamedAndRemoveUntil(pageRouter, predicate: (root) => false);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: selected ? ColorManager.primaryColor : Colors.grey[700],
          ),
          5.verticalSpace,
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: selected ? ColorManager.primaryColor : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
