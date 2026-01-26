import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/model/doctor.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'folder_sharing.state.freezed.dart';

@freezed
class FolderSharingState with _$FolderSharingState {
  const factory FolderSharingState.initial() = _Initial;
  const factory FolderSharingState.loading() = _Loading;
  const factory FolderSharingState.doctorsLoaded({
    required List<DoctorModel> doctors,
  }) = _DoctorsLoaded;
  const factory FolderSharingState.foldersLoaded({
    required List<PatientFolder> folders,
  }) = _FoldersLoaded;
  const factory FolderSharingState.success({String? message}) = _Success;
  const factory FolderSharingState.error({required String message}) = _Error;
}
