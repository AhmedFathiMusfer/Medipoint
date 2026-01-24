// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginState()';
}


}

/// @nodoc
class $LoginStateCopyWith<$Res>  {
$LoginStateCopyWith(LoginState _, $Res Function(LoginState) __);
}


/// Adds pattern-matching-related methods to [LoginState].
extension LoginStatePatterns on LoginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loding value)?  loding,TResult Function( _VerifyEmail value)?  verifyEmail,TResult Function( _LoginSuccess value)?  loginSuccess,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loding() when loding != null:
return loding(_that);case _VerifyEmail() when verifyEmail != null:
return verifyEmail(_that);case _LoginSuccess() when loginSuccess != null:
return loginSuccess(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loding value)  loding,required TResult Function( _VerifyEmail value)  verifyEmail,required TResult Function( _LoginSuccess value)  loginSuccess,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loding():
return loding(_that);case _VerifyEmail():
return verifyEmail(_that);case _LoginSuccess():
return loginSuccess(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loding value)?  loding,TResult? Function( _VerifyEmail value)?  verifyEmail,TResult? Function( _LoginSuccess value)?  loginSuccess,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loding() when loding != null:
return loding(_that);case _VerifyEmail() when verifyEmail != null:
return verifyEmail(_that);case _LoginSuccess() when loginSuccess != null:
return loginSuccess(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( bool loading)?  loding,TResult Function()?  verifyEmail,TResult Function()?  loginSuccess,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loding() when loding != null:
return loding(_that.loading);case _VerifyEmail() when verifyEmail != null:
return verifyEmail();case _LoginSuccess() when loginSuccess != null:
return loginSuccess();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( bool loading)  loding,required TResult Function()  verifyEmail,required TResult Function()  loginSuccess,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loding():
return loding(_that.loading);case _VerifyEmail():
return verifyEmail();case _LoginSuccess():
return loginSuccess();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( bool loading)?  loding,TResult? Function()?  verifyEmail,TResult? Function()?  loginSuccess,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loding() when loding != null:
return loding(_that.loading);case _VerifyEmail() when verifyEmail != null:
return verifyEmail();case _LoginSuccess() when loginSuccess != null:
return loginSuccess();case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements LoginState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginState.initial()';
}


}




/// @nodoc


class _Loding implements LoginState {
  const _Loding({this.loading = false});
  

@JsonKey() final  bool loading;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LodingCopyWith<_Loding> get copyWith => __$LodingCopyWithImpl<_Loding>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loding&&(identical(other.loading, loading) || other.loading == loading));
}


@override
int get hashCode => Object.hash(runtimeType,loading);

@override
String toString() {
  return 'LoginState.loding(loading: $loading)';
}


}

/// @nodoc
abstract mixin class _$LodingCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory _$LodingCopyWith(_Loding value, $Res Function(_Loding) _then) = __$LodingCopyWithImpl;
@useResult
$Res call({
 bool loading
});




}
/// @nodoc
class __$LodingCopyWithImpl<$Res>
    implements _$LodingCopyWith<$Res> {
  __$LodingCopyWithImpl(this._self, this._then);

  final _Loding _self;
  final $Res Function(_Loding) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? loading = null,}) {
  return _then(_Loding(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _VerifyEmail implements LoginState {
  const _VerifyEmail();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerifyEmail);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginState.verifyEmail()';
}


}




/// @nodoc


class _LoginSuccess implements LoginState {
  const _LoginSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginState.loginSuccess()';
}


}




// dart format on
