// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bookAppointment.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BookAppointmentState {
  DateTime? get selectedDate => throw _privateConstructorUsedError;
  String? get selectedHour => throw _privateConstructorUsedError;

  /// Create a copy of BookAppointmentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookAppointmentStateCopyWith<BookAppointmentState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookAppointmentStateCopyWith<$Res> {
  factory $BookAppointmentStateCopyWith(
    BookAppointmentState value,
    $Res Function(BookAppointmentState) then,
  ) = _$BookAppointmentStateCopyWithImpl<$Res, BookAppointmentState>;
  @useResult
  $Res call({DateTime? selectedDate, String? selectedHour});
}

/// @nodoc
class _$BookAppointmentStateCopyWithImpl<
  $Res,
  $Val extends BookAppointmentState
>
    implements $BookAppointmentStateCopyWith<$Res> {
  _$BookAppointmentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookAppointmentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? selectedDate = freezed, Object? selectedHour = freezed}) {
    return _then(
      _value.copyWith(
            selectedDate:
                freezed == selectedDate
                    ? _value.selectedDate
                    : selectedDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            selectedHour:
                freezed == selectedHour
                    ? _value.selectedHour
                    : selectedHour // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookAppointmentStateImplCopyWith<$Res>
    implements $BookAppointmentStateCopyWith<$Res> {
  factory _$$BookAppointmentStateImplCopyWith(
    _$BookAppointmentStateImpl value,
    $Res Function(_$BookAppointmentStateImpl) then,
  ) = __$$BookAppointmentStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime? selectedDate, String? selectedHour});
}

/// @nodoc
class __$$BookAppointmentStateImplCopyWithImpl<$Res>
    extends _$BookAppointmentStateCopyWithImpl<$Res, _$BookAppointmentStateImpl>
    implements _$$BookAppointmentStateImplCopyWith<$Res> {
  __$$BookAppointmentStateImplCopyWithImpl(
    _$BookAppointmentStateImpl _value,
    $Res Function(_$BookAppointmentStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookAppointmentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? selectedDate = freezed, Object? selectedHour = freezed}) {
    return _then(
      _$BookAppointmentStateImpl(
        selectedDate:
            freezed == selectedDate
                ? _value.selectedDate
                : selectedDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        selectedHour:
            freezed == selectedHour
                ? _value.selectedHour
                : selectedHour // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$BookAppointmentStateImpl implements _BookAppointmentState {
  const _$BookAppointmentStateImpl({this.selectedDate, this.selectedHour});

  @override
  final DateTime? selectedDate;
  @override
  final String? selectedHour;

  @override
  String toString() {
    return 'BookAppointmentState(selectedDate: $selectedDate, selectedHour: $selectedHour)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookAppointmentStateImpl &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            (identical(other.selectedHour, selectedHour) ||
                other.selectedHour == selectedHour));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selectedDate, selectedHour);

  /// Create a copy of BookAppointmentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookAppointmentStateImplCopyWith<_$BookAppointmentStateImpl>
  get copyWith =>
      __$$BookAppointmentStateImplCopyWithImpl<_$BookAppointmentStateImpl>(
        this,
        _$identity,
      );
}

abstract class _BookAppointmentState implements BookAppointmentState {
  const factory _BookAppointmentState({
    final DateTime? selectedDate,
    final String? selectedHour,
  }) = _$BookAppointmentStateImpl;

  @override
  DateTime? get selectedDate;
  @override
  String? get selectedHour;

  /// Create a copy of BookAppointmentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookAppointmentStateImplCopyWith<_$BookAppointmentStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
