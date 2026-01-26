import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/database/tables/appointments_tables.dart';
import 'package:diagno_bot/core/model/appointment.model.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/payment.dart';
import 'package:diagno_bot/core/widgets/show_confirm_dialog.dart';
import 'package:diagno_bot/features/appointment/index/cubit/appointment.cubit.dart';
import 'package:diagno_bot/features/appointment/index/cubit/appointment.state.dart';
import 'package:diagno_bot/features/appointment/index/view/widgets/appintment_card.dart';
import 'package:diagno_bot/features/appointment/index/view/widgets/small_btn.dart';
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
                          appointmentCubit,
                        ),
                        _buildCanceled(
                          appointments
                              .where(
                                (appointment) =>
                                    appointment.status == AppointmentStatus.C,
                              )
                              .toList(),
                          appointmentCubit,
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
          (appointment) => AppintmentCard(
            context: context,
            appointment: appointment,
            appointmentCubit: appointmentCubit,
            actions:
                appointment.status == AppointmentStatus.PE
                    ? [
                      SmallBtn(
                        text: "cancel".tr(),
                        bg: Colors.grey.shade200,
                        color: ColorManager.primaryColor,
                        onTap: () async {
                          showConfirmDialog(
                            context: context,
                            title: 'cancel_appointment'.tr(),
                            message: 'confirm_cancel_appointment'.tr(),
                            onConfirm: () async {
                              await appointmentCubit.cancelAppointment(
                                appointment.id,
                              );
                            },
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
                    ]
                    : [],
          ),
        ),
      ],
    );
  }

  Widget _buildCompleted(
    List<AppointmentModel> appointments,
    AppointmentCubit appointmentCubit,
  ) {
    if (appointments.isEmpty) {
      return Center(child: Text("no_completed_bookings".tr()));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...appointments.map(
          (appointment) => AppintmentCard(
            context: context,
            appointment: appointment,
            appointmentCubit: appointmentCubit,
            actions: [],
          ),
        ),
      ],
    );
  }

  Widget _buildCanceled(
    List<AppointmentModel> appointments,
    AppointmentCubit appointmentCubit,
  ) {
    if (appointments.isEmpty) {
      return Center(child: Text("no_canceled_bookings".tr()));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...appointments.map(
          (appointment) => AppintmentCard(
            context: context,
            appointment: appointment,
            appointmentCubit: appointmentCubit,
            actions: [],
          ),
        ),
      ],
    );
  }
}
