import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment_details.state.freezed.dart';

@freezed
class AppointmentDetailsState with _$AppointmentDetailsState {
  const factory AppointmentDetailsState.initial() = _Initial;
  const factory AppointmentDetailsState.loading() = _Loading;
  const factory AppointmentDetailsState.success({
    required List<PatientSharedFolder> sharedFolders,
    required List<PatientFolder> folderDetails,
  }) = _Success;
  const factory AppointmentDetailsState.error({required String message}) =
      _Error;
}
