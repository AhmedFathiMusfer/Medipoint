import 'package:cached_network_image/cached_network_image.dart';
import 'package:diagno_bot/core/model/doctor.model.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/show_confirm_dialog.dart';
import 'package:diagno_bot/features/folderSharing/cubit/folder_sharing.cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Dialog لعرض الدكاترة المشاركين في مجلد معين مع إمكانية إلغاء المشاركة
Future<void> showSharedDoctorsDialog({
  required BuildContext context,
  required int folderId,
  required String folderName,
}) async {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _SharedDoctorsContent(folderId: folderId, folderName: folderName);
    },
  );
}

class _SharedDoctorsContent extends StatefulWidget {
  final int folderId;
  final String folderName;

  const _SharedDoctorsContent({
    required this.folderId,
    required this.folderName,
  });

  @override
  State<_SharedDoctorsContent> createState() => _SharedDoctorsContentState();
}

class _SharedDoctorsContentState extends State<_SharedDoctorsContent> {
  final FolderSharingCubit _sharingCubit = FolderSharingCubit();
  List<Map<String, dynamic>> _sharedDoctors = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSharedDoctors();
  }

  Future<void> _loadSharedDoctors() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final doctors = await _sharingCubit.getSharedDoctorsForFolder(
        widget.folderId,
      );
      setState(() {
        _sharedDoctors = doctors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'error_loading_shared_doctors'.tr();
        _isLoading = false;
      });
    }
  }

  Future<void> _unshareFolder(int shareId, String doctorName) async {
    showConfirmDialog(
      context: context,
      title: 'confirm_unshare'.tr(),
      message: '${'are_you_sure_unshare_with'.tr()} $doctorName?',
      confirmText: 'unshare'.tr(),
      confirmColor: Colors.red,
      onConfirm: () async {
        final success = await _sharingCubit.unshareFolder(shareId);
        if (success) {
          await _loadSharedDoctors();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
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
                  child: Column(
                    children: [
                      Text(
                        'shared_with'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        widget.folderName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 48.w), // Balance the close button
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          SizedBox(height: 12.h),
          // Content
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: ColorManager.primaryColor),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.r, color: Colors.red),
            SizedBox(height: 8.h),
            Text(_error!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _loadSharedDoctors,
              child: Text('retry'.tr()),
            ),
          ],
        ),
      );
    }

    if (_sharedDoctors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64.r, color: Colors.grey.shade400),
            SizedBox(height: 16.h),
            Text(
              'no_shared_doctors'.tr(),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              'folder_not_shared_with_anyone'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: _sharedDoctors.length,
      separatorBuilder:
          (_, __) => Divider(height: 1, color: Colors.grey.shade200),
      itemBuilder: (context, index) {
        final data = _sharedDoctors[index];
        final doctor = data['doctor'] as DoctorModel;
        final shareId = data['shareId'] as int;
        final sharingType = data['sharingType'] as String;

        return _SharedDoctorTile(
          doctor: doctor,
          sharingType: sharingType,
          onUnshare: () => _unshareFolder(shareId, doctor.fullName),
        );
      },
    );
  }
}

class _SharedDoctorTile extends StatelessWidget {
  final DoctorModel doctor;
  final String sharingType;
  final VoidCallback onUnshare;

  const _SharedDoctorTile({
    required this.doctor,
    required this.sharingType,
    required this.onUnshare,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.h),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: CachedNetworkImage(
          imageUrl: doctor.image ?? '',
          width: 56.w,
          height: 56.w,
          fit: BoxFit.cover,
          errorWidget:
              (_, __, ___) => Image.asset(
                "assets/image/default_doctor_image.jpg",
                width: 56.w,
                height: 56.w,
                fit: BoxFit.cover,
              ),
        ),
      ),
      title: Text(
        doctor.fullName,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.languageCode == 'ar'
                ? doctor.specialtyAr ?? doctor.specialty
                : doctor.specialty,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13.sp),
          ),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color:
                  sharingType == 'APPOINTMENT'
                      ? Colors.orange.withValues(alpha: 0.1)
                      : Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              sharingType == 'APPOINTMENT'
                  ? 'via_appointment'.tr()
                  : 'direct_share'.tr(),
              style: TextStyle(
                fontSize: 11.sp,
                color:
                    sharingType == 'APPOINTMENT'
                        ? Colors.orange.shade700
                        : Colors.green.shade700,
              ),
            ),
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: onUnshare,
        icon: Icon(
          Icons.person_remove_rounded,
          color: Colors.red.shade400,
          size: 24.r,
        ),
        tooltip: 'unshare'.tr(),
      ),
    );
  }
}
