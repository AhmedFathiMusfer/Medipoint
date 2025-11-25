import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat.state.dart';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/networking/errors/errorMesage.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';
import 'dart:developer';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(const ChatState.initial());

  final List<ChatMessage> _messages = [];
  final scrollController = ScrollController();

  String? _sessionId; // ✅ هنا نخزن session_id
  var chatMessageController = TextEditingController();

  List<ChatMessage> get messages => _messages;
  scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // ✅ إنشاء جلسة جديدة
  Future<void> createSession() async {
    emit(ChatState.loading());

    try {
      bool connected = await NetworkHelper.isConnected();
      if (!connected) {
        emit(ChatState.error("No internet connection"));
        return;
      }

      await RemoteProvider().send(
        request: Request(url: ApiConstants.chatEndpoint),
        method: RemoteMethod.get,
        onSuccess: (res, statusCode) {
          _sessionId = res.data['chatbot_session_id'];
          _messages.add(
            ChatMessage(
              text: "Hello! How can I assist you today?",
              isUser: false,
            ),
          );
          emit(ChatState.success(messages: List.from(_messages)));
        },
        onError: (res, statusCode) {
          emit(
            ChatState.error(ErrorMessages.instance.fromStatusCode(statusCode)),
          );
        },
      );
    } catch (e) {
      log(e.toString());
      emit(
        ChatState.error(
          ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
        ),
      );
    }
  }

  Future sendTextMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 1️⃣ إضافة رسالة المستخدم فوراً
    final userMessage = ChatMessage(text: text, isUser: true);
    _messages.add(userMessage);
    chatMessageController.clear();
    final loadingMessage = ChatMessage(
      text: "Typing...",
      isUser: false,
      isLoading: true,
    );
    _messages.add(loadingMessage);
    emit(ChatState.success(messages: List.from(_messages)));
    await scrollToBottom();
    await _sendMessageToApi(text);
  }

  Future<void> _sendMessageToApi(String text) async {
    try {
      final response = await RemoteProvider().send(
        request: Request(
          url: "${ApiConstants.chatEndpoint}$_sessionId/",
          body: {"message": text, "chatbot_session_id": _sessionId},
        ),
        method: RemoteMethod.post,
      );
      log("Response from API: ${response.data}");
      _messages.removeWhere((m) => m.isLoading == true);

      final botMessage = ChatMessage(
        text: response.data['response']['text'],
        isUser: false,
      );
      _messages.add(botMessage);
      emit(ChatState.success(messages: List.from(_messages)));
      await scrollToBottom();
    } catch (e) {
      _messages.removeWhere((m) => m.isLoading == true);
    }
  }

  // إنهاء الجلسة
  Future<void> endSession() async {
    if (_sessionId == null) return;

    try {
      await RemoteProvider().send(
        request: Request(url: "${ApiConstants.chatEndpoint}$_sessionId/end/"),
        method: RemoteMethod.post,
      );
      _sessionId = null;
      _messages.clear();
      emit(const ChatState.success(messages: []));
    } catch (e) {
      log(e.toString());
      emit(ChatState.error("Failed to end session"));
    }
  }

  // مسح الدردشة
  void clearChat() {
    _messages.clear();
    emit(const ChatState.success(messages: []));
  }
}
