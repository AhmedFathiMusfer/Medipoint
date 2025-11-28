// import 'package:diagno_bot/core/database/drift_db.dart';
// import 'package:diagno_bot/core/theming/color.dart';
// import 'package:diagno_bot/core/widgets/simpleButton.dart';
// import 'package:diagno_bot/features/bookAppointment/cubit/bookAppointment.cubit.dart';
// import 'package:diagno_bot/features/bookAppointment/cubit/bookAppointment.state.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:table_calendar/table_calendar.dart';

// class BookAppointmentView extends StatelessWidget {
//   BookAppointmentView({super.key});

//   final List<String> hours = [
//     "09.00 AM",
//     "09.30 AM",
//     "10.00 AM",
//     "10.30 AM",
//     "11.00 AM",
//     "11.30 AM",
//     "03.00 PM",
//     "03.30 PM",
//     "04.00 PM",
//     "04.30 PM",
//     "05.00 PM",
//     "05.30 PM",
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F8FA),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.black,
//         title: const Text(
//           "Book Appointment",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             DatePickerCard(),
//             10.verticalSpace,
//             _title("Select Hour"),
//             10.verticalSpace,
//             _hoursGrid(context),
//             // const Spacer(),
//             10.verticalSpace,
//             SimpleButton(
//               text: 'Confirm',
//               onPressed: () {
//                 final state = context.read<BookAppointmentCubit>().state;

//                 if (state.selectedDate == null || state.selectedHour == null) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text("Please select date and hour"),
//                     ),
//                   );
//                   return;
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _title(String text) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         textAlign: TextAlign.start,
//         text,
//         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   Widget _calendarCard(BuildContext context) {
//     return Container(
//       height: 350.h,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 12,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
//         builder: (_, state) {
//           return Theme(
//             data: Theme.of(context).copyWith(
//               colorScheme: ColorScheme.light(
//                 primary: ColorManager.primaryColor, // عنوان الشهر + الأسهم
//               ),
//               datePickerTheme: DatePickerThemeData(
//                 dayStyle: TextStyle(color: Colors.black),
//                 weekdayStyle: TextStyle(color: Colors.black),

//                 // ✅ لون اليوم المحدد
//                 dayForegroundColor: MaterialStateProperty.resolveWith<Color?>((
//                   states,
//                 ) {
//                   if (states.contains(MaterialState.selected)) {
//                     return Colors.white;
//                   }
//                   return Colors.black;
//                 }),

//                 // ✅ لون الخلفية لليوم المحدد
//                 dayBackgroundColor: MaterialStateProperty.resolveWith<Color?>((
//                   states,
//                 ) {
//                   if (states.contains(MaterialState.selected)) {
//                     return ColorManager.primaryColor;
//                   }
//                   return null;
//                 }),

//                 // ✅ لون اليوم الحالي (Today)
//                 todayBackgroundColor: MaterialStateProperty.all(
//                   ColorManager.primaryColor.withOpacity(0.2),
//                 ),

//                 // ✅ لون رقم اليوم الحالي Today
//                 todayForegroundColor: MaterialStateProperty.all(
//                   ColorManager.primaryColor,
//                 ),
//               ),
//             ),
//             child: CalendarDatePicker(
//               initialDate: DateTime.now(),
//               firstDate: DateTime(2020),
//               lastDate: DateTime(2030),
//               currentDate: state.selectedDate,
//               onDateChanged:
//                   (d) => context.read<BookAppointmentCubit>().selectDate(d),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _hoursGrid(BuildContext context) {
//     return BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
//       builder: (_, state) {
//         return Wrap(
//           spacing: 7,
//           runSpacing: 12,
//           children:
//               hours.map((h) {
//                 final selected = state.selectedHour == h;

//                 return GestureDetector(
//                   onTap:
//                       () => context.read<BookAppointmentCubit>().selectHour(h),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 5,
//                       horizontal: 10,
//                     ),
//                     decoration: BoxDecoration(
//                       color: selected ? Colors.black : Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 10,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Text(
//                       h,
//                       style: TextStyle(
//                         color: selected ? Colors.white : Colors.black,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14.sp,
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//         );
//       },
//     );
//   }
// }

// class ColorManager {
//   static const Color primaryColor = Color(0xFF16202B); // لون التحديد الداكن
//   static const Color cardBg = Colors.white;
//   static const Color text = Color(0xFF222831);
//   static const Color muted = Color(0xFF9AA3AE);
// }

// class DatePickerCard extends StatelessWidget {
//   const DatePickerCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 430.h,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: ColorManager.cardBg,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 12,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
//         builder: (context, state) {
//           final focusedDay = state.selectedDate ?? DateTime.now();
//           final selected = state.selectedDate;

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // العنوان أعلى اليسار
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: Text(
//                   'Select Date',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: ColorManager.text,
//                   ),
//                 ),
//               ),

//               // البطاقة اللي فيها التقويم
//               Expanded(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 8.0,
//                     horizontal: 12.0,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: TableCalendar(
//                     firstDay: DateTime(2020),
//                     lastDay: DateTime(2030),
//                     focusedDay: focusedDay,
//                     selectedDayPredicate: (day) => isSameDay(day, selected),

//                     // عند اختيار يوم
//                     onDaySelected: (day, fDay) {
//                       context.read<BookAppointmentCubit>().selectDate(day);
//                     },

//                     // رأس التقويم (الشهر + أسهم)
//                     headerStyle: HeaderStyle(
//                       titleTextFormatter:
//                           (date, locale) =>
//                               '${_monthName(date.month)} ${date.year}', // أو استخدم intl
//                       formatButtonVisible: false,
//                       titleCentered: false, // عنوان على اليسار
//                       leftChevronVisible: true,
//                       rightChevronVisible: true,
//                       leftChevronIcon: const Icon(Icons.chevron_left, size: 22),
//                       rightChevronIcon: const Icon(
//                         Icons.chevron_right,
//                         size: 22,
//                       ),
//                       headerPadding: const EdgeInsets.symmetric(vertical: 6),
//                       titleTextStyle: TextStyle(
//                         color: ColorManager.text,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                       ),
//                       leftChevronPadding: const EdgeInsets.only(left: 8),
//                       decoration: BoxDecoration(color: Colors.white),
//                     ),

//                     daysOfWeekStyle: DaysOfWeekStyle(
//                       weekdayStyle: TextStyle(
//                         color: ColorManager.muted,
//                         fontWeight: FontWeight.w600,
//                       ),
//                       weekendStyle: TextStyle(
//                         color: ColorManager.muted,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),

//                     calendarStyle: CalendarStyle(
//                       // المسافة بين الأيام
//                       cellMargin: const EdgeInsets.symmetric(
//                         horizontal: 6,
//                         vertical: 6,
//                       ),

//                       // النص الافتراضي
//                       defaultTextStyle: TextStyle(
//                         color: ColorManager.text,
//                         fontSize: 14.sp,
//                       ),
//                       weekendTextStyle: TextStyle(color: ColorManager.text),

//                       // اليوم الحالي (Today) - subtle background
//                       todayDecoration: BoxDecoration(
//                         color: ColorManager.primaryColor.withOpacity(0.12),
//                         shape: BoxShape.rectangle,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       todayTextStyle: TextStyle(
//                         color: ColorManager.primaryColor,
//                         fontWeight: FontWeight.w700,
//                       ),

//                       // اليوم المحدد - مستطيل داكن ونص أبيض (مطابق للصورة)
//                       selectedDecoration: BoxDecoration(
//                         color: ColorManager.primaryColor,
//                         shape: BoxShape.rectangle,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       selectedTextStyle: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w700,
//                       ),

//                       // الشكل الافتراضي لخلية اليوم
//                       defaultDecoration: BoxDecoration(
//                         color: Colors.transparent,
//                         shape: BoxShape.rectangle,
//                       ),

//                       // نص الأيام المعطّلة
//                       outsideTextStyle: TextStyle(color: ColorManager.muted),
//                     ),

//                     // اجعل الأسبوع يبدأ من الأحد حسب الصورة
//                     startingDayOfWeek: StartingDayOfWeek.sunday,
//                     calendarFormat: CalendarFormat.month,
//                     // لتقليل padding داخلي
//                     rowHeight: 35,
//                     daysOfWeekHeight: 28,
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // دالة بسيطة لترجمة رقم الشهر إلى اسم إنجليزي قصير (يمكن استبدالها بـ intl)
//   String _monthName(int m) {
//     const names = [
//       '',
//       'January',
//       'February',
//       'March',
//       'April',
//       'May',
//       'June',
//       'July',
//       'August',
//       'September',
//       'October',
//       'November',
//       'December',
//     ];
//     return names[m];
//   }
// }

// class BookingPage extends StatefulWidget {
//   final List<WorkingHour> workingHours;
//   final String doctorId;

//   const BookingPage({
//     super.key,
//     required this.workingHours,
//     required this.doctorId,
//   });

//   @override
//   State<BookingPage> createState() => _BookingPageState();
// }

// class _BookingPageState extends State<BookingPage> {
//   WorkingHour? selectedDay;
//   String? selectedTime;

//   // تقسيم اليوم إلى مواعيد (كل 30 دقيقة)
//   List<String> generateSlots(String start, String end) {
//     final startDt = DateTime.parse(start);
//     final endDt = DateTime.parse(end);

//     final times = <String>[];
//     var current = startDt;

//     while (current.isBefore(endDt)) {
//       times.add(DateFormat('hh:mm a').format(current));
//       current = current.add(const Duration(minutes: 30));
//     }

//     return times;
//   }

//   // زر الحجز
//   void confirmBooking() {
//     if (selectedDay == null || selectedTime == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("اختر يوم ووقت أولاً")));
//       return;
//     }

//     // هنا تبعث API الحجز
//     // sendBooking(doctorId, selectedDay["date"], selectedTime);

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text("تم الحجز بنجاح")));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("حجز موعد")),
//       body: Column(
//         children: [
//           const SizedBox(height: 10),
//           const Text(
//             "اختر يوم العمل",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),

//           // قائمة الأيام
//           Expanded(
//             child: ListView.builder(
//               itemCount: widget.workingHours.length,
//               itemBuilder: (context, index) {
//                 final w = widget.workingHours[index];
//                 final date = DateTime.parse(w.startTime);
//                 final formatted = DateFormat('EEEE, dd MMM').format(date);

//                 return Card(
//                   child: ListTile(
//                     title: Text(formatted),
//                     subtitle: Text("المتبقي: ${w.patientLeft.toString()}"),
//                     onTap: () {
//                       setState(() {
//                         selectedDay = w;
//                         selectedTime = null;
//                       });
//                     },
//                     trailing:
//                         selectedDay == w
//                             ? const Icon(
//                               Icons.check_circle,
//                               color: Colors.green,
//                             )
//                             : null,
//                   ),
//                 );
//               },
//             ),
//           ),

//           if (selectedDay != null) ...[
//             const SizedBox(height: 10),
//             const Text(
//               "اختر الوقت",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),

//             // قائمة المواعيد
//             SizedBox(
//               height: 180,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 children:
//                     generateSlots(
//                       selectedDay!.startTime,
//                       selectedDay!.endTime,
//                     ).map((time) {
//                       final isSelected = time == selectedTime;
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() => selectedTime = time);
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 12,
//                           ),
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             color: isSelected ? Colors.blue : Colors.white,
//                             border: Border.all(
//                               color:
//                                   isSelected
//                                       ? Colors.blue
//                                       : Colors.grey.shade400,
//                             ),
//                           ),
//                           child: Center(
//                             child: Text(
//                               time,
//                               style: TextStyle(
//                                 color:
//                                     isSelected ? Colors.white : Colors.black87,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//               ),
//             ),
//           ],

//           // زر تأكيد الحجز
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: ElevatedButton(
//               onPressed: confirmBooking,
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               child: const Text("تأكيد الحجز", style: TextStyle(fontSize: 18)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
