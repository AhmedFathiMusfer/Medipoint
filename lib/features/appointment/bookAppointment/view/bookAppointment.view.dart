import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/core/widgets/simpleButton.dart';
import 'package:diagno_bot/features/appointment/bookAppointment/cubit/bookAppointment.cubit.dart';
import 'package:diagno_bot/features/appointment/bookAppointment/cubit/bookAppointment.state.dart';
import 'package:diagno_bot/features/appointment/bookAppointment/view/widgets/show_payment_dialog.dart';
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
      title: 'book_appointment'.tr(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: BlocConsumer<BookAppointmentCubit, BookAppointmentState>(
          listener: (context, state) {
            state.maybeMap(
              orElse: () => {},
              success: (value) {
                if (value.isSuccessBooking) {
                  showPaymentDialog(context, value.appointmentId ?? 0);
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
                      "select_date".tr(),
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
                        locale: context.locale.languageCode,
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
                                allowDay.year == day.year &&
                                allowDay.month == day.month &&
                                allowDay.day == day.day,
                          );
                        },

                        onDaySelected: (selectedDay, focusedDay) {
                          if (!value.allowedWeekdays.any(
                            (allowDay) =>
                                allowDay.year == selectedDay.year &&
                                allowDay.month == selectedDay.month &&
                                allowDay.day == selectedDay.day,
                          )) {
                            return;
                          }

                          bookAppointmentCubit.selectDate(selectedDay);
                        },

                        calendarStyle: CalendarStyle(
                          todayTextStyle: TextStyle(color: Colors.black12),
                          todayDecoration: const BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: const BoxDecoration(
                            color: Color(0xff0D1B2A),
                            shape: BoxShape.circle,
                          ),
                          disabledTextStyle: TextStyle(color: Colors.black12),
                        ),

                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            final isAllowed = value.allowedWeekdays.any(
                              (allowDay) =>
                                  allowDay.year == day.year &&
                                  allowDay.month == day.month &&
                                  allowDay.day == day.day,
                            );

                            if (!isAllowed) return null;

                            return Container(
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ColorManager.primaryColor,
                                  width: 1.5,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${day.day}',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                          selectedBuilder: (context, day, focusedDay) {
                            return Container(
                              margin: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xff0D1B2A),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          },

                          todayBuilder: (context, day, focusedDay) {
                            final isAllowed = value.allowedWeekdays.any(
                              (allowDay) =>
                                  allowDay.year == day.year &&
                                  allowDay.month == day.month &&
                                  allowDay.day == day.day,
                            );

                            return Container(
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    isAllowed
                                        ? Border.all(
                                          color: ColorManager.primaryColor,
                                          width: 1.5,
                                        )
                                        : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${day.day}',
                                style: TextStyle(
                                  color:
                                      isAllowed
                                          ? Colors.black87
                                          : Colors.black12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    25.verticalSpace,
                    Text(
                      "select_hour".tr(),
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
                              context.locale.languageCode,
                            ).format(DateTime.parse(t.startTime));
                            final endHour = DateFormat(
                              'hh:mm a',
                              context.locale.languageCode,
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
                                  "$firstHour – $endHour",
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    30.verticalSpace,
                    SimpleButton(
                      isLoading: value.isBookingInProgress,
                      text: 'book'.tr(),
                      onPressed: () async {
                        if (value.selectedHour == null ||
                            value.selectedDate == null) {
                          AppSnackBar.error("please_select_date_time".tr());
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
