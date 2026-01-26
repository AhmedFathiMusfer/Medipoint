import 'package:cached_network_image/cached_network_image.dart';
import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/database/tables/appointments_tables.dart';
import 'package:diagno_bot/core/model/appointment.model.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/payment.dart';
import 'package:diagno_bot/core/widgets/show_confirm_dialog.dart';
import 'package:diagno_bot/features/appointment/appointmentDetails/cubit/appointment_details.cubit.dart';
import 'package:diagno_bot/features/appointment/appointmentDetails/cubit/appointment_details.state.dart';
import 'package:diagno_bot/features/folderSharing/cubit/folder_sharing.cubit.dart';
import 'package:diagno_bot/features/folderSharing/view/widgets/select_folder_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentDetailsView extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback? onAppointmentUpdated;

  const AppointmentDetailsView({
    super.key,
    required this.appointment,
    this.onAppointmentUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'appointment_details'.tr(),
      buildBottomNav: const SizedBox(),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDoctorInfoCard(context),
              SizedBox(height: 20.h),

              // بطاقة تفاصيل الحجز
              _buildAppointmentDetailsCard(context),
              SizedBox(height: 20.h),

              // _buildActionsCard(context),
              // SizedBox(height: 20.h),

              // بطاقة المجلدات المشاركة
              _buildSharedFoldersSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorInfoCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.primaryColor,
            ColorManager.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Hero(
            tag: 'doctor_${appointment.doctor.userId}',
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: CachedNetworkImage(
                  imageUrl: appointment.doctor.image ?? '',
                  height: 90.h,
                  width: 90.w,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, _) {
                    return Image.asset(
                      "assets/image/default_doctor_image.jpg",
                      width: 90.w,
                      height: 90.h,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.doctor.fullName,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  context.locale.languageCode == 'ar'
                      ? appointment.doctor.specialtyAr ??
                          appointment.doctor.specialty
                      : appointment.doctor.specialty,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16.sp,
                      color: Colors.white.withOpacity(0.75),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        appointment.doctor.addressLine1 ?? '',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.75),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentDetailsCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: ColorManager.blueColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  color: ColorManager.blueColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'appointment_info'.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildDetailRow(
            icon: Icons.access_time_rounded,
            label: 'date_and_time'.tr(),
            value: DateFormat(
              'EEEE, dd MMM yyyy - hh:mm a',
              context.locale.toString(),
            ).format(DateTime.parse(appointment.dateTime)),
            iconColor: Colors.blue,
          ),
          SizedBox(height: 16.h),
          _buildDetailRow(
            icon: Icons.monetization_on_rounded,
            label: 'fees'.tr(),
            value: '${appointment.fees ?? '0'} ${'currency'.tr()}',
            iconColor: Colors.green,
          ),
          SizedBox(height: 16.h),
          _buildStatusRow(context),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: iconColor, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorManager.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: _statusColor(appointment.status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            _statusIcon(appointment.status),
            color: _statusColor(appointment.status),
            size: 20.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'status'.tr(),
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: _statusColor(appointment.status),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  _statusText(appointment.status),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionsCard(BuildContext context) {
    final actions = _getActions(context);
    if (actions.isEmpty) return const SizedBox();

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.flash_on_rounded,
                  color: Colors.orange,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'quick_actions'.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Wrap(spacing: 12.w, runSpacing: 12.h, children: actions),
        ],
      ),
    );
  }

  List<Widget> _getActions(BuildContext context) {
    List<Widget> actions = [];

    // actions.add(
    //   _buildActionButton(
    //     icon: Icons.share,
    //     label: 'share_medical_files'.tr(),
    //     color: Colors.blue,
    //     onTap: () async {
    //       final selectedFolder = await showSelectFolderDialog(context: context);
    //       if (selectedFolder != null) {
    //         final sharingCubit = FolderSharingCubit();
    //         await sharingCubit.shareFolderViaAppointment(
    //           folderId: selectedFolder.id,
    //           doctorId: appointment.doctor.userId,
    //           appointmentId: appointment.id,
    //         );
    //         if (context.mounted) {
    //           context.read<AppointmentDetailsCubit>().loadSharedFolders();
    //         }
    //       }
    //     },
    //   ),
    // );
    if (appointment.status == AppointmentStatus.PE) {
      actions.addAll([
        _buildActionButton(
          icon: Icons.payment_rounded,
          label: 'pay_now'.tr(),
          color: Colors.green,
          onTap: () async {
            await makePayment(
              appointmentId: appointment.id,
              onSuccess: () async {
                if (onAppointmentUpdated != null) {
                  onAppointmentUpdated!();
                }
              },
              onError: () {},
            );
          },
        ),
        // _buildActionButton(
        //   icon: Icons.cancel_rounded,
        //   label: 'cancel_appointment'.tr(),
        //   color: Colors.red,
        //   onTap: () async {
        //     final confirm = await _showConfirmDialog(
        //       context,
        //       title: 'cancel_appointment'.tr(),
        //       message: 'confirm_cancel_appointment'.tr(),
        //     );
        //     if (confirm == true) {
        //       // استخدام AppointmentCubit لإلغاء الحجز
        //       if (onAppointmentUpdated != null) {
        //         onAppointmentUpdated!();
        //       }
        //       if (context.mounted) {
        //         Navigator.of(context).pop();
        //       }
        //     }
        //   },
        // ),
      ]);
    }

    return actions;
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,

        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),

          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon(icon, color: Colors.white, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSharedFoldersSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: ColorManager.secondaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.folder_special_rounded,
                  color: Colors.blue,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'shared_folders'.tr(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.primaryColor,
                  ),
                ),
              ),
              _buildActionButton(
                icon: Icons.share,
                label: 'share'.tr(),
                color: Colors.blue,
                onTap: () async {
                  final selectedFolder = await showSelectFolderDialog(
                    context: context,
                    shareFolderWithAppointment: ({required folderId}) async {
                      final sharingCubit = FolderSharingCubit();
                      await sharingCubit.shareFolderViaAppointment(
                        folderId: folderId,
                        doctorId: appointment.doctor.userId,
                        appointmentId: appointment.id,
                      );
                      if (context.mounted) {
                        context
                            .read<AppointmentDetailsCubit>()
                            .loadSharedFolders();
                      }
                    },
                  );
                  if (selectedFolder != null) {}
                },
              ),
            ],
          ),
          SizedBox(height: 20.h),
          BlocBuilder<AppointmentDetailsCubit, AppointmentDetailsState>(
            builder: (context, state) {
              return state.maybeWhen(
                loading:
                    () => Center(
                      child: CircularProgressIndicator(
                        color: ColorManager.primaryColor,
                      ),
                    ),
                success: (sharedFolders, folderDetails) {
                  if (sharedFolders.isEmpty) {
                    return _buildEmptyFoldersState();
                  }
                  return _buildFoldersList(
                    context,
                    sharedFolders,
                    folderDetails,
                  );
                },
                error:
                    (message) => Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 48.sp,
                            color: Colors.red.withOpacity(0.5),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            message,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                orElse: () => const SizedBox(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFoldersState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.h),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.folder_off_rounded,
              size: 48.sp,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'no_shared_folders'.tr(),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'share_folders_hint'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.withOpacity(0.7),
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoldersList(
    BuildContext context,
    List<PatientSharedFolder> sharedFolders,
    List<PatientFolder> folderDetails,
  ) {
    return Column(
      children:
          sharedFolders.map((share) {
            final folder = folderDetails.firstWhere(
              (f) => f.id == share.folderId,
              orElse:
                  () => PatientFolder(
                    id: share.folderId,
                    name: 'Unknown',
                    createdAt: '',
                    updatedAt: '',
                  ),
            );
            return _buildFolderCard(context, share, folder);
          }).toList(),
    );
  }

  Widget _buildFolderCard(
    BuildContext context,
    PatientSharedFolder share,
    PatientFolder folder,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
      decoration: BoxDecoration(
        color: ColorManager.secondaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.folder_rounded, color: Colors.blue, size: 28.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  folder.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.primaryColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      DateFormat(
                        'dd MMM yyyy',
                        context.locale.toString(),
                      ).format(DateTime.parse(share.createdAt)),
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                showConfirmDialog(
                  context: context,
                  title: 'unshare_folder'.tr(),
                  message: 'confirm_unshare_folder'.tr(),
                  onConfirm: () async {
                    if (context.mounted) {
                      await context
                          .read<AppointmentDetailsCubit>()
                          .unshareFolder(share.id);
                    }
                  },
                );
              },
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                padding: EdgeInsets.all(10.w),
                child: Icon(
                  Icons.link_off_rounded,
                  color: Colors.red,
                  size: 22.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper functions for status
  Color _statusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.PE:
        return Colors.orange;
      case AppointmentStatus.PA:
        return Colors.green;
      case AppointmentStatus.D:
        return Colors.blue;
      case AppointmentStatus.M:
        return Colors.red;
      case AppointmentStatus.C:
        return Colors.red;
      case AppointmentStatus.DE:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.PE:
        return Icons.hourglass_empty_rounded;
      case AppointmentStatus.PA:
        return Icons.check_circle_rounded;
      case AppointmentStatus.D:
        return Icons.task_alt_rounded;
      case AppointmentStatus.M:
        return Icons.cancel_rounded;
      case AppointmentStatus.C:
        return Icons.cancel_rounded;
      case AppointmentStatus.DE:
        return Icons.delete_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String _statusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.PE:
        return 'pending'.tr();
      case AppointmentStatus.PA:
        return 'paid'.tr();
      case AppointmentStatus.D:
        return 'done'.tr();
      case AppointmentStatus.M:
        return 'missed'.tr();
      case AppointmentStatus.C:
        return 'canceled'.tr();
      case AppointmentStatus.DE:
        return 'deleted'.tr();
      default:
        return '';
    }
  }
}
