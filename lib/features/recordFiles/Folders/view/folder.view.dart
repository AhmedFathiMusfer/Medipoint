import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/noData.dart';
import 'package:diagno_bot/features/folderSharing/cubit/folder_sharing.cubit.dart';
import 'package:diagno_bot/features/folderSharing/view/widgets/select_doctor_dialog.dart';
import 'package:diagno_bot/features/folderSharing/view/widgets/shared_doctors_dialog.dart';
import 'package:diagno_bot/features/recordFiles/Folders/cubit/folder.cubit.dart';
import 'package:diagno_bot/features/recordFiles/Folders/cubit/folder.state.dart';
import 'package:diagno_bot/features/recordFiles/Folders/view/widegts/folder_card.dart';
import 'package:diagno_bot/features/recordFiles/Folders/view/widegts/show_create_folder_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PatientFoldersView extends StatelessWidget {
  const PatientFoldersView({super.key});

  @override
  Widget build(BuildContext context) {
    var folderCubit = context.read<FolderCubit>();
    return BaseView(
      title: "folders".tr(),
      floatingActionButton: BlocBuilder<FolderCubit, FolderState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => SizedBox(),
            success: (_) {
              return FloatingActionButton.extended(
                backgroundColor: ColorManager.primaryColor,
                onPressed: () {
                  // showCreateFolderDialog(
                  //   context: context,
                  //   onCreate: (name, description) async {
                  //     await folderCubit.createNewFolder(name, description);
                  //     return true;
                  //   },
                  // );
                  showFolderDialog(
                    context: context,
                    title: 'create_new_folder'.tr(),
                    confirmText: 'create'.tr(),
                    onSubmit: (name, desc) async {
                      await folderCubit.createNewFolder(name, desc);
                      return true;
                    },
                  );
                },
                icon: const Icon(
                  Icons.create_new_folder_rounded,
                  color: Colors.white,
                ),
                label: Text("new".tr(), style: TextStyle(color: Colors.white)),
              );
            },
          );
        },
      ),
      child: BlocBuilder<FolderCubit, FolderState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => Nodata(),
            loading: () {
              return Center(
                child: CircularProgressIndicator(
                  color: ColorManager.primaryColor,
                ),
              );
            },
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
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 12.w,
                          ),
                          hintText: 'search_folder'.tr(),
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                        onChanged: (value) async {
                          await folderCubit.fillterFolderByName(value);
                        },
                      ),
                    ),
                  ),

                  if (folders.isEmpty) Nodata(),
                  Expanded(
                    child: AnimationLimiter(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(20),
                        physics: const BouncingScrollPhysics(),
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
                            onDelete: (id) async {
                              await folderCubit.deleteFolder(id);
                            },
                            onRename: (folder) {
                              showFolderDialog(
                                context: context,
                                title: 'edit_folder'.tr(),
                                initialName: folder.name,
                                initialDesc: folder.description,
                                confirmText: 'save'.tr(),
                                onSubmit: (name, desc) async {
                                  await folderCubit.renameFolder(
                                    id: folder.id,
                                    name: name,
                                    description: desc,
                                  );
                                  return true;
                                },
                              );
                            },
                            onShare: (folder) async {
                              await showSelectDoctorDialog(
                                context: context,
                                folderId: folder.id,
                                shareFolderWithDoctor: ({
                                  required String doctorId,
                                }) async {
                                  final sharingCubit = FolderSharingCubit();
                                  await sharingCubit.shareFolderWithDoctor(
                                    folderId: folder.id,
                                    doctorId: doctorId,
                                  );
                                },
                              );
                              // Optionally, handle selectedDoctor if needed
                            },
                            shareWith: (folder) async {
                              await showSharedDoctorsDialog(
                                context: context,
                                folderId: folder.id,
                                folderName: folder.name,
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
