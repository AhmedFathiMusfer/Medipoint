import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diagno_bot/core/widgets/TextField.dart';
import 'package:diagno_bot/core/widgets/simpleButton.dart';
import 'package:diagno_bot/features/bookAppointment/view/bookAppointment.view.dart';
import 'package:diagno_bot/features/profile/editProfile/cubit/editProfile.cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _FillProfilePageState();
}

class _FillProfilePageState extends State<EditProfilePage> {
  final String avatarPath =
      '/mnt/data/73b1213f-dfe0-477c-b9fc-2d68d0aa9488.png';

  DateTime? selectedDate;
  String gender = "Gender";

  @override
  Widget build(BuildContext context) {
    var editProfileCubit = context.read<EditProfileCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: ColorManager.primaryColor),
        title: const Text(
          "Fill Your Profile",
          style: TextStyle(
            color: ColorManager.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      editProfileCubit.newImagePath == null
                          ? (editProfileCubit.form.imagePath.isNotEmpty
                              ? CachedNetworkImageProvider(
                                editProfileCubit.form.imagePath,
                              )
                              : null)
                          : FileImage(File(editProfileCubit.newImagePath!)),
                ),
                Positioned(
                  bottom: 5,
                  right: MediaQuery.of(context).size.width / 2 - 110,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xff0D1B2A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            20.verticalSpace,
            CustomTextField(
              hint: 'Name',
              controller: editProfileCubit.form.nameController,
            ),
            15.verticalSpace,
            CustomTextField(
              hint: 'Email',
              isEmail: true,
              controller: editProfileCubit.form.emailController,
            ),
            15.verticalSpace,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: gender,
                  items:
                      ["Gender", "Male", "Female"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (v) => setState(() => gender = v!),
                ),
              ),
            ),
            20.verticalSpace,
            SimpleButton(onPressed: () {}, text: 'Save'),
          ],
        ),
      ),
    );
  }

  void _showCongratsPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => Center(
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xffA8DADC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Congratulations!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  const Text(
                    "Your account is ready to use. You will\nbe redirected to the Home Page in a\nfew seconds...",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),

                  const SizedBox(height: 20),

                  const CircularProgressIndicator(strokeWidth: 2),
                ],
              ),
            ),
          ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }
}
