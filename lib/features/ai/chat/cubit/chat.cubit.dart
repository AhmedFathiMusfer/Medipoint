import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat.state.dart';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/networking/errors/errorMesage.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';
import 'package:diagno_bot/core/model/doctor.model.dart';

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
      _messages.add(ChatMessage(text: "greeting_ai".tr(), isUser: false));
      if (!isClosed) {
        emit(ChatState.success(messages: List.from(_messages)));
      }
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
            text: "No internet connection".tr(),
            isErorr: true,
            isUser: false,
          ),
        );
        if (!isClosed) {
          emit(ChatState.success(messages: List.from(_messages)));
        }
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
    if (_messages.last.isLoading == true) return;
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
    if (!isClosed) {
      emit(ChatState.success(messages: List.from(_messages)));
    }
    await scrollToBottom();
    await checkIfSessionIsExitOrNo();
    await _sendMessageToApi(text);
  }

  Future<void> _sendMessageToApi(String text) async {
    try {
      bool connected = await NetworkHelper.isConnected();
      if (!connected) {
        _messages.removeWhere((m) => m.isLoading == true);
        if (!isClosed) {
          emit(ChatState.success(messages: List.from(_messages)));
        }

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

      // Handle response data
      final responseData = response.data['response'];
      final textMessage = responseData['text'] ?? '';
      final specialty = responseData['specialty'];
      final isDetected = responseData['is_detected'] as bool?;
      final isExisted = responseData['is_existed'] as bool?;

      // Parse doctors list if exists
      List<DoctorModel>? doctors;
      if (isExisted == true && responseData['doctors'] != null) {
        try {
          doctors =
              (responseData['doctors'] as List).map((doctorJson) {
                // Convert snake_case API format to camelCase for DoctorModel
                final userJson = doctorJson['user'] ?? {};
                final convertedJson = {
                  'userId': userJson['id'] ?? doctorJson['user_id'],
                  'fullName': userJson['full_name'] ?? doctorJson['full_name'],
                  'role': userJson['role'] ?? doctorJson['role'],
                  'email': userJson['email'] ?? doctorJson['email'],
                  'image': userJson['image'] ?? doctorJson['image'],
                  'gender': userJson['gender'] ?? doctorJson['gender'],
                  'dob': userJson['dob'] ?? doctorJson['dob'],
                  'fees': doctorJson['fees'] ?? '',
                  'experience': doctorJson['experience'] ?? '',
                  'education': doctorJson['education'] ?? '',
                  'specialty': doctorJson['specialty'] ?? '',
                  'about': doctorJson['about'],
                  'rating': doctorJson['rating'],
                  'reviews': doctorJson['reviews'],
                  'addressLine1': doctorJson['address_line1'],
                  'addressLine2': doctorJson['address_line2'],
                  'status': doctorJson['status'] ?? 'A',
                  'isVerified': doctorJson['is_verified'] ?? false,
                  'degreeDocument': doctorJson['degree_document'],
                };
                return DoctorModel.fromJson(convertedJson);
              }).toList();
        } catch (e) {
          // Handle parsing error if needed
          print('Error parsing doctors: $e');
        }
      }

      final botMessage = ChatMessage(
        text: textMessage,
        isUser: false,
        specialty: specialty,
        isDetected: isDetected,
        isExisted: isExisted,
        doctors: doctors,
      );
      _messages.add(botMessage);
      if (!isClosed) {
        emit(ChatState.success(messages: List.from(_messages)));
      }
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
      if (!isClosed) {
        emit(ChatState.success(messages: List.from(_messages)));
      }
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
      if (!isClosed) {
        emit(const ChatState.success(messages: []));
      }
    } catch (e) {
      AppSnackBar.error("Failed to end session");
    }
  }

  void clearChat() {
    _messages.clear();
    if (!isClosed) {
      emit(const ChatState.success(messages: []));
    }
  }
}
