import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/features/ai/chat/cubit/chat.cubit.dart';
import 'package:diagno_bot/features/ai/chat/cubit/chat.state.dart';
import 'package:diagno_bot/features/ai/chat/view/widgets/chat_input.dart';
import 'package:diagno_bot/features/ai/chat/view/widgets/chat_message_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final chatCubit = context.read<ChatCubit>();

    return BaseView(
      title: 'Chat Bot'.tr(),
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
