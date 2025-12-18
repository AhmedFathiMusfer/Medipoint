import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/TextField.dart';
import 'package:diagno_bot/features/recordFiles/files/cubit/file.cubit.dart';
import 'package:diagno_bot/features/recordFiles/files/cubit/file.state.dart';
import 'package:diagno_bot/features/recordFiles/files/view/widgets/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';

class PatientFilesView extends StatelessWidget {
  PatientFilesView({super.key});

  IconData _getFileIcon(String type) {
    switch (type.toLowerCase()) {
      case "pdf":
        return Icons.picture_as_pdf;
      case "image":
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    var fileCubit = context.read<FileCubit>();
    return BaseView(
      title: 'files',
      floatingActionButton: BlocBuilder<FileCubit, FileState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () {
              return SizedBox();
            },
            success: (_) {
              return FloatingActionButton.extended(
                backgroundColor: ColorManager.primaryColor,
                onPressed: () {
                  showCreateFileDialog(
                    context: context,
                    onUpload: (name, type, file) async {
                      await fileCubit.createNewFile(name, file);
                    },
                  );
                },
                icon: const Icon(Icons.file_copy, color: Colors.white),
                label: const Text("New", style: TextStyle(color: Colors.white)),
              );
            },
          );
        },
      ),
      child: BlocBuilder<FileCubit, FileState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () {
              return SizedBox();
            },
            success: (files) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: files.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final file = files[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 14,
                      ),

                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.blue.shade50,
                        child: Icon(
                          _getFileIcon('iamge'),
                          color: Colors.blue,
                          size: 28,
                        ),
                      ),

                      title: Text(
                        file.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      subtitle:
                          file.localPath == null
                              ? const Text(
                                "Not downloaded yet",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              )
                              : const Text(
                                "Downloaded",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                ),
                              ),

                      trailing:
                          file.localPath == null
                              ? IconButton(
                                icon: const Icon(
                                  Icons.download,
                                  color: Colors.blue,
                                ),
                                onPressed: () => {},
                              )
                              : IconButton(
                                icon: const Icon(
                                  Icons.open_in_new,
                                  color: Colors.green,
                                ),
                                onPressed: () => {},
                              ),

                      onTap:
                          file.localPath != null
                              ? () async {
                                await OpenFilex.open(file.localPath!);
                              }
                              : null,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class PatientFileItem {
  final String id;
  final String name;
  final String? localPath;
  final String url;
  final String fileType; // pdf / image / other

  PatientFileItem({
    required this.id,
    required this.name,
    required this.url,
    required this.fileType,
    this.localPath,
  });
}

void showCreateFolderDialog({
  required BuildContext context,
  required Future<bool> Function(String name, String desc) onCreate,
}) {
  final nameController = TextEditingController();
  final descController = TextEditingController();
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
                    const Text(
                      "Create New Folder",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Name
                    CustomTextField(controller: nameController, hint: 'Name'),

                    const SizedBox(height: 14),

                    // Description
                    CustomTextField(
                      controller: descController,
                      hint: 'Description',
                    ),

                    const SizedBox(height: 22),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.black),
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

                                      final success = await onCreate(
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
                                  ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                  : const Text(
                                    "Create",
                                    style: TextStyle(color: Colors.white),
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
