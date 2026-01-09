import 'package:cached_network_image/cached_network_image.dart';
import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/database/tables/appointments_tables.dart';
import 'package:diagno_bot/core/model/appointment.model.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/payment.dart';
import 'package:diagno_bot/features/appointment/index/cubit/appointment.cubit.dart';
import 'package:diagno_bot/features/appointment/index/cubit/appointment.state.dart';
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
    return BaseView(
      title: 'My Booking',
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
                      tabs: const [
                        Tab(text: "Upcoming"),
                        Tab(text: "Completed"),
                        Tab(text: "Canceled"),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: TabBarView(
                      controller: controller,
                      children: [
                        ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            ...appointments
                                .where(
                                  (appointment) =>
                                      appointment.status ==
                                      AppointmentStatus.PE,
                                )
                                .map(
                                  (appointment) => _bookingCard(
                                    appointment: appointment,
                                    actions: [
                                      _smallBtn(
                                        "Cancel",
                                        Colors.grey.shade200,
                                        ColorManager.primaryColor,
                                        onTap: () {},
                                      ),
                                      _smallBtn(
                                        "pay",

                                        ColorManager.primaryColor,
                                        Colors.white,
                                        onTap: () async {
                                          await makePayment(
                                            appointmentId: appointment.id,
                                            onSuccess: () {},
                                            onError: () {},
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                          ],
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

  Widget _buildCompleted(List<AppointmentModel> appointments) {
    if (appointments.isEmpty) {
      return const Center(child: Text("No Completed Bookings"));
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
      return const Center(child: Text("No Canceled Bookings"));
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
          Text(
            appointment.dateTime,
            style: const TextStyle(fontWeight: FontWeight.bold),
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
                  errorWidget: (contex, url, _) {
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
                      appointment.doctor.specialty,
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
