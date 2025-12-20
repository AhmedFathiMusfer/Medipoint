import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/features/ai/chat/cubit/chat.cubit.dart';
import 'package:diagno_bot/features/ai/chat/cubit/chat.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    var chatCubit = context.read<ChatCubit>();
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
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return Align(
                      alignment:
                          msg.isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              msg.isErorr
                                  ? Colors.red
                                  : msg.isUser
                                  ? Colors.black
                                  : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child:
                            msg.isLoading == true
                                ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: LoadingAnimationWidget.waveDots(
                                        color: ColorManager.primaryColor,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                )
                                : Text(
                                  msg.text,
                                  style: TextStyle(
                                    color:
                                        msg.isErorr
                                            ? Colors.white
                                            : msg.isUser
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
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
          ),
        ],
      ),
    );
  }
}
