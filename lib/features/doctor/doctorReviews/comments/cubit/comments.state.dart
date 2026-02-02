import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comments.state.freezed.dart';

@freezed
class CommentsState with _$CommentsState {
  const factory CommentsState.initial() = _Initial;
  const factory CommentsState.loading() = _Loading;
  const factory CommentsState.success(List<Comment> comments) = _Success;
  const factory CommentsState.error() = _Error;
}
