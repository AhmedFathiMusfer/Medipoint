import 'package:diagno_bot/features/ai/chat/cubit/chat.state.dart';
import 'package:diagno_bot/features/ai/chat/view/chat.view.dart';
import 'package:diagno_bot/features/ai/chat/view/widgets/bot_bubble.dart';
import 'package:diagno_bot/features/ai/chat/view/widgets/doctors_section.dart';
import 'package:diagno_bot/features/ai/chat/view/widgets/no_doctors_widget.dart';
import 'package:flutter/material.dart';

class BotMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const BotMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.text.isNotEmpty && message.doctors!.isEmpty)
          BotBubble(text: message.text),

        if (message.isDetected == true && message.specialty != null)
          // DiagnosisTagWidget(specialty: message.specialty!),
          if (message.isExisted == false) const NoDoctorsWidget(),

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
