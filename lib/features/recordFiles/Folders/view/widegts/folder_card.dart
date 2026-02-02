import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/show_confirm_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// }
class FolderCard extends StatelessWidget {
  final PatientFolder folder;
  final Function(int id) onTap;
  final Function(int id) onDelete;
  final Function(PatientFolder folder) onRename;
  final Function(PatientFolder folder)? onShare;
  final Function(PatientFolder folder)? shareWith;

  const FolderCard({
    super.key,
    required this.folder,
    required this.onTap,
    required this.onDelete,
    required this.onRename,
    this.onShare,
    this.shareWith,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),

        leading: Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.folder_rounded, color: Colors.blue, size: 26),
        ),
        title: Text(
          folder.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (folder.description != null && folder.description!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Text(
                  folder.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) async {
            if (value == 'rename') {
              await onRename(folder);
            } else if (value == 'share') {
              if (onShare != null) {
                await onShare!(folder);
              }
            } else if (value == 'shareWith') {
              if (shareWith != null) {
                await shareWith!(folder);
              }
            } else if (value == 'delete') {
              showConfirmDialog(
                context: context,
                title: "confirm_delete".tr(),
                message: "are_you_sure_delete_folder".tr(),
                confirmText: "delete".tr(),
                confirmColor: Colors.red,
                onConfirm: () async {
                  await onDelete(folder.id);
                },
              );
            }
          },
          itemBuilder:
              (_) => [
                PopupMenuItem(
                  value: 'rename',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: ColorManager.primaryColor),
                      8.horizontalSpace,
                      Text('rename'.tr()),
                    ],
                  ),
                ),
                if (onShare != null)
                  PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share, color: ColorManager.primaryColor),
                        8.horizontalSpace,
                        Text('share'.tr()),
                      ],
                    ),
                  ),
                if (shareWith != null)
                  PopupMenuItem(
                    value: 'shareWith',
                    child: Row(
                      children: [
                        Icon(Icons.people_outline, color: ColorManager.primaryColor),
                        8.horizontalSpace,
                        Text('shared_with'.tr()),
                      ],
                    ),
                  ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      8.horizontalSpace,
                      Text(
                        'delete'.tr(),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
        ),

        onTap: () => onTap(folder.id),
      ),
    );
  }
}
