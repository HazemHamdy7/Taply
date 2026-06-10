// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shadow_definition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShadowDefinition _$ShadowDefinitionFromJson(Map<String, dynamic> json) {
  return _ShadowDefinition.fromJson(json);
}

/// @nodoc
mixin _$ShadowDefinition {
  String get color => throw _privateConstructorUsedError;
  double get offsetX => throw _privateConstructorUsedError;
  double get offsetY => throw _privateConstructorUsedError;
  double get blurRadius => throw _privateConstructorUsedError;
  double get spreadRadius => throw _privateConstructorUsedError;
  double get opacity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShadowDefinitionCopyWith<ShadowDefinition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShadowDefinitionCopyWith<$Res> {
  factory $ShadowDefinitionCopyWith(
          ShadowDefinition value, $Res Function(ShadowDefinition) then) =
      _$ShadowDefinitionCopyWithImpl<$Res, ShadowDefinition>;
  @useResult
  $Res call(
      {String color,
      double offsetX,
      double offsetY,
      double blurRadius,
      double spreadRadius,
      double opacity});
}

/// @nodoc
class _$ShadowDefinitionCopyWithImpl<$Res, $Val extends ShadowDefinition>
    implements $ShadowDefinitionCopyWith<$Res> {
  _$ShadowDefinitionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? color = null,
    Object? offsetX = null,
    Object? offsetY = null,
    Object? blurRadius = null,
    Object? spreadRadius = null,
    Object? opacity = null,
  }) {
    return _then(_value.copyWith(
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      offsetX: null == offsetX
          ? _value.offsetX
          : offsetX // ignore: cast_nullable_to_non_nullable
              as double,
      offsetY: null == offsetY
          ? _value.offsetY
          : offsetY // ignore: cast_nullable_to_non_nullable
              as double,
      blurRadius: null == blurRadius
          ? _value.blurRadius
          : blurRadius // ignore: cast_nullable_to_non_nullable
              as double,
      spreadRadius: null == spreadRadius
          ? _value.spreadRadius
          : spreadRadius // ignore: cast_nullable_to_non_nullable
              as double,
      opacity: null == opacity
          ? _value.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShadowDefinitionImplCopyWith<$Res>
    implements $ShadowDefinitionCopyWith<$Res> {
  factory _$$ShadowDefinitionImplCopyWith(_$ShadowDefinitionImpl value,
          $Res Function(_$ShadowDefinitionImpl) then) =
      __$$ShadowDefinitionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String color,
      double offsetX,
      double offsetY,
      double blurRadius,
      double spreadRadius,
      double opacity});
}

/// @nodoc
class __$$ShadowDefinitionImplCopyWithImpl<$Res>
    extends _$ShadowDefinitionCopyWithImpl<$Res, _$ShadowDefinitionImpl>
    implements _$$ShadowDefinitionImplCopyWith<$Res> {
  __$$ShadowDefinitionImplCopyWithImpl(_$ShadowDefinitionImpl _value,
      $Res Function(_$ShadowDefinitionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? color = null,
    Object? offsetX = null,
    Object? offsetY = null,
    Object? blurRadius = null,
    Object? spreadRadius = null,
    Object? opacity = null,
  }) {
    return _then(_$ShadowDefinitionImpl(
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      offsetX: null == offsetX
          ? _value.offsetX
          : offsetX // ignore: cast_nullable_to_non_nullable
              as double,
      offsetY: null == offsetY
          ? _value.offsetY
          : offsetY // ignore: cast_nullable_to_non_nullable
              as double,
      blurRadius: null == blurRadius
          ? _value.blurRadius
          : blurRadius // ignore: cast_nullable_to_non_nullable
              as double,
      spreadRadius: null == spreadRadius
          ? _value.spreadRadius
          : spreadRadius // ignore: cast_nullable_to_non_nullable
              as double,
      opacity: null == opacity
          ? _value.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShadowDefinitionImpl implements _ShadowDefinition {
  const _$ShadowDefinitionImpl(
      {this.color = '#000000',
      this.offsetX = 0,
      this.offsetY = 0,
      this.blurRadius = 4.0,
      this.spreadRadius = 1.0,
      this.opacity = 0.3});

  factory _$ShadowDefinitionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShadowDefinitionImplFromJson(json);

  @override
  @JsonKey()
  final String color;
  @override
  @JsonKey()
  final double offsetX;
  @override
  @JsonKey()
  final double offsetY;
  @override
  @JsonKey()
  final double blurRadius;
  @override
  @JsonKey()
  final double spreadRadius;
  @override
  @JsonKey()
  final double opacity;

  @override
  String toString() {
    return 'ShadowDefinition(color: $color, offsetX: $offsetX, offsetY: $offsetY, blurRadius: $blurRadius, spreadRadius: $spreadRadius, opacity: $opacity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShadowDefinitionImpl &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.offsetX, offsetX) || other.offsetX == offsetX) &&
            (identical(other.offsetY, offsetY) || other.offsetY == offsetY) &&
            (identical(other.blurRadius, blurRadius) ||
                other.blurRadius == blurRadius) &&
            (identical(other.spreadRadius, spreadRadius) ||
                other.spreadRadius == spreadRadius) &&
            (identical(other.opacity, opacity) || other.opacity == opacity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, color, offsetX, offsetY, blurRadius, spreadRadius, opacity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShadowDefinitionImplCopyWith<_$ShadowDefinitionImpl> get copyWith =>
      __$$ShadowDefinitionImplCopyWithImpl<_$ShadowDefinitionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShadowDefinitionImplToJson(
      this,
    );
  }
}

abstract class _ShadowDefinition implements ShadowDefinition {
  const factory _ShadowDefinition(
      {final String color,
      final double offsetX,
      final double offsetY,
      final double blurRadius,
      final double spreadRadius,
      final double opacity}) = _$ShadowDefinitionImpl;

  factory _ShadowDefinition.fromJson(Map<String, dynamic> json) =
      _$ShadowDefinitionImpl.fromJson;

  @override
  String get color;
  @override
  double get offsetX;
  @override
  double get offsetY;
  @override
  double get blurRadius;
  @override
  double get spreadRadius;
  @override
  double get opacity;
  @override
  @JsonKey(ignore: true)
  _$$ShadowDefinitionImplCopyWith<_$ShadowDefinitionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
