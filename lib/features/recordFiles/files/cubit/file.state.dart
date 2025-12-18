import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'file.state.freezed.dart';

@freezed
class FileState with _$FileState {
  const factory FileState.initial() = _Initial;
  const factory FileState.loading() = _Loading;
  const factory FileState.success({
    required List<PatientFile> files,
    @Default({}) Map<int, double> downloadsProgress,
    double? uploadProgress,
  }) = _Success;
  const factory FileState.error(String message) = _Error;
}
