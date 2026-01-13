import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/widgets/bottomSheet/ImagePickerBottomSheet.dart';
import 'package:diagno_bot/core/widgets/bottomSheet/bottomSheet.dart';
import 'package:diagno_bot/features/profile/index/cubit/profile.cubit.dart';
import 'package:diagno_bot/features/profile/index/cubit/profile.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    var profileCubit = context.read<ProfileCubit>();
    final double avatarSize = 120;
    return BaseView(
      title: 'Profile',
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          state.whenOrNull(
            EditTheAvatar: (imagePath) {
              context.pushNamed(Routers.editProfileView, arguments: imagePath);
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
                              (AuthManager().currentUser?.image != null &&
                                      AuthManager()
                                          .currentUser!
                                          .image!
                                          .isNotEmpty)
                                  ? CachedNetworkImageProvider(
                                    AuthManager().currentUser!.image!,
                                  )
                                  : AssetImage('assets/avatar_placeholder.png')
                                      as ImageProvider,
                        ),
                        Positioned(
                          bottom: 9,
                          right: MediaQuery.of(context).size.width / 2 - 130,
                          child: Container(
                            width: 30,
                            height: 30,
                            padding: const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[900],
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () async {
                                imagePickerBottomSheet(
                                  context: context,
                                  onSelectCamera: () async {
                                    Navigator.of(context).pop();
                                    await profileCubit.pickImage(
                                      ImageSource.camera,
                                    );
                                  },
                                  onSelectGallery: () async {
                                    Navigator.of(context).pop();
                                    await profileCubit.pickImage(
                                      ImageSource.gallery,
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  Text(
                    AuthManager().currentUser?.fullName ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AuthManager().currentUser?.email ?? '',
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
                          'Edit Profile',
                        ),

                        _divider(),
                        _buildOptionTile(
                          context,
                          Icons.lock_outline,
                          'Change Password',
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

  Widget _buildOptionTile(BuildContext context, IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap ?? () {
        context.pushNamed(Routers.editProfileView);
      },
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      leading: const Icon(Icons.logout_outlined, color: Colors.grey),
      title: const Text(
        'Log Out',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      onTap: () => _showLogoutSheet(context),
    );
  }

  void _showLogoutSheet(BuildContext context) {
    return bottomSheet(
      context: context,
      title: "logout",
      buttonTitle: 'Yes, Logout',
      message: "Are you sure you want to logout?",
      onSave: () {
        AuthManager().logout();
      },
    );
  }
}
