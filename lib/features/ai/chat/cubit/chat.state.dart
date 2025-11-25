import 'package:freezed_annotation/freezed_annotation.dart';
part 'chat.state.freezed.dart';

class ChatMessage {
  final String text;
  final bool isUser; // ✅ جديد: true = رسالة المستخدم، false = رد AI
  final bool isLoading; // ✅ جديد: true = رسالة تحميل (Typing...)

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isLoading = false,
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
