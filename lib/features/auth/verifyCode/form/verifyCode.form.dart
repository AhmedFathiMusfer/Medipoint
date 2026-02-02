import 'package:flutter/material.dart';

class VerifyCodeForm {
  final key = GlobalKey<FormState>();

  TextEditingController codeController = TextEditingController();

  get body => {'otp': codeController.text};

  void clear() {
    codeController.clear();
  }
}
