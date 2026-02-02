import 'package:flutter/material.dart';

class SmallBtn extends StatefulWidget {
  final String text;
  final Color bg;
  final Color color;
  final Future<void> Function() onTap;
  const SmallBtn({
    super.key,
    required this.text,
    required this.bg,
    required this.color,
    required this.onTap,
  });

  @override
  SmallBtnState createState() => SmallBtnState();
}

class SmallBtnState extends State<SmallBtn> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          _isLoading
              ? null
              : () async {
                setState(() {
                  _isLoading = true;
                });
                try {
                  await widget.onTap();
                } catch (e) {
                  // هنا ممكن تعالج أي خطأ
                } finally {
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: widget.bg,
          borderRadius: BorderRadius.circular(25),
        ),
        alignment: Alignment.center,
        child:
            _isLoading
                ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                  ),
                )
                : Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }
}
