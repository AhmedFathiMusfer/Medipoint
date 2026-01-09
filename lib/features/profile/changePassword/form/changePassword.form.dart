import 'package:diagno_bot/core/helpers/appHelper.dart';
import 'package:flutter/material.dart';

class ChangePasswordForm {
  ChangePasswordForm() {
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  final key = GlobalKey<FormState>();
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  get body => {
    'old_password': Apphelper.convertDigitsLang(oldPasswordController.text),
    'new_password': Apphelper.convertDigitsLang(newPasswordController.text),
  };

  void clear() {
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }
}