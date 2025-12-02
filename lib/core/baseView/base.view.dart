import 'package:diagno_bot/core/routing/app_router.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/widgets/BottomNavBar/bottom_nav_bar.dart';
import 'package:diagno_bot/core/widgets/CustomAppBar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseView extends StatelessWidget {
  final Widget child;
  final Widget? buildBottomNav;
  final Widget? floatingActionButton;
  final String? title;
  final bool hasAppBar;
  final PreferredSizeWidget? appBar;
  const BaseView({
    super.key,
    required this.child,
    this.buildBottomNav,
    this.floatingActionButton,
    this.appBar,
    this.title,
    this.hasAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hasAppBar ? _buildAppBar(context, title ?? '') : null,
      backgroundColor: Colors.white,
      body: SafeArea(child: child),

      bottomNavigationBar: buildBottomNav ?? BottomNavBar(context: context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          floatingActionButton ?? _buildFloatingActionButton(context),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return SizedBox();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String title) {
    return PreferredSize(
      preferredSize: Size.fromHeight(60.h),
      child: CustomAppBar(
        title: title,
        onProfileTap: () {
          AppRouter.navigatorKey.currentState!.pushNamed(Routers.profileView);
        },
        onNotificationTap: () {},
      ),
    );
  }
}
