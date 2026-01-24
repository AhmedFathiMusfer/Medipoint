import 'package:diagno_bot/core/model/user.model.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EditProfileForm {
  final UserModel user;

  EditProfileForm({required this.user}) {
    passwordController = TextEditingController(text: user.password);
    emailController = TextEditingController(text: user.email);
    nameController = TextEditingController(text: user.fullName);
    imagePath = user.image ?? '';
    gender = getGender(user.gender);
  }
  final key = GlobalKey<FormState>();
  late TextEditingController passwordController;
  late TextEditingController emailController;
  late TextEditingController nameController;
  late Map gender = genders.first;
  String imagePath = '';

  get body => {
    'id': user.id,
    'email': emailController.text,
    'full_name': nameController.text,
    'gender': gender['id'],
    'role': user.role,
  };
  Future<MultipartFile?> getImageIsChanged(String imagePath) async {
    if (!imagePath.contains('/media/users')) {
      var name = imagePath.split('/').last;
      return await MultipartFile.fromFile(imagePath, filename: name);
    }
    return null;
  }

  get data async {
    final formData = FormData.fromMap({...body});

    var image = await getImageIsChanged(imagePath);
    if (image != null) {
      formData.files.add(
        MapEntry('image', await MultipartFile.fromFile(imagePath)),
      );
    }
    return formData;
  }

  List<Map> genders = [
    {'id': 'G', 'name': "gender".tr()},
    {'id': 'M', 'name': "male".tr()},
    {'id': 'F', 'name': "female".tr()},
  ];
  getGender(String? gander) {
    if (gander != null) {
      return (genders.where((g) => g['id'] == gander).firstOrNull) ??
          genders.first;
    }
    return genders.first;
  }

  void clear() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
  }
}
