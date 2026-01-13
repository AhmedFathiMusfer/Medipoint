import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/features/ai/chat/cubit/chat.state.dart';
import 'package:diagno_bot/features/ai/chat/view/chat.view.dart';
import 'package:diagno_bot/features/ai/chat/view/widgets/bot_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
