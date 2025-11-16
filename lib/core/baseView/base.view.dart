import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/enum/pages.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/stror/appStore.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseView extends StatelessWidget {
  final Widget child;
  final Widget? buildBottomNav;
  final Widget? floatingActionButton;
  final String? title;
  final bool hasAppBar;
  final PreferredSizeWidget? appBar;
  BaseView({
    super.key,
    required this.child,
    this.buildBottomNav,
    this.floatingActionButton,
    this.appBar,
    this.title,
    this.hasAppBar = true,
  });

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hasAppBar ? _buildAppBar(context, title ?? '') : null,
      backgroundColor: Colors.white,
      body: SafeArea(child: child),

      bottomNavigationBar: buildBottomNav ?? _buildBottomNav(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          floatingActionButton ?? _buildFloatingActionButton(context),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return SizedBox();
  }

  PreferredSizeWidget customAppBar({
    required String title,
    required VoidCallback onProfileTap,
    required VoidCallback onNotificationTap,
  }) {
    return AppBar(
      elevation: 0,
      backgroundColor: ColorManager.primaryColor,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      // ✅ زرار النوتيفيكيشن + البروفايل
      actions: [
        // نوتيفيكيشن
        IconButton(
          onPressed: onNotificationTap,
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.notifications_none, color: Colors.white, size: 28),
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

        // المسافة
        SizedBox(width: 8),

        // بروفايل
        PopupMenuButton<String>(
          icon: CircleAvatar(radius: 18, backgroundColor: Colors.white),
          onSelected: (value) {
            if (value == "profile") {
              // context.pushNamed(Routers.profileView);
            } else if (value == "logout") {
              //  logoutUser();
              AuthManager().logout();
            }
          },
          itemBuilder:
              (context) => [
                const PopupMenuItem(value: "profile", child: Text("profile")),
                const PopupMenuItem(value: "logout", child: Text(" logout")),
              ],
        ),

        SizedBox(width: 12),
      ],

      // ✅ ظل بسيط تحت الأب بار
      shadowColor: Colors.black12,
      surfaceTintColor: Colors.white,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String title) {
    return customAppBar(
      title: title,
      onProfileTap: () {},
      onNotificationTap: () {},
    );
    // return AppBar(
    //   title: Text(title),
    //   centerTitle: true,
    //   backgroundColor: Colors.white,
    //   automaticallyImplyLeading: false,
    // );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: BottomAppBar(
          color: ColorManager.primaryColor,
          elevation: 8,
          shadowColor: Colors.black26,
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
    final isSel = Appstore.instanse.currentPage == page;

    return InkWell(
      onTap: () {
        Appstore.instanse.currentPage = page;
        context.pushNamedAndRemoveUntil(pageRouter, predicate: (root) => false);
      },
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0.h, horizontal: 12.w),
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          tween: Tween<double>(begin: 0, end: isSel ? 1 : 0),
          builder: (context, value, child) {
            final double scale = 1 + (0.15 * value);
            final double translateY = -6 * value;

            return Transform.translate(
              offset: Offset(0, translateY),
              child: Transform.scale(
                scale: scale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ✅ Icon with animation
                    Icon(
                      icon,
                      size: 28,
                      color: isSel ? Colors.white : Colors.white70,
                      shadows:
                          isSel
                              ? [
                                Shadow(
                                  blurRadius: 12,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ]
                              : [],
                    ),

                    const SizedBox(height: 6),

                    // ✅ Indicator (line) with smooth animation
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      height: 4,
                      width: isSel ? 26 : 18,
                      decoration: BoxDecoration(
                        color:
                            isSel
                                ? Colors.white
                                : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow:
                            isSel
                                ? [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ]
                                : [],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
