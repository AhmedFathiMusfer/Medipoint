import 'package:freezed_annotation/freezed_annotation.dart';
part 'fileUpload.state.freezed.dart';

@freezed
class FileUploadStatus with _$FileUploadStatus {
  const factory FileUploadStatus.idle() = _Idle;
  const factory FileUploadStatus.uploading(double progress) = _Uploading;
  const factory FileUploadStatus.success() = _Success;
  const factory FileUploadStatus.failed() = _Failed;
}
