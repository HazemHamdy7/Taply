// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'radius_set.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RadiusSet _$RadiusSetFromJson(Map<String, dynamic> json) {
  return _RadiusSet.fromJson(json);
}

/// @nodoc
mixin _$RadiusSet {
  String get none => throw _privateConstructorUsedError;
  String get sm => throw _privateConstructorUsedError;
  String get md => throw _privateConstructorUsedError;
  String get lg => throw _privateConstructorUsedError;
  String get xl => throw _privateConstructorUsedError;
  String get full => throw _privateConstructorUsedError;
  Map<String, String> get custom => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RadiusSetCopyWith<RadiusSet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RadiusSetCopyWith<$Res> {
  factory $RadiusSetCopyWith(RadiusSet value, $Res Function(RadiusSet) then) =
      _$RadiusSetCopyWithImpl<$Res, RadiusSet>;
  @useResult
  $Res call(
      {String none,
      String sm,
      String md,
      String lg,
      String xl,
      String full,
      Map<String, String> custom});
}

/// @nodoc
class _$RadiusSetCopyWithImpl<$Res, $Val extends RadiusSet>
    implements $RadiusSetCopyWith<$Res> {
  _$RadiusSetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? none = null,
    Object? sm = null,
    Object? md = null,
    Object? lg = null,
    Object? xl = null,
    Object? full = null,
    Object? custom = null,
  }) {
    return _then(_value.copyWith(
      none: null == none
          ? _value.none
          : none // ignore: cast_nullable_to_non_nullable
              as String,
      sm: null == sm
          ? _value.sm
          : sm // ignore: cast_nullable_to_non_nullable
              as String,
      md: null == md
          ? _value.md
          : md // ignore: cast_nullable_to_non_nullable
              as String,
      lg: null == lg
          ? _value.lg
          : lg // ignore: cast_nullable_to_non_nullable
              as String,
      xl: null == xl
          ? _value.xl
          : xl // ignore: cast_nullable_to_non_nullable
              as String,
      full: null == full
          ? _value.full
          : full // ignore: cast_nullable_to_non_nullable
              as String,
      custom: null == custom
          ? _value.custom
          : custom // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RadiusSetImplCopyWith<$Res>
    implements $RadiusSetCopyWith<$Res> {
  factory _$$RadiusSetImplCopyWith(
          _$RadiusSetImpl value, $Res Function(_$RadiusSetImpl) then) =
      __$$RadiusSetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String none,
      String sm,
      String md,
      String lg,
      String xl,
      String full,
      Map<String, String> custom});
}

/// @nodoc
class __$$RadiusSetImplCopyWithImpl<$Res>
    extends _$RadiusSetCopyWithImpl<$Res, _$RadiusSetImpl>
    implements _$$RadiusSetImplCopyWith<$Res> {
  __$$RadiusSetImplCopyWithImpl(
      _$RadiusSetImpl _value, $Res Function(_$RadiusSetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? none = null,
    Object? sm = null,
    Object? md = null,
    Object? lg = null,
    Object? xl = null,
    Object? full = null,
    Object? custom = null,
  }) {
    return _then(_$RadiusSetImpl(
      none: null == none
          ? _value.none
          : none // ignore: cast_nullable_to_non_nullable
              as String,
      sm: null == sm
          ? _value.sm
          : sm // ignore: cast_nullable_to_non_nullable
              as String,
      md: null == md
          ? _value.md
          : md // ignore: cast_nullable_to_non_nullable
              as String,
      lg: null == lg
          ? _value.lg
          : lg // ignore: cast_nullable_to_non_nullable
              as String,
      xl: null == xl
          ? _value.xl
          : xl // ignore: cast_nullable_to_non_nullable
              as String,
      full: null == full
          ? _value.full
          : full // ignore: cast_nullable_to_non_nullable
              as String,
      custom: null == custom
          ? _value._custom
          : custom // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RadiusSetImpl implements _RadiusSet {
  const _$RadiusSetImpl(
      {this.none = '0',
      this.sm = '4.0',
      this.md = '8.0',
      this.lg = '12.0',
      this.xl = '16.0',
      this.full = '9999',
      final Map<String, String> custom = const {}})
      : _custom = custom;

  factory _$RadiusSetImpl.fromJson(Map<String, dynamic> json) =>
      _$$RadiusSetImplFromJson(json);

  @override
  @JsonKey()
  final String none;
  @override
  @JsonKey()
  final String sm;
  @override
  @JsonKey()
  final String md;
  @override
  @JsonKey()
  final String lg;
  @override
  @JsonKey()
  final String xl;
  @override
  @JsonKey()
  final String full;
  final Map<String, String> _custom;
  @override
  @JsonKey()
  Map<String, String> get custom {
    if (_custom is EqualUnmodifiableMapView) return _custom;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_custom);
  }

  @override
  String toString() {
    return 'RadiusSet(none: $none, sm: $sm, md: $md, lg: $lg, xl: $xl, full: $full, custom: $custom)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RadiusSetImpl &&
            (identical(other.none, none) || other.none == none) &&
            (identical(other.sm, sm) || other.sm == sm) &&
            (identical(other.md, md) || other.md == md) &&
            (identical(other.lg, lg) || other.lg == lg) &&
            (identical(other.xl, xl) || other.xl == xl) &&
            (identical(other.full, full) || other.full == full) &&
            const DeepCollectionEquality().equals(other._custom, _custom));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, none, sm, md, lg, xl, full,
      const DeepCollectionEquality().hash(_custom));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RadiusSetImplCopyWith<_$RadiusSetImpl> get copyWith =>
      __$$RadiusSetImplCopyWithImpl<_$RadiusSetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RadiusSetImplToJson(
      this,
    );
  }
}

abstract class _RadiusSet implements RadiusSet {
  const factory _RadiusSet(
      {final String none,
      final String sm,
      final String md,
      final String lg,
      final String xl,
      final String full,
      final Map<String, String> custom}) = _$RadiusSetImpl;

  factory _RadiusSet.fromJson(Map<String, dynamic> json) =
      _$RadiusSetImpl.fromJson;

  @override
  String get none;
  @override
  String get sm;
  @override
  String get md;
  @override
  String get lg;
  @override
  String get xl;
  @override
  String get full;
  @override
  Map<String, String> get custom;
  @override
  @JsonKey(ignore: true)
  _$$RadiusSetImplCopyWith<_$RadiusSetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
