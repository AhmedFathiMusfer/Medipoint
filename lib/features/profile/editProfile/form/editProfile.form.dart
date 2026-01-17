import 'dart:convert';

import 'package:diagno_bot/core/model/user.model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class EditProfileForm {
  final UserModel user;

  EditProfileForm({required this.user}) {
    passwordController = TextEditingController(text: user.password);
    emailController = TextEditingController(text: user.email);
    nameController = TextEditingController(text: user.fullName);
    imagePath = user.image ?? '';
    gender = user.gender ?? '';
  }
  final key = GlobalKey<FormState>();
  late TextEditingController passwordController;
  late TextEditingController emailController;
  late TextEditingController nameController;
  String gender = '';
  String imagePath = '';

  get body => {
    'id': user.id,
    'email': emailController.text,
    'full_name': nameController.text,
    'gender': gender,
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
  // get data async {
  //   final formData = FormData.fromMap({...body});

  //   //formData.fromMap();

  //   // formData.files.add(
  //   //   MapEntry('image', await MultipartFile.fromFile(imagePath)),
  //   // );

  //   return formData;
  // }

  void clear() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
  }
}
