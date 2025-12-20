import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat.state.dart';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/networking/errors/errorMesage.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(const ChatState.initial());

  final List<ChatMessage> _messages = [];
  final scrollController = ScrollController();

  String? _sessionId;
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

  checkIfSessionIsExitOrNo() async {
    if (_messages.isEmpty) {
      _messages.add(
        ChatMessage(text: "Hello! How can I assist you today?", isUser: false),
      );
      emit(ChatState.success(messages: List.from(_messages)));
    }
    if (_sessionId == null) {
      await createSession();
    }
  }

  Future<void> createSession() async {
    try {
      bool connected = await NetworkHelper.isConnected();
      if (!connected) {
        _messages.add(
          ChatMessage(
            text: "No internet connection",
            isErorr: true,
            isUser: false,
          ),
        );
        emit(ChatState.success(messages: List.from(_messages)));
        return;
      }

      await RemoteProvider().send(
        request: Request(url: ApiConstants.chatEndpoint),
        method: RemoteMethod.get,
        onSuccess: (res, statusCode) {
          _sessionId = res.data['chatbot_session_id'];
        },
        onError: (res, statusCode) {
          AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statusCode));
        },
      );
    } catch (e) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
      );
    }
  }

  Future sendTextMessage(String text) async {
    chatMessageController.clear();
    if (text.trim().isEmpty) return;
    final userMessage = ChatMessage(text: text, isUser: true);
    _messages.add(userMessage);
    final loadingMessage = ChatMessage(
      text: "Typing...",
      isUser: false,
      isLoading: true,
    );
    _messages.add(loadingMessage);
    emit(ChatState.success(messages: List.from(_messages)));
    await scrollToBottom();
    await checkIfSessionIsExitOrNo();
    await _sendMessageToApi(text);
  }

  Future<void> _sendMessageToApi(String text) async {
    try {
      bool connected = await NetworkHelper.isConnected();
      if (!connected) {
        _messages.removeWhere((m) => m.isLoading == true);
        emit(ChatState.success(messages: List.from(_messages)));

        AppSnackBar.error(
          ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection),
        );
        return;
      }
      final response = await RemoteProvider().send(
        request: Request(
          url: "${ApiConstants.chatEndpoint}$_sessionId/",
          body: {"message": text, "chatbot_session_id": _sessionId},
        ),
        method: RemoteMethod.post,
      );
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
      _messages.add(
        ChatMessage(
          text: ErrorMessages.instance.fromExceptionType(
            ExceptionTypes.unexpected,
          ),
          isErorr: true,
          isUser: false,
        ),
      );
      emit(ChatState.success(messages: List.from(_messages)));
    }
  }

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
      AppSnackBar.error("Failed to end session");
    }
  }

  void clearChat() {
    _messages.clear();
    emit(const ChatState.success(messages: []));
  }
}
