import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/features/ai/chat/cubit/chat.cubit.dart';
import 'package:diagno_bot/features/ai/chat/cubit/chat.state.dart';
import 'package:diagno_bot/features/bookAppointment/view/bookAppointment.view.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

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
                              msg.isUser ? Colors.black : Colors.grey.shade100,
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
                                        msg.isUser
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
                    // Call the sendTextMessage method from your ChatCubit or handle the send action here
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

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> messages = [];
  final TextEditingController textController = TextEditingController();

  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  bool isRecording = false;
  String? recordedFilePath;

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  Future<void> initRecorder() async {
    await Permission.microphone.request();
    await recorder.openRecorder();
  }

  Future<void> startRecording() async {
    final dir = await getTemporaryDirectory();
    recordedFilePath =
        "${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac";

    await recorder.startRecorder(
      toFile: recordedFilePath,
      codec: Codec.aacADTS,
    );

    setState(() => isRecording = true);
  }

  Future<void> stopRecording() async {
    await recorder.stopRecorder();
    setState(() => isRecording = false);

    if (recordedFilePath != null) {
      messages.add(
        ChatMessage(
          type: MessageType.audio,
          text: "",
          audioPath: recordedFilePath!,
        ),
      );
      setState(() {});
    }
  }

  void sendTextMessage() {
    if (textController.text.trim().isEmpty) return;

    messages.add(
      ChatMessage(type: MessageType.text, text: textController.text.trim()),
    );
    textController.clear();
    setState(() {});
  }

  void playAudio(String path) async {
    FlutterSoundPlayer player = FlutterSoundPlayer();
    await player.openPlayer();
    await player.startPlayer(fromURI: path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat Screen")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];

                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          msg.type == MessageType.text
                              ? ColorManager.primaryColor
                              : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        msg.type == MessageType.text
                            ? Text(
                              msg.text,
                              style: TextStyle(color: Colors.white),
                            )
                            : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.mic, color: Colors.blue),
                                const SizedBox(width: 10),
                                const Text("Audio Message"),
                                IconButton(
                                  icon: const Icon(Icons.play_arrow),
                                  onPressed: () => playAudio(msg.audioPath!),
                                ),
                              ],
                            ),
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: "Type message...",
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                GestureDetector(
                  onLongPressStart: (_) => startRecording(),
                  onLongPressEnd: (_) => stopRecording(),
                  child: CircleAvatar(
                    backgroundColor:
                        isRecording ? Colors.red : ColorManager.primaryColor,
                    child: const Icon(Icons.mic, color: Colors.white),
                  ),
                ),

                const SizedBox(width: 8),

                CircleAvatar(
                  backgroundColor: ColorManager.primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: sendTextMessage,
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

enum MessageType { text, audio }

class ChatMessage {
  final MessageType type;
  final String text;
  final String? audioPath;

  ChatMessage({required this.type, required this.text, this.audioPath});
}
