import 'package:diagno_bot/core/model/doctor.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'chat.state.freezed.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isLoading;
  final bool isErorr;
  final String? specialty;
  final bool? isDetected;
  final bool? isExisted;
  final List<DoctorModel>? doctors;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isLoading = false,
    this.isErorr = false,
    this.specialty,
    this.isDetected,
    this.isExisted,
    this.doctors,
  });
}

@freezed
class ChatState with _$ChatState {
  const factory ChatState.initial() = _Initial;
  const factory ChatState.loading() = _Loading;
  const factory ChatState.success({required List<ChatMessage> messages}) =
      _Success;
  const factory ChatState.error(String message) = _Error;
}
