import 'package:cached_network_image/cached_network_image.dart';
import 'package:diagno_bot/core/model/doctor.model.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/features/folderSharing/cubit/folder_sharing.cubit.dart';
import 'package:diagno_bot/features/folderSharing/cubit/folder_sharing.state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<DoctorModel?> showSelectDoctorDialog({
  required Future<void> Function({required String doctorId})
  shareFolderWithDoctor,
  required BuildContext context,
  required int folderId,
}) async {
  return showModalBottomSheet<DoctorModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BlocProvider(
        create: (_) => FolderSharingCubit()..loadDoctors(folderId),
        child: _SelectDoctorContent(
          shareFolderWithDoctor: shareFolderWithDoctor,
        ),
      );
    },
  );
}

class _SelectDoctorContent extends StatefulWidget {
  final Future<void> Function({required String doctorId}) shareFolderWithDoctor;
  const _SelectDoctorContent({required this.shareFolderWithDoctor});

  @override
  State<_SelectDoctorContent> createState() => _SelectDoctorContentState();
}

class _SelectDoctorContentState extends State<_SelectDoctorContent> {
  String _searchQuery = '';

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
                  child: Text(
                    'select_doctor'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 48.w), // Balance the close button
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
                  hintText: 'search_doctor'.tr(),
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
          // Doctors list
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
                  doctorsLoaded: (doctors) {
                    final filteredDoctors =
                        doctors.where((doctor) {
                          return doctor.fullName.toLowerCase().contains(
                            _searchQuery,
                          );
                        }).toList();

                    if (filteredDoctors.isEmpty) {
                      return Center(
                        child: Text(
                          'no_doctors_found'.tr(),
                          style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: filteredDoctors.length,
                      separatorBuilder:
                          (_, __) =>
                              Divider(height: 1, color: Colors.grey.shade200),
                      itemBuilder: (context, index) {
                        final doctor = filteredDoctors[index];
                        return _DoctorTile(
                          doctor: doctor,
                          onTap: () async {
                            await widget.shareFolderWithDoctor(
                              doctorId: doctor.userId,
                            );
                            Navigator.pop(context, doctor);
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
                            Text(message, style: TextStyle(color: Colors.red)),
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

class _DoctorTile extends StatelessWidget {
  final DoctorModel doctor;
  final Future<void> Function() onTap;

  _DoctorTile({required this.doctor, required this.onTap});
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
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
          subtitle: Text(
            context.locale.languageCode == 'ar'
                ? doctor.specialtyAr ?? doctor.specialty
                : doctor.specialty,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13.sp),
          ),
          trailing:
              _isLoading == true
                  ? SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5.w,
                      color: ColorManager.primaryColor,
                    ),
                  )
                  : Icon(
                    Icons.share,
                    size: 16.r,
                    color: ColorManager.primaryColor,
                  ),
          onTap: () async {
            setState(() => _isLoading = true);
            await onTap();
            setState(() => _isLoading = false);
          },
        );
      },
    );
  }
}
