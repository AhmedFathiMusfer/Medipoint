import 'package:diagno_bot/core/theming/color.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AddReviewSheet extends StatefulWidget {
  final Future<void> Function(int rating, String content) onCreate;
  const AddReviewSheet({super.key, required this.onCreate});

  @override
  State<AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<AddReviewSheet> {
  int rating = 5;
  final controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "add_review".tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: List.generate(
                5,
                (i) => IconButton(
                  icon: Icon(
                    i < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() => rating = i + 1);
                  },
                ),
              ),
            ),
            TextFormField(
              controller: controller,
              maxLines: 3,

              decoration: InputDecoration(
                hintText: "write_your_review".tr(),
                border: OutlineInputBorder(),
              ),
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'please_enter_your_review'.tr()
                          : null,
            ),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: () async {
                if (!_formKey.currentState!.validate()) return;
                await widget.onCreate(rating, controller.text);
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: ColorManager.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "submit".tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
