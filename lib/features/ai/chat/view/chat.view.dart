import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/features/bookAppointment/view/bookAppointment.view.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'HealthPal',
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ✅ User message bubble
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "My left eye hurts me",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ✅ Bot response
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text("""
Thank you for clarifying 🙏. Pain inside the eye can have several causes:

• Eye strain or dryness  
• Infection or inflammation  
• Glaucoma  
• Injury or small foreign body  

👆 The best specialist for this is an ophthalmologist.

⚠️ If you notice sudden vision loss, halos, severe headache or very high pain, seek urgent medical care immediately.
""", style: TextStyle(fontSize: 15, height: 1.4)),
                ),
              ],
            ),
          ),

          // ✅ Input Field
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
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Icon(Icons.send, color: Colors.white),
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
