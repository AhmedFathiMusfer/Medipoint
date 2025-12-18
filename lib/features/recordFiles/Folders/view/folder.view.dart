import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/app_router.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/TextField.dart';
import 'package:diagno_bot/core/widgets/noData.dart';
import 'package:diagno_bot/features/recordFiles/Folders/cubit/folder.cubit.dart';
import 'package:diagno_bot/features/recordFiles/Folders/cubit/folder.state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PatientFoldersView extends StatelessWidget {
  PatientFoldersView({super.key});

  @override
  Widget build(BuildContext context) {
    var folderCubit = context.read<FolderCubit>();
    return BaseView(
      title: "folders",
      floatingActionButton: BlocBuilder<FolderCubit, FolderState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => SizedBox(),
            success: (_) {
              return FloatingActionButton.extended(
                backgroundColor: ColorManager.primaryColor,
                onPressed: () {
                  showCreateFolderDialog(
                    context: context,
                    onCreate: (name, description) async {
                      await folderCubit.createNewFolder(name, description);
                      return true;
                    },
                  );
                },
                icon: const Icon(
                  Icons.create_new_folder_rounded,
                  color: Colors.white,
                ),
                label: const Text("New", style: TextStyle(color: Colors.white)),
              );
            },
          );
        },
      ),
      child: BlocBuilder<FolderCubit, FolderState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => Nodata(),
            success: (folders) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 12.w,
                          ),
                          hintText: 'Search folder...',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: AnimationLimiter(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(20),
                        separatorBuilder: (_, __) => const SizedBox(height: 15),
                        itemCount: folders.length,
                        itemBuilder: (context, index) {
                          final folder = folders[index];

                          return FolderCard(
                            folder: folder,
                            onTap: (id) {
                              context.pushNamed(
                                Routers.fileView,
                                arguments: id,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class FolderCard extends StatelessWidget {
  final PatientFolder folder;
  final Function(int id) onTap;

  const FolderCard({super.key, required this.folder, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 6),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onTap(folder.id),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 12,
            right: 10,
            left: 10,
            bottom: 12,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open_rounded,
                    size: 30,
                    color: Colors.blue.shade600,
                  ),
                  10.horizontalSpace,
                  Text(
                    folder.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Model - تقدر تربطه مباشرة بـ Drift أو API
class FolderItem {
  final String name;
  final String? description;
  final String createdAt;
  final VoidCallback onTap;
  final VoidCallback onMenuTap;

  FolderItem({
    required this.name,
    required this.createdAt,
    required this.onTap,
    required this.onMenuTap,
    this.description,
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
