import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/TextField.dart';
import 'package:diagno_bot/core/widgets/bottomSheet/ImagePickerBottomSheet.dart';
import 'package:diagno_bot/core/widgets/simpleButton.dart';
import 'package:diagno_bot/features/profile/editProfile/cubit/editProfile.cubit.dart';
import 'package:diagno_bot/features/profile/editProfile/cubit/editProfile.state.dart';
import 'package:diagno_bot/features/profile/index/cubit/profile.cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _FillProfilePageState();
}

class _FillProfilePageState extends State<EditProfilePage> {
  final String avatarPath =
      '/mnt/data/73b1213f-dfe0-477c-b9fc-2d68d0aa9488.png';

  DateTime? selectedDate;
  String gender = "";

  @override
  void initState() {
    super.initState();
    gender = "gender".tr();
  }

  @override
  Widget build(BuildContext context) {
    var editProfileCubit = context.read<EditProfileCubit>();
    //  var profileCubit = BlocProvider.of<ProfileCubit>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: ColorManager.primaryColor),
        title: Text(
          "fill_your_profile".tr(),
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
        child: Form(
          key: editProfileCubit.form.key,
          child: Column(
            children: [
              const SizedBox(height: 20),
              BlocListener<EditProfileCubit, EditProfileState>(
                listener: (context, state) {
                  state.maybeMap(
                    success: (value) {
                      // profileCubit.initial();
                      context.pop();
                    },
                    orElse: () {},
                  );
                },
                child: const SizedBox.shrink(),
              ),

              BlocSelector<EditProfileCubit, EditProfileState, String?>(
                selector:
                    (state) => state.maybeMap(
                      changeProfileImage: (s) => s.imagePath,

                      orElse: () {},
                    ),
                builder: (context, filePath) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 160,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[200],
                          backgroundImage:
                              filePath != null
                                  ? FileImage(File(filePath))
                                  : (editProfileCubit.form.imagePath.isNotEmpty
                                      ? CachedNetworkImageProvider(
                                        '${ApiConstants.rootUrl}${editProfileCubit.form.imagePath}',
                                      )
                                      : AssetImage(
                                            'assets/image/avatar_placeholder.jpg',
                                          )
                                          as ImageProvider),
                        ),
                      ),
                      Positioned(
                        bottom: 9,
                        right: MediaQuery.of(context).size.width / 2 - 130,
                        child: Container(
                          width: 30,
                          height: 30,
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: const Color(0xff0D1B2A),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () async {
                              imagePickerBottomSheet(
                                context: context,
                                onSelectCamera: () async {
                                  Navigator.of(context).pop();
                                  await editProfileCubit.pickImage(
                                    ImageSource.camera,
                                  );
                                },
                                onSelectGallery: () async {
                                  Navigator.of(context).pop();
                                  await editProfileCubit.pickImage(
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
                  );
                },
              ),

              20.verticalSpace,
              CustomTextField(
                hint: 'name'.tr(),
                controller: editProfileCubit.form.nameController,
              ),
              15.verticalSpace,
              CustomTextField(
                hint: 'email'.tr(),
                isEmail: true,
                controller: editProfileCubit.form.emailController,
              ),
              15.verticalSpace,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: gender,
                    isExpanded: true,
                    dropdownColor: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12), // 🔥 مهم
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items:
                        ["gender".tr(), "male".tr(), "female".tr()]
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    e,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (v) => setState(() => gender = v!),
                  ),
                ),
              ),

              20.verticalSpace,
              BlocSelector<EditProfileCubit, EditProfileState, bool>(
                selector:
                    (state) => state.maybeMap(
                      loading: (s) => s.loading,
                      orElse: () => false,
                    ),
                builder: (context, isloading) {
                  return SimpleButton(
                    isLoading: isloading,
                    onPressed: () async {
                      await editProfileCubit.save();
                    },
                    text: 'save'.tr(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
