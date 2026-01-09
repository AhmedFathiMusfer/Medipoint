import 'package:flutter/material.dart';

class ForgetPasswordForm {
  final key = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  get body => {
        'email': emailController.text,
      };

  void clear() {
    emailController.clear();
  }
}
