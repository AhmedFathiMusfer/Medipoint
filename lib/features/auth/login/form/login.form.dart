import 'package:diagno_bot/core/helpers/appHelper.dart';
import 'package:flutter/material.dart';

class LoginForm {
  final key = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  get body => {
    'email': emailController.text,
    'password': Apphelper.convertDigitsLang(passwordController.text),
  };

  void cear() {
    emailController.clear();
    passwordController.clear();
  }
}
