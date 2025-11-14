import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  final String text;
  bool isLoading = false;
  final VoidCallback onPressed;

  SimpleButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        minimumSize: Size(double.infinity, 50),
        backgroundColor: const Color.fromRGBO(28, 42, 58, 1),
      ),
      child:
          isLoading
              ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
              : Text(text, style: TextStyle(color: Colors.white)),
    );
  }
}
