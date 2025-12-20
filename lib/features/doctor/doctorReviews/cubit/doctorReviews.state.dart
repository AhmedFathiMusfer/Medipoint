import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'doctorReviews.state.freezed.dart';

@freezed
class DoctorReviewsState with _$DoctorReviewsState {
  const factory DoctorReviewsState.initial() = _Initial;
  const factory DoctorReviewsState.loading() = _Loading;

  const factory DoctorReviewsState.success({required List<Review> reviews}) =
      _Success;
  const factory DoctorReviewsState.error() = _Error;
}
