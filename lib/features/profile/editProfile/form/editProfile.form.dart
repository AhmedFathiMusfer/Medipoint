import 'package:diagno_bot/core/model/user.model.dart';
import 'package:flutter/material.dart';

class EditProfileForm {
  final UserModel user;
  final String? newImagePath;
  EditProfileForm({required this.user, this.newImagePath}) {
    passwordController = TextEditingController(text: user.password);
    emailController = TextEditingController(text: user.email);
    nameController = TextEditingController(text: user.fullName);
    imagePath = newImagePath ?? user.image ?? '';
    gender = user.gender ?? '';
  }
  final key = GlobalKey<FormState>();
  late TextEditingController passwordController;
  late TextEditingController emailController;
  late TextEditingController nameController;
  String gender = '';
  String imagePath = '';

  get body => {
    "User": {
      'email': emailController.text,
      'full_name': nameController.text,
      'Gender': gender,
      'image': imagePath,
      'role': user.role,
    },
  };

  void clear() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
  }
}
