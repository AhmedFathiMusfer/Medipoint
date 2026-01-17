import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/TextField.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// void showCreateFolderDialog({
//   required BuildContext context,
//   required Future<bool> Function(String name, String desc) onCreate,
// }) {
//   final nameController = TextEditingController();
//   final descController = TextEditingController();
//   final formKey = GlobalKey<FormState>();

//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) {
//       bool isLoading = false;

//       return StatefulBuilder(
//         builder: (context, setState) {
//           return Dialog(
//             backgroundColor: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Form(
//                 key: formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "create_new_folder".tr(),
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 18),

//                     CustomTextField(
//                       controller: nameController,
//                       hint: 'name'.tr(),
//                     ),

//                     const SizedBox(height: 14),

//                     // Description
//                     CustomTextField(
//                       controller: descController,
//                       hint: 'description'.tr(),
//                     ),

//                     const SizedBox(height: 22),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: Text(
//                             "cancel".tr(),
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ),
//                         const SizedBox(width: 8),

//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: ColorManager.primaryColor,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 12,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                           ),
//                           onPressed:
//                               isLoading
//                                   ? null
//                                   : () async {
//                                     if (formKey.currentState!.validate()) {
//                                       setState(() => isLoading = true);

//                                       final success = await onCreate(
//                                         nameController.text.trim(),
//                                         descController.text.trim(),
//                                       );

//                                       setState(() => isLoading = false);

//                                       if (success) {
//                                         context.pop();
//                                       }
//                                     }
//                                   },
//                           child:
//                               isLoading
//                                   ? CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 2.5,
//                                   )
//                                   : Text(
//                                     "create".tr(),
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }
void showFolderDialog({
  required BuildContext context,
  required String title,
  required String confirmText,
  required Future<bool> Function(String name, String desc) onSubmit,
  String? initialName,
  String? initialDesc,
}) {
  final nameController = TextEditingController(text: initialName);
  final descController = TextEditingController(text: initialDesc);
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      bool isLoading = false;

      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 18),
                    CustomTextField(
                      controller: nameController,
                      hint: 'name'.tr(),
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: descController,
                      hint: 'description'.tr(),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed:
                              isLoading ? null : () => Navigator.pop(context),
                          child: Text(
                            "cancel".tr(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 8),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primaryColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed:
                              isLoading
                                  ? null
                                  : () async {
                                    if (formKey.currentState!.validate()) {
                                      setState(() => isLoading = true);

                                      final success = await onSubmit(
                                        nameController.text.trim(),
                                        descController.text.trim(),
                                      );

                                      setState(() => isLoading = false);

                                      if (success) {
                                        context.pop();
                                      }
                                    }
                                  },
                          child:
                              isLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  )
                                  : Text(
                                    confirmText,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
