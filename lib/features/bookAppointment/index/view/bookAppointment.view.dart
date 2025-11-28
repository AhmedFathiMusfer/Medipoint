import 'package:cached_network_image/cached_network_image.dart';
import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/features/bookAppointment/cubit/bookAppointment.cubit.dart';
import 'package:diagno_bot/features/bookAppointment/cubit/bookAppointment.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'My Booking',

      child: Column(
        children: [
          // 🔥 TabBar خارج الـ AppBar
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

          // 🔥 خط فاصل بسيط مثل التطبيقات الاحترافية
          const Divider(height: 1),

          // 🔥 محتوى الـ Tabs
          Expanded(
            child: TabBarView(
              controller: controller,
              children: [_buildUpcoming(), _buildCompleted(), _buildCanceled()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcoming() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _bookingCard(
          date: "May 22, 2023 - 10.00 AM",
          name: "Dr. James Robinson",
          specialty: "Orthopedic Surgery",
          clinic: "Elite Ortho Clinic, USA",
          image: "https://i.pravatar.cc/300?img=60",
          actions: [
            _smallBtn(
              "Cancel",
              Colors.grey.shade200,
              ColorManager.primaryColor,
            ),
            _smallBtn("Reschedule", ColorManager.primaryColor, Colors.white),
          ],
        ),
        _bookingCard(
          date: "June 14, 2023 - 15.00 PM",
          name: "Dr. Daniel Lee",
          specialty: "Gastroenterologist",
          clinic: "Digestive Institute, USA",
          image: "https://i.pravatar.cc/300?img=60",
          actions: [
            _smallBtn("Cancel", Colors.grey.shade200, Colors.black),
            _smallBtn("Reschedule", Colors.black, Colors.white),
          ],
        ),
      ],
    );
  }

  Widget _buildCompleted() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _bookingCard(
          date: "March 12, 2023 - 11.00 AM",
          name: "Dr. Sarah Johnson",
          specialty: "Gynecologist",
          clinic: "Women's Health Clinic",
          image: "https://i.pravatar.cc/300?img=60",
          actions: [
            _smallBtn("Re-Book", Colors.grey.shade200, Colors.black),
            _smallBtn("Add Review", Colors.black, Colors.white),
          ],
        ),
        _bookingCard(
          date: "March 2, 2023 - 12.00 AM",
          name: "Dr. Michael Chang",
          specialty: "Cardiologist",
          clinic: "HeartCare Center, USA",
          image: "https://i.pravatar.cc/300?img=60",
          actions: [
            _smallBtn(
              "Re-Book",
              Colors.grey.shade200,
              ColorManager.primaryColor,
            ),
            _smallBtn("Add Review", ColorManager.primaryColor, Colors.white),
          ],
        ),
      ],
    );
  }

  Widget _buildCanceled() {
    return const Center(child: Text("No Canceled Bookings"));
  }

  Widget _bookingCard({
    required String date,
    required String name,
    required String specialty,
    required String clinic,
    required String image,
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
          Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: image,
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(specialty, style: const TextStyle(color: Colors.grey)),
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
                            clinic,
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

  Widget _smallBtn(String text, Color bg, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class BookAppointmentPage extends StatelessWidget {
  const BookAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    var bookAppointmentCubit = context.read<BookAppointmentCubit>();
    return BaseView(
      title: 'Book Appointment',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
          builder: (context, state) {
            return state.maybeMap(
              orElse: () => Container(),
              success:
                  (value) => Column(
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
                          selectedDayPredicate:
                              (day) => isSameDay(day, value.selectedDate),
                          enabledDayPredicate: (day) {
                            return value.allowedWeekdays.contains(day.weekday);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            if (!value.allowedWeekdays.contains(
                              selectedDay.weekday,
                            ))
                              return;

                            bookAppointmentCubit.selectDate(selectedDay);
                          },

                          calendarStyle: CalendarStyle(
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

                              return GestureDetector(
                                onTap: () {
                                  bookAppointmentCubit.selectHour(t);
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
                                    t,
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
                      Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Color(0xff0D1B2A),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
            );
          },
        ),
      ),
    );
  }
}
