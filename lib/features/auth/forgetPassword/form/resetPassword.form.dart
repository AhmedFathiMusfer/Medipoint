import 'package:diagno_bot/core/helpers/appHelper.dart';
import 'package:flutter/material.dart';

class ResetPasswordForm {
  ResetPasswordForm() {
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  final key = GlobalKey<FormState>();
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  get body => {
        'new_password': Apphelper.convertDigitsLang(newPasswordController.text),
      };

  void clear() {
    newPasswordController.clear();
    confirmPasswordController.clear();
  }
}
