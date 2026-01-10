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
// ChatMessage(
//           text: "Hello! How can I assist you today?",
//           isUser: false,
//           isDetected: true,
//           isExisted: true,
//           doctors:
//               ([
//                         {
//                           "user": {
//                             "id": "dbe07302-b4dc-4b1a-9826-ebd3f306ec5d",
//                             "role": "D",
//                             "email": "michael-johnson@hospital.com",
//                             "image": null,
//                             "full_name": "Dr. Michael Johnson",
//                             "gender": "M",
//                             "dob": null,
//                           },
//                           "specialty": "Neurologist",
//                           "experience": "10 Years",
//                           "fees": "100.00",
//                           "rating": 0.0,
//                         },
//                         {
//                           "user": {
//                             "id": "77b5909f-39a3-45cb-b1f6-e8804d33b57d",
//                             "role": "D",
//                             "email": "ethan-clark@hospital.com",
//                             "image": null,
//                             "full_name": "Dr. Ethan Clark",
//                             "gender": "M",
//                             "dob": null,
//                           },
//                           "specialty": "Neurologist",
//                           "experience": "6 Years",
//                           "fees": "85.00",
//                           "rating": 0.0,
//                         },
//                         {
//                           "user": {
//                             "id": "6c329cff-3300-411e-884e-aa9ab6366532",
//                             "role": "D",
//                             "email": "isabella-hall@hospital.com",
//                             "image": null,
//                             "full_name": "Dr. Isabella Hall",
//                             "gender": "M",
//                             "dob": null,
//                           },
//                           "specialty": "Neurologist",
//                           "experience": "9 Years",
//                           "fees": "100.00",
//                           "rating": 0.0,
//                         },
//                       ]
//                       as List)
//                   .map((doctorJson) {
//                     // Convert snake_case API format to camelCase for DoctorModel
//                     final userJson = doctorJson['user'] ?? {};
//                     final convertedJson = {
//                       'userId': userJson['id'] ?? doctorJson['user_id'],
//                       'fullName':
//                           userJson['full_name'] ?? doctorJson['full_name'],
//                       'role': userJson['role'] ?? doctorJson['role'],
//                       'email': userJson['email'] ?? doctorJson['email'],
//                       'image': userJson['image'] ?? doctorJson['image'],
//                       'gender': userJson['gender'] ?? doctorJson['gender'],
//                       'dob': userJson['dob'] ?? doctorJson['dob'],
//                       'fees': doctorJson['fees'] ?? '',
//                       'experience': doctorJson['experience'] ?? '',
//                       'education': doctorJson['education'] ?? '',
//                       'specialty': doctorJson['specialty'] ?? '',
//                       'about': doctorJson['about'],
//                       'rating': doctorJson['rating'],
//                       'reviews': doctorJson['reviews'],
//                       'addressLine1': doctorJson['address_line1'],
//                       'addressLine2': doctorJson['address_line2'],
//                       'status': doctorJson['status'] ?? 'A',
//                       'isVerified': doctorJson['is_verified'] ?? false,
//                       'degreeDocument': doctorJson['degree_document'],
//                     };
//                     return DoctorModel.fromJson(convertedJson);
//                   })
//                   .toList(),
//         ),
//       );