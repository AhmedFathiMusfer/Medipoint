import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/features/folderSharing/cubit/folder_sharing.cubit.dart';
import 'package:diagno_bot/features/folderSharing/cubit/folder_sharing.state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Dialog لاختيار مجلد للمشاركة (للاستخدام في صفحة الحجوزات)
Future<PatientFolder?> showSelectFolderDialog({
  required Future<void> Function({required int folderId})
  shareFolderWithAppointment,
  required BuildContext context,
}) async {
  return showModalBottomSheet<PatientFolder>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BlocProvider(
        create: (_) => FolderSharingCubit()..loadFolders(),
        child: _SelectFolderContent(
          shareFolderWithAppointment: shareFolderWithAppointment,
        ),
      );
    },
  );
}

class _SelectFolderContent extends StatefulWidget {
  final Future<void> Function({required int folderId})
  shareFolderWithAppointment;
  const _SelectFolderContent({required this.shareFolderWithAppointment});

  @override
  State<_SelectFolderContent> createState() => _SelectFolderContentState();
}

class _SelectFolderContentState extends State<_SelectFolderContent> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
                Expanded(
                  child: Text(
                    'select_folder_to_share'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 48.w),
              ],
            ),
          ),
          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'search_folder'.tr(),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Folders list
          Expanded(
            child: BlocBuilder<FolderSharingCubit, FolderSharingState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loading:
                      () => Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.primaryColor,
                        ),
                      ),
                  foldersLoaded: (folders) {
                    final filteredFolders =
                        folders.where((folder) {
                          return folder.name.toLowerCase().contains(
                            _searchQuery,
                          );
                        }).toList();

                    if (filteredFolders.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_off,
                              size: 64.r,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'no_folders_found'.tr(),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: filteredFolders.length,
                      separatorBuilder:
                          (_, __) =>
                              Divider(height: 1, color: Colors.grey.shade200),
                      itemBuilder: (context, index) {
                        final folder = filteredFolders[index];
                        return _FolderTile(
                          folder: folder,
                          onTap: () async {
                            await widget.shareFolderWithAppointment(
                              folderId: folder.id,
                            );
                            Navigator.pop(context, folder);
                          },
                        );
                      },
                    );
                  },
                  error:
                      (message) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48.r,
                              color: Colors.red,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              message,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                  orElse: () => const SizedBox(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FolderTile extends StatelessWidget {
  final PatientFolder folder;
  final Future<void> Function() onTap;

  _FolderTile({required this.folder, required this.onTap});
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8.h),
          leading: Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Icon(Icons.folder_rounded, color: Colors.blue),
          ),
          title: Text(
            folder.name,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          subtitle:
              folder.description != null && folder.description!.isNotEmpty
                  ? Text(
                    folder.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13.sp,
                    ),
                  )
                  : null,
          trailing:
              _isLoading
                  ? SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5.w,
                      color: ColorManager.primaryColor,
                    ),
                  )
                  : Icon(Icons.chevron_right, color: ColorManager.primaryColor),
          onTap: () async {
            setState(() {
              _isLoading = true;
            });
            await onTap();
            setState(() {
              _isLoading = false;
            });
          },
        );
      },
    );
  }
}
