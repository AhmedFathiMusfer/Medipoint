import 'package:flutter/material.dart';

class VerifyCodeForm {
  final key = GlobalKey<FormState>();

  TextEditingController codeController = TextEditingController();

  get body => {
        'code': codeController.text,
      };

  void clear() {
    codeController.clear();
  }
}
