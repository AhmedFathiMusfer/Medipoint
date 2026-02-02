import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/features/recordFiles/files/cubit/file.cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void showRenameDialog(BuildContext context, FileCubit cubit, PatientFile file) {
  final controller = TextEditingController(text: file.name);

  showDialog(
    context: context,
    builder: (_) {
      bool isLoading = false;
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text("rename_file".tr()),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "cancel".tr(),
              style: TextStyle(color: ColorManager.primaryColor),
            ),
          ),
          StatefulBuilder(
            builder: (context, setState) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryColor,
                ),
                onPressed: () async {
                  if (!isLoading) {
                    setState(() => isLoading = true);
                    await cubit.renameFile(file, controller.text.trim());
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
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
                          "save".tr(),
                          style: TextStyle(color: Colors.white),
                        ),
              );
            },
          ),
        ],
      );
    },
  );
}
