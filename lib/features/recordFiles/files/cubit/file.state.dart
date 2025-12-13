import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/database/tables/patient_folders_tables.dart';
import 'package:diagno_bot/features/recordFiles/files/cubit/fileUpload.state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'file.state.freezed.dart';

@freezed
class FileState with _$FileState {
  const factory FileState.initial() = _Initial;
  const factory FileState.loading() = _Loading;
  const factory FileState.success({
    required List<PatientFile> files,
    Map<String, FileUploadStatus>? uploads, // key = file id
  }) = _Success;
  const factory FileState.error(String message) = _Error;
}
