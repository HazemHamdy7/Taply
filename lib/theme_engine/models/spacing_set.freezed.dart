// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spacing_set.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SpacingSet _$SpacingSetFromJson(Map<String, dynamic> json) {
  return _SpacingSet.fromJson(json);
}

/// @nodoc
mixin _$SpacingSet {
  String get xs => throw _privateConstructorUsedError;
  String get sm => throw _privateConstructorUsedError;
  String get md => throw _privateConstructorUsedError;
  String get lg => throw _privateConstructorUsedError;
  String get xl => throw _privateConstructorUsedError;
  Map<String, String> get custom => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpacingSetCopyWith<SpacingSet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpacingSetCopyWith<$Res> {
  factory $SpacingSetCopyWith(
          SpacingSet value, $Res Function(SpacingSet) then) =
      _$SpacingSetCopyWithImpl<$Res, SpacingSet>;
  @useResult
  $Res call(
      {String xs,
      String sm,
      String md,
      String lg,
      String xl,
      Map<String, String> custom});
}

/// @nodoc
class _$SpacingSetCopyWithImpl<$Res, $Val extends SpacingSet>
    implements $SpacingSetCopyWith<$Res> {
  _$SpacingSetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? xs = null,
    Object? sm = null,
    Object? md = null,
    Object? lg = null,
    Object? xl = null,
    Object? custom = null,
  }) {
    return _then(_value.copyWith(
      xs: null == xs
          ? _value.xs
          : xs // ignore: cast_nullable_to_non_nullable
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
      custom: null == custom
          ? _value.custom
          : custom // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpacingSetImplCopyWith<$Res>
    implements $SpacingSetCopyWith<$Res> {
  factory _$$SpacingSetImplCopyWith(
          _$SpacingSetImpl value, $Res Function(_$SpacingSetImpl) then) =
      __$$SpacingSetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String xs,
      String sm,
      String md,
      String lg,
      String xl,
      Map<String, String> custom});
}

/// @nodoc
class __$$SpacingSetImplCopyWithImpl<$Res>
    extends _$SpacingSetCopyWithImpl<$Res, _$SpacingSetImpl>
    implements _$$SpacingSetImplCopyWith<$Res> {
  __$$SpacingSetImplCopyWithImpl(
      _$SpacingSetImpl _value, $Res Function(_$SpacingSetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? xs = null,
    Object? sm = null,
    Object? md = null,
    Object? lg = null,
    Object? xl = null,
    Object? custom = null,
  }) {
    return _then(_$SpacingSetImpl(
      xs: null == xs
          ? _value.xs
          : xs // ignore: cast_nullable_to_non_nullable
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
      custom: null == custom
          ? _value._custom
          : custom // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpacingSetImpl implements _SpacingSet {
  const _$SpacingSetImpl(
      {this.xs = '8.0',
      this.sm = '12.0',
      this.md = '16.0',
      this.lg = '24.0',
      this.xl = '32.0',
      final Map<String, String> custom = const {}})
      : _custom = custom;

  factory _$SpacingSetImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpacingSetImplFromJson(json);

  @override
  @JsonKey()
  final String xs;
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
    return 'SpacingSet(xs: $xs, sm: $sm, md: $md, lg: $lg, xl: $xl, custom: $custom)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpacingSetImpl &&
            (identical(other.xs, xs) || other.xs == xs) &&
            (identical(other.sm, sm) || other.sm == sm) &&
            (identical(other.md, md) || other.md == md) &&
            (identical(other.lg, lg) || other.lg == lg) &&
            (identical(other.xl, xl) || other.xl == xl) &&
            const DeepCollectionEquality().equals(other._custom, _custom));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, xs, sm, md, lg, xl,
      const DeepCollectionEquality().hash(_custom));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpacingSetImplCopyWith<_$SpacingSetImpl> get copyWith =>
      __$$SpacingSetImplCopyWithImpl<_$SpacingSetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpacingSetImplToJson(
      this,
    );
  }
}

abstract class _SpacingSet implements SpacingSet {
  const factory _SpacingSet(
      {final String xs,
      final String sm,
      final String md,
      final String lg,
      final String xl,
      final Map<String, String> custom}) = _$SpacingSetImpl;

  factory _SpacingSet.fromJson(Map<String, dynamic> json) =
      _$SpacingSetImpl.fromJson;

  @override
  String get xs;
  @override
  String get sm;
  @override
  String get md;
  @override
  String get lg;
  @override
  String get xl;
  @override
  Map<String, String> get custom;
  @override
  @JsonKey(ignore: true)
  _$$SpacingSetImplCopyWith<_$SpacingSetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
