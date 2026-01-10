import 'package:cached_network_image/cached_network_image.dart';
import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/model/doctor.model.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/features/ai/chat/cubit/chat.cubit.dart';
import 'package:diagno_bot/features/ai/chat/cubit/chat.state.dart';
import 'package:diagno_bot/features/ai/chat/view/widgets/chat_doctor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final chatCubit = context.read<ChatCubit>();

    return BaseView(
      title: 'HealthPal',
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                final messages = state.maybeMap(
                  success: (s) => s.messages,
                  orElse: () => [],
                );

                return ListView.builder(
                  controller: chatCubit.scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (_, i) {
                    return ChatMessageItem(message: messages[i]);
                  },
                );
              },
            ),
          ),
          const ChatInput(),
        ],
      ),
    );
  }
}

class ChatMessageItem extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.doctors != null) {
      return BotMessageWidget(message: message);
    }

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.black : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child:
            message.isLoading
                ? SizedBox(
                  width: 16,
                  height: 16,
                  child: LoadingAnimationWidget.waveDots(
                    color: ColorManager.primaryColor,
                    size: 16,
                  ),
                )
                : Text(
                  message.text,
                  style: TextStyle(
                    color: message.isUser ? Colors.white : Colors.black,
                  ),
                ),
      ),
    );
  }
}

class BotMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const BotMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.text.isNotEmpty && message.doctors!.isEmpty)
          _BotBubble(text: message.text),

        if (message.isDetected == true && message.specialty != null)
          // DiagnosisTagWidget(specialty: message.specialty!),
          if (message.isExisted == false) const _NoDoctorsWidget(),

        if (message.isExisted == true &&
            message.doctors != null &&
            message.doctors!.isNotEmpty)
          DoctorsSection(
            doctors: message.doctors!,
            specialty: message.specialty ?? '',
          ),
      ],
    );
  }
}

class _NoDoctorsWidget extends StatelessWidget {
  const _NoDoctorsWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange.shade300, width: 1.2),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.orange.shade100,
              child: Icon(Icons.info_outline, color: Colors.orange.shade800),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                "No doctors found for this specialty",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BotBubble extends StatelessWidget {
  final String text;

  const _BotBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black87, height: 1.4),
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routers.doctorDetailsView, arguments: doctor.userId);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 10.r),
          decoration: BoxDecoration(
            color: ColorManager.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(
              color: ColorManager.primaryColor.withOpacity(0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50.r),
                child: CachedNetworkImage(
                  imageUrl: doctor.image ?? '',
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                  errorWidget: (context, error, stackTrace) {
                    return Image.asset(
                      width: 20,
                      height: 20,
                      "assets/image/default_doctor_image.jpg",
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              8.horizontalSpace,
              Text(
                doctor.fullName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorManager.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DoctorsSection extends StatelessWidget {
  final List<DoctorModel> doctors;
  final String specialty;
  const DoctorsSection({
    super.key,
    required this.doctors,
    required this.specialty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recommended Doctors${specialty.isNotEmpty ? " for the $specialty" : ''}",
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
          12.verticalSpace,
          Wrap(
            direction: Axis.horizontal,
            spacing: 8,
            children: [
              ...doctors.map((doctor) {
                return DoctorCard(doctor: doctor);
              }),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatInput extends StatelessWidget {
  const ChatInput({super.key});

  @override
  Widget build(BuildContext context) {
    final chatCubit = context.read<ChatCubit>();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: chatCubit.chatMessageController,
              decoration: InputDecoration(
                hintText: "Ask anything",
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () async {
              await chatCubit.sendTextMessage(
                chatCubit.chatMessageController.text.trim(),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// class ChatView extends StatelessWidget {
//   const ChatView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var chatCubit = context.read<ChatCubit>();
//     return BaseView(
//       title: 'HealthPal',
//       child: Column(
//         children: [
//           Expanded(
//             child: BlocBuilder<ChatCubit, ChatState>(
//               builder: (context, state) {
//                 final messages = state.maybeMap(
//                   success: (s) => s.messages,
//                   orElse: () => [],
//                 );

//                 return ListView.builder(
//                   controller: chatCubit.scrollController,
//                   padding: const EdgeInsets.all(16),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final msg = messages[index];

//                     // If message has doctors list, show them
//                     if (msg.doctors != null && msg.doctors!.isNotEmpty) {
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Show text message if exists
//                           if (msg.text.isNotEmpty)
//                             Align(
//                               alignment: Alignment.centerLeft,
//                               child: Container(
//                                 margin: const EdgeInsets.only(bottom: 12),
//                                 padding: const EdgeInsets.all(12),
//                                 decoration: BoxDecoration(
//                                   color:
//                                       msg.isErorr
//                                           ? Colors.red
//                                           : Colors.grey.shade100,
//                                   borderRadius: BorderRadius.circular(16),
//                                 ),
//                                 child: Text(
//                                   msg.text,
//                                   style: TextStyle(
//                                     color:
//                                         msg.isErorr
//                                             ? Colors.white
//                                             : Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ),

//                           // Show specialty info if detected (tag style)
//                           if (msg.isDetected == true && msg.specialty != null)
//                             Padding(
//                               padding: EdgeInsets.only(bottom: 12.h, top: 4.h),
//                               child: Align(
//                                 alignment: Alignment.centerLeft,
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 14.r,
//                                     vertical: 10.r,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: [
//                                         ColorManager.primaryColor.withOpacity(
//                                           0.15,
//                                         ),
//                                         ColorManager.primaryColor.withOpacity(
//                                           0.08,
//                                         ),
//                                       ],
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomRight,
//                                     ),
//                                     borderRadius: BorderRadius.circular(25.r),
//                                     border: Border.all(
//                                       color: ColorManager.primaryColor
//                                           .withOpacity(0.4),
//                                       width: 1.5,
//                                     ),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: ColorManager.primaryColor
//                                             .withOpacity(0.1),
//                                         blurRadius: 8,
//                                         offset: const Offset(0, 2),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Container(
//                                         padding: EdgeInsets.all(4.r),
//                                         decoration: BoxDecoration(
//                                           color: ColorManager.primaryColor
//                                               .withOpacity(0.2),
//                                           shape: BoxShape.circle,
//                                         ),
//                                         child: Icon(
//                                           Icons.medical_services_rounded,
//                                           size: 16.sp,
//                                           color: ColorManager.primaryColor,
//                                         ),
//                                       ),
//                                       10.horizontalSpace,
//                                       Text(
//                                         msg.specialty!,
//                                         style: TextStyle(
//                                           fontSize: 13.sp,
//                                           color: ColorManager.primaryColor,
//                                           fontWeight: FontWeight.bold,
//                                           letterSpacing: 0.3,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),

//                           // Show message if no doctors exist
//                           if (msg.isExisted == false)
//                             Padding(
//                               padding: EdgeInsets.only(bottom: 12.h, top: 8.h),
//                               child: Container(
//                                 padding: EdgeInsets.all(16.r),
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       Colors.orange.shade50,
//                                       Colors.orange.shade50,
//                                     ],
//                                     begin: Alignment.topLeft,
//                                     end: Alignment.bottomRight,
//                                   ),
//                                   borderRadius: BorderRadius.circular(20.r),
//                                   border: Border.all(
//                                     color: Colors.orange.shade300,
//                                     width: 1.5,
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.orange.withOpacity(0.15),
//                                       blurRadius: 10,
//                                       offset: const Offset(0, 4),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       padding: EdgeInsets.all(8.r),
//                                       decoration: BoxDecoration(
//                                         color: Colors.orange.shade100,
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: Icon(
//                                         Icons.info_outline_rounded,
//                                         size: 20.sp,
//                                         color: Colors.orange.shade800,
//                                       ),
//                                     ),
//                                     12.horizontalSpace,
//                                     Expanded(
//                                       child: Text(
//                                         'No doctors found for this specialty',
//                                         style: TextStyle(
//                                           color: Colors.orange.shade800,
//                                           fontSize: 14.sp,
//                                           fontWeight: FontWeight.w600,
//                                           letterSpacing: 0.2,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),

//                           // Show doctors list
//                           if (msg.isExisted == true &&
//                               msg.doctors != null &&
//                               msg.doctors!.isNotEmpty)
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                     bottom: 12.h,
//                                     top: 8.h,
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         padding: EdgeInsets.all(6.r),
//                                         decoration: BoxDecoration(
//                                           color: ColorManager.primaryColor
//                                               .withOpacity(0.1),
//                                           borderRadius: BorderRadius.circular(
//                                             8.r,
//                                           ),
//                                         ),
//                                         child: Icon(
//                                           Icons.people_rounded,
//                                           size: 18.sp,
//                                           color: ColorManager.primaryColor,
//                                         ),
//                                       ),
//                                       10.horizontalSpace,
//                                       Text(
//                                         'Available Doctors',
//                                         style: TextStyle(
//                                           fontSize: 16.sp,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.black87,
//                                           letterSpacing: 0.3,
//                                         ),
//                                       ),
//                                       Expanded(child: SizedBox()),
//                                       Container(
//                                         padding: EdgeInsets.symmetric(
//                                           horizontal: 10.r,
//                                           vertical: 4.r,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: ColorManager.primaryColor,
//                                           borderRadius: BorderRadius.circular(
//                                             12.r,
//                                           ),
//                                         ),
//                                         child: Text(
//                                           '${msg.doctors!.length}',
//                                           style: TextStyle(
//                                             fontSize: 12.sp,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Wrap(
//                                   children: [
//                                     ...msg.doctors!.map(
//                                       (doctor) => DoctorBadge(doctor: doctor),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                         ],
//                       );
//                     }

//                     // Normal message display
//                     return Align(
//                       alignment:
//                           msg.isUser
//                               ? Alignment.centerRight
//                               : Alignment.centerLeft,
//                       child: Container(
//                         margin: const EdgeInsets.only(bottom: 12),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color:
//                               msg.isErorr
//                                   ? Colors.red
//                                   : msg.isUser
//                                   ? Colors.black
//                                   : Colors.grey.shade100,
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child:
//                             msg.isLoading == true
//                                 ? Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     SizedBox(
//                                       width: 16,
//                                       height: 16,
//                                       child: LoadingAnimationWidget.waveDots(
//                                         color: ColorManager.primaryColor,
//                                         size: 16,
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                                 : Text(
//                                   msg.text,
//                                   style: TextStyle(
//                                     color:
//                                         msg.isErorr
//                                             ? Colors.white
//                                             : msg.isUser
//                                             ? Colors.white
//                                             : Colors.black,
//                                   ),
//                                 ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: chatCubit.chatMessageController,
//                     decoration: InputDecoration(
//                       hintText: "Ask anything",
//                       filled: true,
//                       fillColor: Colors.grey.shade100,
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 GestureDetector(
//                   onTap: () async {
//                     await chatCubit.sendTextMessage(
//                       chatCubit.chatMessageController.text.trim(),
//                     );
//                   },
//                   child: CircleAvatar(
//                     backgroundColor: Colors.black,
//                     child: Icon(Icons.send, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
