import 'package:diagno_bot/core/helpers/appHelper.dart';
import 'package:flutter/material.dart';

class RegisterForm {
  final key = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  get body => {
    'full_name': nameController.text,
    'email': emailController.text,
    'role': 'D',
    'password': Apphelper.convertDigitsLang(passwordController.text),
    'password2': Apphelper.convertDigitsLang(confirmPasswordController.text),
  };

  void clear() {
    //  loading.value = false;
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}
