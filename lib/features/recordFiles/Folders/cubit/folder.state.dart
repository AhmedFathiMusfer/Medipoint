import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/database/tables/patient_folders_tables.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'folder.state.freezed.dart';

@freezed
class FolderState with _$FolderState {
  const factory FolderState.initial() = _Initial;
  const factory FolderState.loading() = _Loading;
  const factory FolderState.success({required List<PatientFolder> folders}) =
      _Success;
  const factory FolderState.error(String message) = _Error;
}
