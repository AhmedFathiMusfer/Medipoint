import 'package:cached_network_image/cached_network_image.dart';
import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/widgets/bottomSheet/bottomSheet.dart';
import 'package:diagno_bot/features/profile/index/cubit/profile.cubit.dart';
import 'package:diagno_bot/features/profile/index/cubit/profile.state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with RouteAware {
  @override
  void didPopNext() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var profileCubit = context.read<ProfileCubit>();
    final double avatarSize = 120;
    return BaseView(
      title: 'profile'.tr(),
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          state.whenOrNull(
            EditTheAvatar: (imagePath) async {
              context.pushNamed(Routers.editProfileView);
            },
          );
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  15.verticalSpace,
                  SizedBox(
                    height: avatarSize + 40,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: avatarSize / 2,
                          backgroundColor: Colors.grey[200],
                          backgroundImage:
                              (profileCubit.user?.image != null &&
                                      profileCubit.user!.image!.isNotEmpty)
                                  ? CachedNetworkImageProvider(
                                    '${ApiConstants.rootUrl}${profileCubit.user!.image!}',
                                  )
                                  : AssetImage(
                                        'assets/image/avatar_placeholder.jpg',
                                      )
                                      as ImageProvider,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  Text(
                    profileCubit.user?.fullName ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    profileCubit.user.email ?? '',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 22),
                  Card(
                    elevation: 5,
                    color: Colors.white,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _buildOptionTile(
                          context,
                          Icons.person_outline,
                          'edit_profile'.tr(),
                        ),

                        _divider(),
                        _buildOptionTile(
                          context,
                          Icons.lock_outline,
                          'change_password'.tr(),
                          onTap: () {
                            context.pushNamed(Routers.changePasswordView);
                          },
                        ),

                        _divider(),
                        _buildLogoutTile(context),
                      ],
                    ),
                  ),
                  80.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      color: Colors.grey[200],
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildOptionTile(
    BuildContext context,
    IconData icon,
    String title, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap:
          onTap ??
          () {
            context.pushNamed(Routers.editProfileView);
          },
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      leading: const Icon(Icons.logout_outlined, color: Colors.grey),
      title: Text(
        'log_out'.tr(),
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      onTap: () => _showLogoutSheet(context),
    );
  }

  void _showLogoutSheet(BuildContext context) {
    return bottomSheet(
      context: context,
      title: "logout".tr(),
      buttonTitle: 'yes_logout'.tr(),
      message: "sure_logout".tr(),
      onSave: () {
        AuthManager().logout();
      },
    );
  }
}
