import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/core/widgets/simpleButton.dart';
import 'package:diagno_bot/features/appointment/bookAppointment/cubit/bookAppointment.cubit.dart';
import 'package:diagno_bot/features/appointment/bookAppointment/cubit/bookAppointment.state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

class BookAppointmentView extends StatelessWidget {
  const BookAppointmentView({super.key});

  @override
  Widget build(BuildContext context) {
    var bookAppointmentCubit = context.read<BookAppointmentCubit>();
    return BaseView(
      title: 'Book Appointment',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: BlocConsumer<BookAppointmentCubit, BookAppointmentState>(
          listener: (context, state) {
            state.maybeMap(
              orElse: () => {},
              success: (value) {
                if (value.isSuccessBooking) {
                  _showPaymentDialog(context, 1);
                  // context.pushNamedAndRemoveUntil(
                  //   Routers.appointmentView,
                  //   predicate: (root) => false,
                  // );
                }
              },
            );
          },
          builder: (context, state) {
            return state.maybeMap(
              orElse: () => Container(),
              success: (value) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Date",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    10.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15,
                            color: Colors.black12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2020),
                        lastDay: DateTime.utc(2030),
                        focusedDay: value.selectedDate ?? DateTime.now(),
                        calendarFormat: CalendarFormat.month,
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                        ),
                        daysOfWeekVisible: true,
                        selectedDayPredicate:
                            (day) => isSameDay(day, value.selectedDate),
                        enabledDayPredicate: (day) {
                          return value.allowedWeekdays.any(
                            (allowDay) =>
                                (allowDay.year == day.year &&
                                    allowDay.month == day.month &&
                                    allowDay.day == day.day),
                          );
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          if (!value.allowedWeekdays.any(
                            (allowDay) =>
                                (allowDay.year == selectedDay.year &&
                                    allowDay.month == selectedDay.month &&
                                    allowDay.day == selectedDay.day),
                          )) {
                            return;
                          }

                          bookAppointmentCubit.selectDate(selectedDay);
                        },

                        calendarStyle: CalendarStyle(
                          todayTextStyle: TextStyle(color: Colors.black12),
                          todayDecoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Color(0xff0D1B2A),
                            shape: BoxShape.circle,
                          ),
                          disabledTextStyle: TextStyle(
                            color: Colors.black12,
                          ), // أيام غير مسموحة
                        ),
                      ),
                    ),
                    25.verticalSpace,

                    Text(
                      "Select Hour",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    10.verticalSpace,
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children:
                          value.availableTimes.map((t) {
                            final isSelected = value.selectedHour == t;
                            final firstHour = DateFormat(
                              'hh:mm a',
                            ).format(DateTime.parse(t.startTime));
                            final endHour = DateFormat(
                              'hh:mm a',
                            ).format(DateTime.parse(t.endTime));
                            return GestureDetector(
                              onTap: () {
                                bookAppointmentCubit.selectPeriod(t);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? Color(0xff0D1B2A)
                                          : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "$firstHour–$endHour",
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    30.verticalSpace,
                    SimpleButton(
                      isLoading: value.isBookingInProgress,
                      text: 'Book',
                      onPressed: () async {
                        if (value.selectedHour == null ||
                            value.selectedDate == null) {
                          AppSnackBar.error("pleace select the date and time ");
                          return;
                        }
                        await bookAppointmentCubit.addBooking(
                          value.selectedHour!.id,
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

void _showPaymentDialog(BuildContext context, int bookingId) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Complete Payment"),
        content: const Text(
          "Your appointment is booked successfully.\n"
          "Would you like to pay now?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pushNamedAndRemoveUntil(
                Routers.appointmentView,
                predicate: (route) => false,
              );
            },
            child: const Text(
              "Pay Later",
              style: TextStyle(color: ColorManager.primaryColor),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                ColorManager.primaryColor,
              ),
            ),
            onPressed: () {
              // Navigator.pop(context);
              // context.pushNamed(
              //   Routers.paymentView,
              //   arguments: bookingId,
              // );
            },
            child: const Text("Pay Now", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
