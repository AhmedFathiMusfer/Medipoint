import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/noData.dart';
import 'package:diagno_bot/core/widgets/show_confirm_dialog.dart';
import 'package:diagno_bot/features/recordFiles/files/cubit/file.cubit.dart';
import 'package:diagno_bot/features/recordFiles/files/cubit/file.state.dart';
import 'package:diagno_bot/features/recordFiles/files/view/widgets/file_picker.dart';
import 'package:diagno_bot/features/recordFiles/files/view/widgets/show_rename_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_filex/open_filex.dart';

class PatientFilesView extends StatelessWidget {
  const PatientFilesView({super.key});

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
      title: 'files'.tr(),
      floatingActionButton: BlocBuilder<FileCubit, FileState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () {
              return SizedBox();
            },
            success: (_, _, _) {
              return FloatingActionButton.extended(
                backgroundColor: ColorManager.primaryColor,
                onPressed: () {
                  showCreateFileDialog(
                    context: context,
                    fileCubit: fileCubit,
                    onUpload: (name, type, file) async {
                      await fileCubit.createNewFile(name, file);
                    },
                  );
                },
                icon: const Icon(Icons.file_copy, color: Colors.white),
                label: Text("new".tr(), style: TextStyle(color: Colors.white)),
              );
            },
          );
        },
      ),
      child: BlocBuilder<FileCubit, FileState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () {
              return Nodata();
            },
            loading: () {
              return Center(
                child: CircularProgressIndicator(
                  color: ColorManager.primaryColor,
                ),
              );
            },
            success: (files, _, _) {
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
                          hintText: 'search_file'.tr(),
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                        onChanged: (value) async {
                          await fileCubit.fillterFileByName(value);
                        },
                      ),
                    ),
                  ),
                  if (files.isEmpty) Nodata(),
                  Expanded(
                    child: ListView.separated(
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
                                    ? Text(
                                      "not_downloaded_yet".tr(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    )
                                    : Text(
                                      "downloaded".tr(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green,
                                      ),
                                    ),

                            trailing:
                                file.localPath == null
                                    ? BlocSelector<
                                      FileCubit,
                                      FileState,
                                      double?
                                    >(
                                      selector: (state) {
                                        return state.maybeWhen(
                                          success:
                                              (_, downloads, _) =>
                                                  downloads[file.id],
                                          orElse: () => null,
                                        );
                                      },
                                      builder: (context, progress) {
                                        if (progress != null) {
                                          return SizedBox(
                                            width: 42,
                                            height: 42,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                CircularProgressIndicator(
                                                  value: progress,
                                                  strokeWidth: 3,
                                                  color:
                                                      ColorManager.primaryColor,
                                                ),
                                                Text(
                                                  '${(progress * 100).toStringAsFixed(0)}%',
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }

                                        return IconButton(
                                          icon: const Icon(Icons.download),
                                          onPressed: () {
                                            fileCubit.downloadFile(file);
                                          },
                                        );
                                      },
                                    )
                                    : PopupMenuButton<String>(
                                      color: Colors.white,
                                      onSelected: (value) {
                                        switch (value) {
                                          case 'rename':
                                            showRenameDialog(
                                              context,
                                              fileCubit,
                                              file,
                                            );
                                            break;
                                          case 'delete':
                                            showConfirmDialog(
                                              context: context,
                                              title: "confirm_delete".tr(),
                                              message:
                                                  "are_you_sure_delete_file"
                                                      .tr(),
                                              confirmText: "delete".tr(),
                                              confirmColor: Colors.red,
                                              onConfirm: () async {
                                                await fileCubit.deleteFile(
                                                  file,
                                                );
                                              },
                                            );
                                            break;
                                          case 'share':
                                            fileCubit.shareFile(file);
                                            break;
                                        }
                                      },
                                      itemBuilder:
                                          (context) => [
                                            PopupMenuItem(
                                              value: 'rename',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.edit,
                                                    color:
                                                        ColorManager
                                                            .primaryColor,
                                                  ),
                                                  5.horizontalSpace,
                                                  Text(
                                                    'rename'.tr(),
                                                    style: TextStyle(
                                                      color:
                                                          ColorManager
                                                              .primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'share',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.share,
                                                    color:
                                                        ColorManager
                                                            .primaryColor,
                                                  ),
                                                  5.horizontalSpace,
                                                  Text(
                                                    'share'.tr(),
                                                    style: TextStyle(
                                                      color:
                                                          ColorManager
                                                              .primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  5.horizontalSpace,
                                                  Text(
                                                    'delete'.tr(),
                                                    style: const TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                    ),

                            onTap: () async {
                              if (file.localPath != null) {
                                await OpenFilex.open(file.localPath!);
                              } else {
                                fileCubit.downloadFile(file);
                              }
                            },
                          ),
                        );
                      },
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
