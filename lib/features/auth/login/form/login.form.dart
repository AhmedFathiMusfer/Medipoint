import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/helpers/appHelper.dart';
import 'package:flutter/material.dart';

class LoginForm {
  final key = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController(
    text: AuthManager().currentUser?.password,
  );
  TextEditingController emailController = TextEditingController(
    text: AuthManager().currentUser?.email,
  );

  get body => {
    'email': emailController.text,
    'password': Apphelper.convertDigitsLang(passwordController.text),
  };

  void clear() {
    emailController.clear();
    passwordController.clear();
  }
}
