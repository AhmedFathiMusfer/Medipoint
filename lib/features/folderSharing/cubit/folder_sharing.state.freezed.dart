// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'folder_sharing.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FolderSharingState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FolderSharingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FolderSharingState()';
}


}

/// @nodoc
class $FolderSharingStateCopyWith<$Res>  {
$FolderSharingStateCopyWith(FolderSharingState _, $Res Function(FolderSharingState) __);
}


/// Adds pattern-matching-related methods to [FolderSharingState].
extension FolderSharingStatePatterns on FolderSharingState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _DoctorsLoaded value)?  doctorsLoaded,TResult Function( _FoldersLoaded value)?  foldersLoaded,TResult Function( _Success value)?  success,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _DoctorsLoaded() when doctorsLoaded != null:
return doctorsLoaded(_that);case _FoldersLoaded() when foldersLoaded != null:
return foldersLoaded(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _DoctorsLoaded value)  doctorsLoaded,required TResult Function( _FoldersLoaded value)  foldersLoaded,required TResult Function( _Success value)  success,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _DoctorsLoaded():
return doctorsLoaded(_that);case _FoldersLoaded():
return foldersLoaded(_that);case _Success():
return success(_that);case _Error():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _DoctorsLoaded value)?  doctorsLoaded,TResult? Function( _FoldersLoaded value)?  foldersLoaded,TResult? Function( _Success value)?  success,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _DoctorsLoaded() when doctorsLoaded != null:
return doctorsLoaded(_that);case _FoldersLoaded() when foldersLoaded != null:
return foldersLoaded(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<DoctorModel> doctors)?  doctorsLoaded,TResult Function( List<PatientFolder> folders)?  foldersLoaded,TResult Function( String? message)?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _DoctorsLoaded() when doctorsLoaded != null:
return doctorsLoaded(_that.doctors);case _FoldersLoaded() when foldersLoaded != null:
return foldersLoaded(_that.folders);case _Success() when success != null:
return success(_that.message);case _Error() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<DoctorModel> doctors)  doctorsLoaded,required TResult Function( List<PatientFolder> folders)  foldersLoaded,required TResult Function( String? message)  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _DoctorsLoaded():
return doctorsLoaded(_that.doctors);case _FoldersLoaded():
return foldersLoaded(_that.folders);case _Success():
return success(_that.message);case _Error():
return error(_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<DoctorModel> doctors)?  doctorsLoaded,TResult? Function( List<PatientFolder> folders)?  foldersLoaded,TResult? Function( String? message)?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _DoctorsLoaded() when doctorsLoaded != null:
return doctorsLoaded(_that.doctors);case _FoldersLoaded() when foldersLoaded != null:
return foldersLoaded(_that.folders);case _Success() when success != null:
return success(_that.message);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements FolderSharingState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FolderSharingState.initial()';
}


}




/// @nodoc


class _Loading implements FolderSharingState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FolderSharingState.loading()';
}


}




/// @nodoc


class _DoctorsLoaded implements FolderSharingState {
  const _DoctorsLoaded({required final  List<DoctorModel> doctors}): _doctors = doctors;
  

 final  List<DoctorModel> _doctors;
 List<DoctorModel> get doctors {
  if (_doctors is EqualUnmodifiableListView) return _doctors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_doctors);
}


/// Create a copy of FolderSharingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoctorsLoadedCopyWith<_DoctorsLoaded> get copyWith => __$DoctorsLoadedCopyWithImpl<_DoctorsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DoctorsLoaded&&const DeepCollectionEquality().equals(other._doctors, _doctors));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_doctors));

@override
String toString() {
  return 'FolderSharingState.doctorsLoaded(doctors: $doctors)';
}


}

/// @nodoc
abstract mixin class _$DoctorsLoadedCopyWith<$Res> implements $FolderSharingStateCopyWith<$Res> {
  factory _$DoctorsLoadedCopyWith(_DoctorsLoaded value, $Res Function(_DoctorsLoaded) _then) = __$DoctorsLoadedCopyWithImpl;
@useResult
$Res call({
 List<DoctorModel> doctors
});




}
/// @nodoc
class __$DoctorsLoadedCopyWithImpl<$Res>
    implements _$DoctorsLoadedCopyWith<$Res> {
  __$DoctorsLoadedCopyWithImpl(this._self, this._then);

  final _DoctorsLoaded _self;
  final $Res Function(_DoctorsLoaded) _then;

/// Create a copy of FolderSharingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? doctors = null,}) {
  return _then(_DoctorsLoaded(
doctors: null == doctors ? _self._doctors : doctors // ignore: cast_nullable_to_non_nullable
as List<DoctorModel>,
  ));
}


}

/// @nodoc


class _FoldersLoaded implements FolderSharingState {
  const _FoldersLoaded({required final  List<PatientFolder> folders}): _folders = folders;
  

 final  List<PatientFolder> _folders;
 List<PatientFolder> get folders {
  if (_folders is EqualUnmodifiableListView) return _folders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_folders);
}


/// Create a copy of FolderSharingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoldersLoadedCopyWith<_FoldersLoaded> get copyWith => __$FoldersLoadedCopyWithImpl<_FoldersLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoldersLoaded&&const DeepCollectionEquality().equals(other._folders, _folders));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_folders));

@override
String toString() {
  return 'FolderSharingState.foldersLoaded(folders: $folders)';
}


}

/// @nodoc
abstract mixin class _$FoldersLoadedCopyWith<$Res> implements $FolderSharingStateCopyWith<$Res> {
  factory _$FoldersLoadedCopyWith(_FoldersLoaded value, $Res Function(_FoldersLoaded) _then) = __$FoldersLoadedCopyWithImpl;
@useResult
$Res call({
 List<PatientFolder> folders
});




}
/// @nodoc
class __$FoldersLoadedCopyWithImpl<$Res>
    implements _$FoldersLoadedCopyWith<$Res> {
  __$FoldersLoadedCopyWithImpl(this._self, this._then);

  final _FoldersLoaded _self;
  final $Res Function(_FoldersLoaded) _then;

/// Create a copy of FolderSharingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? folders = null,}) {
  return _then(_FoldersLoaded(
folders: null == folders ? _self._folders : folders // ignore: cast_nullable_to_non_nullable
as List<PatientFolder>,
  ));
}


}

/// @nodoc


class _Success implements FolderSharingState {
  const _Success({this.message});
  

 final  String? message;

/// Create a copy of FolderSharingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'FolderSharingState.success(message: $message)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $FolderSharingStateCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of FolderSharingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_Success(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Error implements FolderSharingState {
  const _Error({required this.message});
  

 final  String message;

/// Create a copy of FolderSharingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'FolderSharingState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $FolderSharingStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of FolderSharingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
