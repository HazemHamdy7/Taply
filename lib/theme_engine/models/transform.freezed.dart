// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transform.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Transform _$TransformFromJson(Map<String, dynamic> json) {
  return _Transform.fromJson(json);
}

/// @nodoc
mixin _$Transform {
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  double get rotation => throw _privateConstructorUsedError;
  double get scaleX => throw _privateConstructorUsedError;
  double get scaleY => throw _privateConstructorUsedError;
  double get skewX => throw _privateConstructorUsedError;
  double get skewY => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransformCopyWith<Transform> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransformCopyWith<$Res> {
  factory $TransformCopyWith(Transform value, $Res Function(Transform) then) =
      _$TransformCopyWithImpl<$Res, Transform>;
  @useResult
  $Res call(
      {double x,
      double y,
      double rotation,
      double scaleX,
      double scaleY,
      double skewX,
      double skewY});
}

/// @nodoc
class _$TransformCopyWithImpl<$Res, $Val extends Transform>
    implements $TransformCopyWith<$Res> {
  _$TransformCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? rotation = null,
    Object? scaleX = null,
    Object? scaleY = null,
    Object? skewX = null,
    Object? skewY = null,
  }) {
    return _then(_value.copyWith(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      rotation: null == rotation
          ? _value.rotation
          : rotation // ignore: cast_nullable_to_non_nullable
              as double,
      scaleX: null == scaleX
          ? _value.scaleX
          : scaleX // ignore: cast_nullable_to_non_nullable
              as double,
      scaleY: null == scaleY
          ? _value.scaleY
          : scaleY // ignore: cast_nullable_to_non_nullable
              as double,
      skewX: null == skewX
          ? _value.skewX
          : skewX // ignore: cast_nullable_to_non_nullable
              as double,
      skewY: null == skewY
          ? _value.skewY
          : skewY // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransformImplCopyWith<$Res>
    implements $TransformCopyWith<$Res> {
  factory _$$TransformImplCopyWith(
          _$TransformImpl value, $Res Function(_$TransformImpl) then) =
      __$$TransformImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double x,
      double y,
      double rotation,
      double scaleX,
      double scaleY,
      double skewX,
      double skewY});
}

/// @nodoc
class __$$TransformImplCopyWithImpl<$Res>
    extends _$TransformCopyWithImpl<$Res, _$TransformImpl>
    implements _$$TransformImplCopyWith<$Res> {
  __$$TransformImplCopyWithImpl(
      _$TransformImpl _value, $Res Function(_$TransformImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? rotation = null,
    Object? scaleX = null,
    Object? scaleY = null,
    Object? skewX = null,
    Object? skewY = null,
  }) {
    return _then(_$TransformImpl(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      rotation: null == rotation
          ? _value.rotation
          : rotation // ignore: cast_nullable_to_non_nullable
              as double,
      scaleX: null == scaleX
          ? _value.scaleX
          : scaleX // ignore: cast_nullable_to_non_nullable
              as double,
      scaleY: null == scaleY
          ? _value.scaleY
          : scaleY // ignore: cast_nullable_to_non_nullable
              as double,
      skewX: null == skewX
          ? _value.skewX
          : skewX // ignore: cast_nullable_to_non_nullable
              as double,
      skewY: null == skewY
          ? _value.skewY
          : skewY // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransformImpl implements _Transform {
  const _$TransformImpl(
      {this.x = 0,
      this.y = 0,
      this.rotation = 0,
      this.scaleX = 1.0,
      this.scaleY = 1.0,
      this.skewX = 0,
      this.skewY = 0});

  factory _$TransformImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransformImplFromJson(json);

  @override
  @JsonKey()
  final double x;
  @override
  @JsonKey()
  final double y;
  @override
  @JsonKey()
  final double rotation;
  @override
  @JsonKey()
  final double scaleX;
  @override
  @JsonKey()
  final double scaleY;
  @override
  @JsonKey()
  final double skewX;
  @override
  @JsonKey()
  final double skewY;

  @override
  String toString() {
    return 'Transform(x: $x, y: $y, rotation: $rotation, scaleX: $scaleX, scaleY: $scaleY, skewX: $skewX, skewY: $skewY)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransformImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.rotation, rotation) ||
                other.rotation == rotation) &&
            (identical(other.scaleX, scaleX) || other.scaleX == scaleX) &&
            (identical(other.scaleY, scaleY) || other.scaleY == scaleY) &&
            (identical(other.skewX, skewX) || other.skewX == skewX) &&
            (identical(other.skewY, skewY) || other.skewY == skewY));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, x, y, rotation, scaleX, scaleY, skewX, skewY);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransformImplCopyWith<_$TransformImpl> get copyWith =>
      __$$TransformImplCopyWithImpl<_$TransformImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransformImplToJson(
      this,
    );
  }
}

abstract class _Transform implements Transform {
  const factory _Transform(
      {final double x,
      final double y,
      final double rotation,
      final double scaleX,
      final double scaleY,
      final double skewX,
      final double skewY}) = _$TransformImpl;

  factory _Transform.fromJson(Map<String, dynamic> json) =
      _$TransformImpl.fromJson;

  @override
  double get x;
  @override
  double get y;
  @override
  double get rotation;
  @override
  double get scaleX;
  @override
  double get scaleY;
  @override
  double get skewX;
  @override
  double get skewY;
  @override
  @JsonKey(ignore: true)
  _$$TransformImplCopyWith<_$TransformImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
