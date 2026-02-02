import 'package:cached_network_image/cached_network_image.dart';
import 'package:diagno_bot/core/database/tables/appointments_tables.dart';
import 'package:diagno_bot/core/model/appointment.model.dart';
import 'package:diagno_bot/core/routing/app_router.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/features/appointment/index/cubit/appointment.cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppintmentCard extends StatelessWidget {
  const AppintmentCard({
    super.key,
    required this.context,
    required this.appointment,
    required this.actions,
    required this.appointmentCubit,
  });

  final BuildContext context;
  final AppointmentModel appointment;
  final List<Widget> actions;
  final AppointmentCubit? appointmentCubit;

  @override
  Widget build(BuildContext context) {
    Color statusColor(AppointmentStatus status) {
      switch (status) {
        case AppointmentStatus.PE:
          return Colors.orange; // Pending
        case AppointmentStatus.PA:
          return Colors.green; // Paid
        case AppointmentStatus.D:
          return Colors.blue; // Done
        case AppointmentStatus.M:
          return Colors.red; // Missed
        case AppointmentStatus.C:
          return Colors.red; // Canceled
        case AppointmentStatus.DE:
          return Colors.black; // Deleted / Declined
        default:
          return Colors.grey;
      }
    }

    // دالة صغيرة لترجع النص بناءً على الحالة
    String statusText(AppointmentStatus status) {
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

    return GestureDetector(
      onTap: () {
        AppRouter.navigatorKey.currentState!.pushNamed(
          Routers.appointmentDetailsView,
          arguments: {
            'appointment': appointment,
            'onUpdated': () async {
              if (appointmentCubit != null) {
                await appointmentCubit!.loadOnlineData();
              }
            },
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat(
                    'dd MMM yyyy, hh:mm a',
                    context.locale.toString(),
                  ).format(DateTime.parse(appointment.dateTime)),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor(appointment.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText(appointment.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: appointment.doctor.image ?? '',
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, _) {
                      return Image.asset(
                        "assets/image/default_doctor_image.jpg",
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctor.fullName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        context.locale.languageCode == 'ar'
                            ? appointment.doctor.specialtyAr ??
                                appointment.doctor.specialty
                            : appointment.doctor.specialty,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              appointment.doctor.addressLine1 ?? '',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '${'fees'.tr()}: ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              appointment.fees ?? '0',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }
}
