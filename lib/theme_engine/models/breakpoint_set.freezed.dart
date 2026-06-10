// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'breakpoint_set.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BreakpointSet _$BreakpointSetFromJson(Map<String, dynamic> json) {
  return _BreakpointSet.fromJson(json);
}

/// @nodoc
mixin _$BreakpointSet {
  Map<String, double> get breakpoints => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BreakpointSetCopyWith<BreakpointSet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreakpointSetCopyWith<$Res> {
  factory $BreakpointSetCopyWith(
          BreakpointSet value, $Res Function(BreakpointSet) then) =
      _$BreakpointSetCopyWithImpl<$Res, BreakpointSet>;
  @useResult
  $Res call({Map<String, double> breakpoints});
}

/// @nodoc
class _$BreakpointSetCopyWithImpl<$Res, $Val extends BreakpointSet>
    implements $BreakpointSetCopyWith<$Res> {
  _$BreakpointSetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? breakpoints = null,
  }) {
    return _then(_value.copyWith(
      breakpoints: null == breakpoints
          ? _value.breakpoints
          : breakpoints // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BreakpointSetImplCopyWith<$Res>
    implements $BreakpointSetCopyWith<$Res> {
  factory _$$BreakpointSetImplCopyWith(
          _$BreakpointSetImpl value, $Res Function(_$BreakpointSetImpl) then) =
      __$$BreakpointSetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, double> breakpoints});
}

/// @nodoc
class __$$BreakpointSetImplCopyWithImpl<$Res>
    extends _$BreakpointSetCopyWithImpl<$Res, _$BreakpointSetImpl>
    implements _$$BreakpointSetImplCopyWith<$Res> {
  __$$BreakpointSetImplCopyWithImpl(
      _$BreakpointSetImpl _value, $Res Function(_$BreakpointSetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? breakpoints = null,
  }) {
    return _then(_$BreakpointSetImpl(
      breakpoints: null == breakpoints
          ? _value._breakpoints
          : breakpoints // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BreakpointSetImpl implements _BreakpointSet {
  const _$BreakpointSetImpl({final Map<String, double> breakpoints = const {}})
      : _breakpoints = breakpoints;

  factory _$BreakpointSetImpl.fromJson(Map<String, dynamic> json) =>
      _$$BreakpointSetImplFromJson(json);

  final Map<String, double> _breakpoints;
  @override
  @JsonKey()
  Map<String, double> get breakpoints {
    if (_breakpoints is EqualUnmodifiableMapView) return _breakpoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_breakpoints);
  }

  @override
  String toString() {
    return 'BreakpointSet(breakpoints: $breakpoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreakpointSetImpl &&
            const DeepCollectionEquality()
                .equals(other._breakpoints, _breakpoints));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_breakpoints));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BreakpointSetImplCopyWith<_$BreakpointSetImpl> get copyWith =>
      __$$BreakpointSetImplCopyWithImpl<_$BreakpointSetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BreakpointSetImplToJson(
      this,
    );
  }
}

abstract class _BreakpointSet implements BreakpointSet {
  const factory _BreakpointSet({final Map<String, double> breakpoints}) =
      _$BreakpointSetImpl;

  factory _BreakpointSet.fromJson(Map<String, dynamic> json) =
      _$BreakpointSetImpl.fromJson;

  @override
  Map<String, double> get breakpoints;
  @override
  @JsonKey(ignore: true)
  _$$BreakpointSetImplCopyWith<_$BreakpointSetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
