import 'package:diagno_bot/core/theming/color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required Future<void> Function() onConfirm,
  String? confirmText,
  String? cancelText,
  Color confirmColor = Colors.red,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      bool isLoading = false;

      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              cancelText ?? "cancel".tr(),
              style: TextStyle(color: ColorManager.primaryColor),
            ),
          ),

          StatefulBuilder(
            builder: (context, setState) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: confirmColor),
                onPressed:
                    isLoading
                        ? null
                        : () async {
                          setState(() => isLoading = true);
                          await onConfirm();
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                child:
                    isLoading
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                        : Text(
                          confirmText ?? "confirm".tr(),
                          style: const TextStyle(color: Colors.white),
                        ),
              );
            },
          ),
        ],
      );
    },
  );
}
