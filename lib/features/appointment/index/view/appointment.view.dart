import 'package:cached_network_image/cached_network_image.dart';
import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/database/tables/appointments_tables.dart';
import 'package:diagno_bot/core/model/appointment.model.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/payment.dart';
import 'package:diagno_bot/features/appointment/index/cubit/appointment.cubit.dart';
import 'package:diagno_bot/features/appointment/index/cubit/appointment.state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentView extends StatefulWidget {
  const AppointmentView({super.key});

  @override
  State<AppointmentView> createState() => _AppointmentViewState();
}

class _AppointmentViewState extends State<AppointmentView>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appointmentCubit = context.read<AppointmentCubit>();
    return BaseView(
      title: 'my_booking'.tr(),
      child: BlocBuilder<AppointmentCubit, AppointmentState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading:
                () => Center(
                  child: CircularProgressIndicator(
                    color: ColorManager.primaryColor,
                  ),
                ),
            success: (appointments) {
              return Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: TabBar(
                      controller: controller,
                      labelColor: ColorManager.primaryColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: ColorManager.primaryColor,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      tabs: [
                        Tab(text: "upcoming".tr()),
                        Tab(text: "completed".tr()),
                        Tab(text: "canceled".tr()),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: TabBarView(
                      controller: controller,
                      children: [
                        _buildUpcoming(
                          appointments
                              .where(
                                (appointment) =>
                                    appointment.status ==
                                        AppointmentStatus.PE ||
                                    appointment.status == AppointmentStatus.PA,
                              )
                              .toList(),
                          appointmentCubit,
                        ),

                        _buildCompleted(
                          appointments
                              .where(
                                (appointment) =>
                                    appointment.status == AppointmentStatus.D,
                              )
                              .toList(),
                        ),
                        _buildCanceled(
                          appointments
                              .where(
                                (appointment) =>
                                    appointment.status == AppointmentStatus.C,
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            orElse: () => SizedBox(),
          );
        },
      ),
    );
  }

  Widget _buildUpcoming(appointments, AppointmentCubit appointmentCubit) {
    if (appointments.isEmpty) {
      return Center(child: Text("no_upcoming_bookings".tr()));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...appointments.map(
          (appointment) => _bookingCard(
            appointment: appointment,
            actions:
                appointment.status == AppointmentStatus.PA
                    ? []
                    : [
                      SmallBtn(
                        text: "cancel".tr(),
                        bg: Colors.grey.shade200,
                        color: ColorManager.primaryColor,
                        onTap: () async {
                          await appointmentCubit.cancelAppointment(
                            appointment.id,
                          );
                        },
                      ),
                      SmallBtn(
                        text: "pay".tr(),
                        bg: ColorManager.primaryColor,
                        color: Colors.white,
                        onTap: () async {
                          await makePayment(
                            appointmentId: appointment.id,
                            onSuccess: () async {
                              await appointmentCubit.loadOnlineData();
                            },
                            onError: () {},
                          );
                        },
                      ),
                    ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompleted(List<AppointmentModel> appointments) {
    if (appointments.isEmpty) {
      return Center(child: Text("no_completed_bookings".tr()));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...appointments.map(
          (appointment) => _bookingCard(appointment: appointment, actions: []),
        ),
      ],
    );
  }

  Widget _buildCanceled(List<AppointmentModel> appointments) {
    if (appointments.isEmpty) {
      return Center(child: Text("no_canceled_bookings".tr()));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...appointments.map(
          (appointment) => _bookingCard(appointment: appointment, actions: []),
        ),
      ],
    );
  }

  Widget _bookingCard({
    required AppointmentModel appointment,
    required List<Widget> actions,
  }) {
    // دالة صغيرة لترجع اللون بناءً على الحالة
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

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    );
  }

  Widget _smallBtn(
    String text,
    Color bg,
    Color color, {
    required Function onTap,
  }) {
    return GestureDetector(
      onTap: () async {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class SmallBtn extends StatefulWidget {
  final String text;
  final Color bg;
  final Color color;
  final Future<void> Function() onTap;
  const SmallBtn({
    super.key,
    required this.text,
    required this.bg,
    required this.color,
    required this.onTap,
  });

  @override
  SmallBtnState createState() => SmallBtnState();
}

class SmallBtnState extends State<SmallBtn> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          _isLoading
              ? null
              : () async {
                setState(() {
                  _isLoading = true;
                });
                try {
                  await widget.onTap();
                } catch (e) {
                  // هنا ممكن تعالج أي خطأ
                } finally {
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: widget.bg,
          borderRadius: BorderRadius.circular(25),
        ),
        alignment: Alignment.center,
        child:
            _isLoading
                ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                  ),
                )
                : Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }
}
